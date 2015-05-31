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
