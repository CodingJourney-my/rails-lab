module Openapi
  # client = Openapi::ApiClient.new(origin: 'https://shinoken.reivo.info', token: 'test', content_type: 'application/json')
  # req = client.build_request(:get, '/api/v1/residentapp/home')
  # req.execute!

  # Openapi::ApiRequest.new(:get, '/api/v1/refresh', headers: {"Authorization" => "Bearer token"}, origin: 'https://shinoken.reivo.info')
  class ApiRequest
    attr_reader :verb, :path, :headers, :params, :request_body, :origin
    def initialize(verb, path, headers: {}, params: {}, request_body: {}, origin: nil)
      @verb = verb
      @path = path
      @headers = headers
      @params = params
      @request_body = request_body
      @origin = origin
    end

    def url
      "#{origin}#{path}"
    end

    def verb_writing?
      [:post, :patch, :put, :delete].include?(verb.to_s.downcase.to_sym)
    end

    def to_http_request
      uri = URI.parse(url)
      request = if verb_writing?
        req_class = "Net::HTTP::#{verb.to_s.camelize}".constantize
        req = req_class.new(uri)
        if headers["Content-Type"] == "application/json"
          req.body = request_body.to_json
        elsif headers["Content-Type"] == "multipart/form-data"
          req.set_form(request_body.stringify_keys.to_a, 'multipart/form-data')
        else
          req.body = request_body
        end
        req
      else
        uri.query = URI.encode_www_form(params)
        Net::HTTP::Get.new(uri)
      end

      headers.each do |k,v|
        request[k.to_s] = v
      end
      [uri, request]
    end

    def execute!
      uri, req = to_http_request
      res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(req)
      end
      Openapi::ApiResponse.new(res)
    end

    def rails_route
      Openapi::RailsRoute.find(path, verb)
    end

    def to_openapi_route
      rr = rails_route
      common_params = {
        consumes: verb_writing? ? headers["Content-Type"] : nil,
      }
      if rr
        params = common_params.merge(
          summary: rr.summary, 
          produces: rr.content_type,
          # parameters: rr.path_variables.map{|v| {name: v.to_s, in: "path", required: true}}
        )
        Openapi::Route.new(rr.path, verb, **params)
      else
        Openapi::Route.new(path, verb, **common_params)
      end
    end

    def promote(klass)
      klass.new(self)
    end
  end

  class Openapi::ApiResponse
    attr_reader :res
    delegate_missing_to :res
    def initialize(res)
      @res = res
    end

    def content_type
      self["content-type"]
    end

    def format
      content_type.split(';').first
    end

    def result
      if format.starts_with?("application/json")
        JSON.parse(res.body)
      else
        res.body
      end
    end

    def result_object
      Hashie::Mash.new(result)
    end

    def to_schema
      # to_schema_item(result)
      Openapi::Schema.build(result)
    end

    # def to_schema_item(obj)
    #   case obj
    #   when Array
    #     {type: 'array', items: obj.map{|a| to_schema_item(a)}}
    #   when Hash
    #     {type: 'object', properties: obj.map{|k,v| [k, to_schema_item(v)]}.to_h}
    #   when Numeric
    #     {type: 'number'}
    #   when TrueClass, FalseClass
    #     {type: 'boolean'}
    #   else
    #     {type: 'string'}
    #   end
    # end

    def to_openapi_data_format
      Openapi::DataFormat.new(format, to_schema, example: result)
    end

    def to_openapi_response(description=nil)
      description ||= res.code == '200' ? 'Success' : nil
      Openapi::Response.new(to_openapi_data_format, status: res.code, description: description)
    end
  end

  class ApiClient
    def initialize(origin:, token:, content_type: nil, common_headers: [])
      @origin = origin
      @token = token
      @content_type = content_type
      @common_headers = common_headers || []
    end

    def common_headers
      list = @common_headers
      list << ["Authorization", "Bearer #{@token}"] if @token.present?
      list << ["Content-Type", @content_type] if @content_type.present?
      list.to_h
    end

    def build_headers(headers)
      common_headers.merge(headers)
    end

    def build_request(verb, path, headers: {}, params: {}, request_body: {})
      Openapi::ApiRequest.new(verb, path, 
        headers: build_headers(headers), 
        params: params, 
        request_body: request_body, 
        origin: @origin
      )
    end
  end
end
