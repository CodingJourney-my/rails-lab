class ApplicationSerializer

  @schema = []
  class_attribute :base_model_hint

  class << self
    attr_accessor :schema

    def inherited(klass)
      klass.schema = self.schema.dup
    end

    def spawn(&block)
      Class.new(self, &block)
    end

    def attribute( name, **args )
      self.schema = self.schema.append(args.merge(name: name))
    end

    def attribute_collection( name, **args )
      self.schema = self.schema.append(args.merge(name: name, collection: true))
    end

    def openapi_schema(model=nil)
      model ||= self.base_model_hint || self.module_parent
      properties = self.schema.map do |col|
        name, collection, type, description, enum, nullable = col.values_at(:name, :collection, :type, :description, :enum, :nullable)

        subschema = if type.is_a?(Class) and type <= ApplicationSerializer
          type.openapi_schema
        elsif type.present?
          {type: type}
        else
          detected_type = model <= ActiveRecord::Base ?
            model.type_for_attribute(name).type :
            nil
          t,f = case detected_type
            in :date | :datetime => f then [:string, f]
            in :float then [:number, :float]
            in :decimal then [:number, :double]
            in :text then [:string, nil]
            else [detected_type, nil]
            end
          {type: (t || "string").to_s, format: f && f.to_s}
        end
        if model <= ActiveRecord::Base and model.type_for_attribute(name).is_a?(ActiveRecord::Enum::EnumType)
          subschema = {type: "string", enum: model.public_send(name.to_s.pluralize).keys}
        end
        if collection
          subschema = {type: "array", items: subschema}
        end
        if nullable.nil?
          nullable = true
          if model <= ActiveRecord::Base and model.column_names.include?(name.to_s)
            nullable = model.column_for_attribute(name).null
          end
          if collection
            nullable = false
          end
        end

        subschema = subschema.reverse_merge(description: description, enum: enum, nullable: nullable)

        [name, subschema.select{|k,v| v.present?}]
      end.to_h

      {
        type: "object", properties: properties, 
        required: self.schema.map{|a| a[:name].to_s},
      }
    end
  end

  attr_reader :object
  def initialize( object )
    @object = if object.is_a? Hash
      Hashie::Mash.new(object)
    else
      object
    end
  end

  def attributes
    self.class.schema.map do |col|
      name = col[:name]
      collection = col[:collection]
      type = col[:type]

      value = if self.respond_to?(name)
        send(name)
      else
        object&.send(name)
      end

      if value and (type.is_a? Class and type <= ApplicationSerializer)
        value = if collection and value.is_a? Enumerable
          value.map{|a| type.new(a).attributes}
        else
          type.new(value).attributes
        end
      end

      [name, value]
    end.to_h
  end

  def to_json
    attributes.to_json
  end


end
