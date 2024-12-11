module Openapi

  class Generator
    attr_reader :routes
    def initialize(definition={})
      @definition = definition || {}
      @routes = []
    end

    def <<(route)
      @routes << route
    end

    def paths
      @routes.reduce({}){|acc,r| 
        acc[r.path] ||= {}
        acc[r.path][r.verb] = r.attributes
        acc
      }
    end

    def attributes
      @definition.merge(paths: paths)
    end

    def to_yaml
      attributes.deep_stringify_keys.to_yaml
    end
  end

  class Route
    attr_reader :path, :verb
    attr_accessor :summary, :consumes, :produces, :parameters, :request_body, :responses, :description
    def initialize(path, verb, summary: nil, consumes: nil, produces: nil, parameters: nil, request_body: nil, responses: nil, description: nil)
      @path = path
      @verb = verb
      @summary = summary
      @consumes = Array.wrap(consumes)
      @produces = Array.wrap(produces)
      @parameters = Array.wrap(parameters)
      @request_body = request_body
      @responses = ResponseList.new(Array.wrap(responses))
      @description = description
    end

    def responses_attributes
      @responses.map{|r| r.respond_to?(:attributes) ? r.attributes : r}.reduce({}){|acc, r| acc.merge(r)}
    end

    def attributes
      list = [
        [:summary, @summary],
        [:description, @description],
        [:consumes, @consumes],
        [:produces, @produces],
      ]
      
      if @parameters.present?
        list << [:parameters, @parameters.map{|a| a.respond_to?(:attributes) ? a.attributes : a}]
      end
      if @request_body.present?
        list << [:requestBody, @request_body.respond_to?(:attributes) ? @request_body.attributes : @request_body]
      end
      if @responses.present?
        list << [:responses, responses_attributes]
      end
      list.to_h
    end

    def format(status, format)
      r = responses[status]
      return nil unless r
      r.formats[format]
    end

    class ResponseList < Array
      def [](key)
        self.find{|a| a.status == key}
      end
    end
  end

  class Parameter
    def initialize(name, locate_in, required: false, description: nil, example: nil)
      @name = name
      @locate_in = locate_in
      @required = required
      @description = description
      @example = example
    end

    def attributes
      list = [
        [:name, @name],
        [:in, @locate_in],
        [:required, @required],
      ]
      list << [:description, @description] if @description.present?
      list << [:example, @example] if @example.present?
      list.to_h
    end
  end

  class RequestBody
    def self.build_from_example(example, content_type:, description: nil, required: true)
      schema = Openapi::Schema.build(example)
      f = DataFormat.new(content_type, schema, example: example)
      new(f, required: required, description: description)
    end

    def initialize(formats, required: true, description: nil)
      @formats = Array.wrap(formats)
      @required = required
      @description = description
    end

    def attributes
      {
        required: @required,
        description: @description,
        content: @formats.map{|f| [f.content_type, f.attributes]}.to_h
      }
    end
  end

  class Response
    # def self.json_200(schema, example: nil, description: nil)
    #   f = DataFormat.new("application/json", schema, example: example)
    #   new(f, description: description)
    # end
    def self.build(status, content_type, description: nil, example: nil)
      schema = yield
      f = DataFormat.new(content_type, schema, example: example)
      new(f, status: status, description: description)
    end

    attr_reader :status, :formats
    def initialize(formats, status: 200, description: nil)
      @formats = FormatList.new(Array.wrap(formats))
      @status = status
      @description = description
    end

    def attributes
      {
        @status.to_s.to_sym => {
          description: @description,
          content: @formats.map{|f| [f.content_type, f.attributes]}.to_h
        }
      }
    end

    class FormatList < Array
      def [](key)
        self.find{|a| a.content_type == key}
      end
    end
  end

  class DataFormat
    attr_reader :content_type
    attr_accessor :schema, :example
    def initialize(content_type, schema, example: nil)
      @content_type = content_type
      @schema = schema
      @example = example
    end

    def attributes
      {
        schema: schema.respond_to?(:attributes) ? schema.attributes : schema,
        example: normalized_example,
      }
    end

    def replace_schema(new_schema, field_name=nil)
      self.schema = if field_name
        s = schema.deep_dup.deep_symbolize_keys
        ref = (s[:properties] || {})[field_name.to_sym] || {}
        (s[:properties] || {})[field_name.to_sym] = if ref[:type] == 'array'
          ref.merge(items: new_schema)
        else
          new_schema
        end
        s
      else
        new_schema
      end
      self
    end

    def normalized_example
      return example unless example.is_a?(Enumerable)
      example.map{|k, v|
        v = nil if v.is_a?(IO)
        [k, v]
      }.to_h
    end

    def normalize_example(field_name=nil)
      self.example = if field_name
        e = example.deep_dup.deep_symbolize_keys
        ref = e[field_name.to_sym]
        e[field_name.to_sym] = ref.is_a?(Array) ? ref.first(2) : ref
        e
      else
        example.is_a?(Array) ? example.first(2) : example
      end
      self
    end
  end

  class Schema
    def self.build(obj)
      case obj
      when Array
        {type: 'array', items: obj.map{|a| build(a)}}
      when Hash
        {type: 'object', properties: obj.map{|k,v| [k, build(v)]}.to_h}
      when Numeric
        {type: 'number'}
      when TrueClass, FalseClass
        {type: 'boolean'}
      when IO
        {type: 'string', format: 'binary'}
      else
        {type: 'string'}
      end
    end
  end
end
