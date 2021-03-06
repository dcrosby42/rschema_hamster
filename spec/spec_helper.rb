require_relative "environment"

module RSchemaHamsterSpecHelpers
  def expect_valid(schema, value)
    result = RSchema.validate!(schema, value)
    expect(result).to eq value
    value
  end

  def expect_invalid(schema, value, opts={})
    error_details = RSchema.validation_error(schema, value)
    expect(error_details).to be
    
    # error_details.failing_value #=> :blond
    # error_details.reason #=> "is not a valid enum member"
    # error_details.key_path #=> [2, :hair]
    # error_details.to_s #=
    opts.keys.each do |key|
      expected_val = opts[key]
      case expected_val
      when Regexp
        expect(error_details.send(key)).to match opts[key]
      else
        expect(error_details.send(key)).to eq opts[key]
      end
    end
    error_details
  end

end

RSpec.configure do |config|
  config.include RSchemaHamsterSpecHelpers
end

