require 'rschema'
require 'hamster'

class Hamster::Vector
  def schema_walk(value, mapper)
    fixed_size = (self.size != 1)

    if not value.is_a?(Hamster::Vector)
      RSchema::ErrorDetails.new(value, 'is not a Hamster::Vector')
    elsif fixed_size && value.size != self.size
      RSchema::ErrorDetails.new(value, "does not have #{self.size} elements")
    else
      value.each.with_index.map do |subvalue, idx|
        subschema = (fixed_size ? self[idx] : first)
        subvalue_walked, error = RSchema.walk(subschema, subvalue, mapper)
        break error.extend_key_path(idx) if error
        subvalue_walked
      end
    end
  end
end

class Hamster::Cons
  def schema_walk(value, mapper)
    fixed_size = (self.size != 1)

    if value == Hamster::EmptyList and !fixed_size
      value
    elsif not value.is_a?(Hamster::Cons)
      RSchema::ErrorDetails.new(value, 'is not a Hamster List')
    elsif fixed_size && value.size != self.size
      RSchema::ErrorDetails.new(value, "does not have #{self.size} elements")
    else
      value.each.with_index.map do |subvalue, idx|
        subschema = (fixed_size ? self[idx] : first)
        subvalue_walked, error = RSchema.walk(subschema, subvalue, mapper)
        break error.extend_key_path(idx) if error
        subvalue_walked
      end
    end
  end
end

class Hamster::Hash
  def schema_walk(value, mapper)
    return RSchema::ErrorDetails.new(value, 'is not a Hash') if not value.is_a?(Hamster::Hash)

    # extract details from the schema
    required_keys = Set.new
    all_subschemas = {}
    each do |(k, subschema)|
      if k.is_a?(RSchema::OptionalHashKey)
        all_subschemas[k.key] = subschema
      else
        required_keys << k
        all_subschemas[k] = subschema
      end
    end

    # check for extra keys that shouldn't be there
    extraneous = value.keys.reject{ |k| all_subschemas.has_key?(k) }
    if extraneous.size > 0
      return RSchema::ErrorDetails.new(value, "has extraneous keys: #{extraneous.to_a.inspect}")
    end

    # check for required keys that are missing
    missing_requireds = required_keys.reject{ |k| value.has_key?(k) }
    if missing_requireds.size > 0
      return RSchema::ErrorDetails.new(value, "is missing required keys: #{missing_requireds.to_a.inspect}")
    end

    # walk the subvalues
    value.reduce(Hamster.hash) do |accum, (k, subvalue)|
      subvalue_walked, error = RSchema.walk(all_subschemas[k], subvalue, mapper)
      break error.extend_key_path(k) if error
      accum.put(k, subvalue_walked)
    end
  end
end
