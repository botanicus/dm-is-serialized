module DataMapper
  module Is
    module Serialized
      module Filters
        # superclass for all filter
        class SerializeFilter
          # record: object of model (just in serialize)
          # name: symbol with property name
          attr_accessor :record, :name
          def property
            @record.class.properties[@name]
          end

          def relationship(name)
            @record.class.relationships[@name]
          end
        end

        # serialize: true => 1, false => 0
        class BooleanSerializeFilter < SerializeFilter
          def serialize(data)
            data ? 1 : 0
          end

          def deserialize(data)
            data.to_i == 1
          end
        end

        # serialize: :product => product_id
        class ModelSerializeFilter < SerializeFilter
          # serialize(:product)
          def serialize(record)
            record.id unless record.nil?
          end

          # product_id => id
          def deserialize(id)
            model = Object.const_get(@name.to_s.camel_case)
            model.get!(id)
          end
        end

        # called when any filter found
        class GeneralSerializeFilter < SerializeFilter
          def serialize(data)
            raise "Data too long" if data.to_s.length > 20
            return data
          end

          def deserialize(data)
            return data
          end
        end
      end
    end
  end
end
