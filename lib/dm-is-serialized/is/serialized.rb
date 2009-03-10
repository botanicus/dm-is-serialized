require Pathname(__FILE__).dirname.expand_path/'filters'

module DataMapper
  module Is
    module Serialized
      def self.included(base)
      end

      def is_serialized(options = Hash.new)
        # Add class-methods
        extend  DataMapper::Is::Serialized::ClassMethods
        # Add instance-methods
        include DataMapper::Is::Serialized::InstanceMethods
        include DataMapper::Is::Serialized::Filters
      end

      module ClassMethods
        include DataMapper::Is::Serialized::Filters
        attr_accessor :serialized_properties

        # serialize_property :size, BooleanSerializedFilter
        def serialize_property(property, filter = GeneralSerializeFilter)
          self.serialized_properties ||= Array.new
          self.serialized_properties.push([property, filter])
          self.serialized_properties.uniq!
        end

        # serialize_properties :product, :count
        # serialize_properties :product, :count, GeneralSerializeFilter
        def serialize_properties(*properties)
          self.serialized_properties ||= Array.new
          filter = properties.last.class.eql?(Class) ? properties.pop : GeneralSerializeFilter
          properties.each do |property|
            self.serialized_properties.push([property, filter])
          end
          self.serialized_properties.uniq!
        end

        def deserialize(data)
          params = Hash.new
          data.split(",").each do |data|
            self.serialized_properties.each do |property_name, filter_class|
              filter = filter_class.new
              filter.name = property_name
              value  = filter.deserialize(data)
              value.nil? ? raise(TypeError) : value
              params[property_name] = value
            end
          end
          return self.new(params)
        end
      end

      module InstanceMethods
        # @product.serialize => #<Product ...>
        def serialize
          self.class.serialized_properties.map do |property_name, filter_class|
            filter = filter_class.new
            filter.record = self
            data   = self.send(property_name)
            value  = filter.serialize(data)
            value.nil? ? raise(TypeError) : value
          end.join(",")
        end
      end
    end
  end
end
