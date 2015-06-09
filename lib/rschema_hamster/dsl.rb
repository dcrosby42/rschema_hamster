module RSchemaHamster
  module DSL
    module Base
      def hamster_hash_of(subschemas_hash)
        raise InvalidSchemaError unless subschemas_hash.size == 1
        GenericHamsterHashSchema.new(
          subschemas_hash.keys.first, 
          subschemas_hash.values.first)
      end

      def hamster_set_of(subschema)
        GenericHamsterSetSchema.new(subschema)
      end
    end
    extend Base
    extend RSchema::DSL::Base # bring along RSchema's maybe, hash_of, set_of etc.
  end
  
  GenericHamsterHashSchema = Struct.new(:key_subschema, :value_subschema) do
    def schema_walk(value, mapper)
      if not value.is_a?(Hamster::Hash)
        return RSchema::ErrorDetails.new(value, 'is not a Hamster::Hash')
      end

      value.reduce(Hamster.hash) do |accum, (k, v)|
        # walk key
        k_walked, error = RSchema.walk(key_subschema, k, mapper)
        break error.extend_key_path('.keys') if error

        # walk value
        v_walked, error = RSchema.walk(value_subschema, v, mapper)
        break error.extend_key_path(k) if error

        accum.put(k_walked, v_walked)
      end
    end
  end

  GenericHamsterSetSchema = Struct.new(:subschema) do
    def schema_walk(value, mapper)
      return RSchema::ErrorDetails.new(value, 'is not a Hamster::Set') if not value.is_a?(Hamster::Set)

      value.reduce(Hamster.set) do |accum, subvalue|
        subvalue_walked, error = RSchema.walk(subschema, subvalue, mapper)
        break error.extend_key_path('.values') if error

        accum.add subvalue_walked
      end
    end
  end
end

