require 'spec_helper'

module OffTheShelf

  # OneTwoThree = RSchema.schema {{
  #   one_two_three: Hamster.vector(1,2,3)
  # }}

  describe "using Hamster classes directly as schemas" do
    it "works same way as normal Ruby classes" do
      RSchema.validate!(Hamster::Vector, Hamster.vector(5,6,7))
      RSchema.validate!({ thing: Hamster::Set}, {thing: Hamster.set(42,42)})
    end
  end

  describe "using Hamster Vectors as a fixed-length schema" do
    let(:schema) { Hamster::Vector[Integer,String,Symbol] }
    let(:value) { Hamster.vector(1,"2", :three) }

    it "behaves like Ruby Arrays" do
      RSchema.validate!(schema, value)
    end

    it "raises for bad match" do
      expect_invalid schema, Hamster.vector(1, 42, :hi),
        failing_value: 42,
        key_path: [1],
        reason: /String/
    end

    it "raises for wrong length" do
      expect_invalid schema, Hamster.vector(1, 42, :hi, :longer),
        reason: /does not have 3/
    end

    it "raises for wrong type" do
      expect_invalid schema, [500, "hi", :a_sym],
        reason: /is not a Hamster::Vector/
    end
  end

  describe "using Hamster Vectors as an n-length schema" do
    let(:schema) { Hamster::Vector[Symbol] }
    let(:nums) { Hamster.vector(:one, :two, :three) }
    let(:single_length) { Hamster.vector(:forty_two) }
    let(:empty_vector) { Hamster.vector }

    it "validates Vectors of numericals" do
      expect_valid schema, nums
    end

    it "validates single-length Vectors" do
      expect_valid schema, single_length
    end

    it "validates empty Vectors" do
      expect_valid schema, empty_vector
    end

    it "rejects wrong type" do
      expect_invalid schema, Hamster.vector(:one,:two,3),
        failing_value: 3,
        key_path: [2],
        reason: /not a Symbol/
    end

    it "rejects nil" do
      expect_invalid schema, nil
    end

  end

    # it "catches violations" do
    #   h = { name: "Dave", number: 38, role: 'monk' }
    #
    #   ok = RSchema.validate(Ez, h)
    #
    #   expect(ok).to be false
    #
    #   err = RSchema.validation_error(Ez, h)
    #   expect(err).to be
    #   expect(err.reason).to eq "is not a valid enum member"
    #   expect(err.failing_value).to eq "monk"
    #   expect(err.key_path).to eq [:role]
    # end

  # end

end
