class ApplicationDeserializer
  include ActiveModel::Validations

  @schema = []

  class << self
    attr_accessor :schema

    def inherited(klass)
      # klass.schema = []
      klass.schema = self.schema.dup
    end

    def attribute( name, **args )
      self.schema = self.schema.append(args.merge(name: name))
    end

    def attribute_collection( name, **args )
      self.schema = self.schema.append(args.merge(name: name, collection: true))
    end

    def build_nested_attributes_with_destroy( attributes, records )
      updating_ids = attributes.map{|a| a[:id]}
      deleting_records = records.select{|r| ! updating_ids.include?(r.id)}
      attributes + deleting_records.map{|a| { id: a.id, _destroy: true }}
    end

    def build_nested_attributes_with_assoc_key( attributes, records, assoc_key )
      attributes = attributes.map(&:with_indifferent_access)
      updating_ids = attributes.map{|a| a[assoc_key]}
      deleting_records = records.select{|r| ! updating_ids.include?(r.send(assoc_key))}
      attributes = attributes.map do |hash|
        record = records.detect{|x| hash[assoc_key] == x.send(assoc_key)}
        # puts record
        if record.present?
          hash.merge(id: record.id)
        else
          hash
        end
      end
      attributes + deleting_records.map{|a| { id: a.id, _destroy: true }}
    end
  end

  attr_reader :params, :object
  def initialize( object, params )
    @object = object
    @params = params
  end

  def schema
    self.class.schema
  end

  def attributes
    schema.map do |col|
      name = col[:name]
      collection = col[:collection]
      type = col[:type]
      ignore_if_nil = col[:ignore_if_nil]
      nested_attributes = col[:nested_attributes]

      value = if self.respond_to?(name)
        send(name)
      else
        params.fetch(name, nil)
      end

      if value and (type.is_a? Class and type <= ApplicationDeserializer)
        value = if collection and value.is_a? Enumerable
          value.map{|a| type.new(a).attributes}
        else
          type.new(value).attributes
        end
      end

      if nested_attributes.present?
        records = @object.send(name.to_s.sub(/_attributes\z/, ''))
        value = if nested_attributes.is_a?(Hash) and nested_attributes[:assoc_key]
          self.class.build_nested_attributes_with_assoc_key(value, records, nested_attributes[:assoc_key])
        else
          self.class.build_nested_attributes_with_destroy(value, records)
        end
      end

      if ignore_if_nil and value.nil?
        nil
      else
        [name, value]
      end
    end.compact.to_h
  end

  def set
    validate!
    @object.assign_attributes(attributes)
    @object
  end

  def params_object
    @params_object ||= Hashie::Mash.new(params)
  end
end
