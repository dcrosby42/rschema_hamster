require 'spec_helper'

module BasicRSchema

  Ez = RSchema.schema {{
    name: String,
    number: Integer,
    role: enum(["mom","dad"])
  }}

  describe "Basic RSchema usage" do
    it "can use classes as schemas" do
      RSchema.validate!(Integer, 1)
      RSchema.validate!(String, "hi")
    end

    it "validates correct hash structures" do
      h = { name: "Dave", number: 38, role: 'dad' }

      RSchema.validate!(Ez, h)
    end

    it "catches violations" do
      h = { name: "Dave", number: 38, role: 'monk' }

      ok = RSchema.validate(Ez, h)

      expect(ok).to be false

      err = RSchema.validation_error(Ez, h)
      expect(err).to be
      expect(err.reason).to eq "is not a valid enum member"
      expect(err.failing_value).to eq "monk"
      expect(err.key_path).to eq [:role]
    end

  end

end
