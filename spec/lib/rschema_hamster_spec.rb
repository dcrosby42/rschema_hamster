require 'spec_helper'

describe "RSchema extended for Hamster immutable types" do
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
    let(:schema) { Hamster.vector(Symbol) }
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

    it "validates Vectors in Vectors" do
      schema = Hamster.vector(
        Hamster.vector(String),
        Hamster.vector(Integer),
        Hamster.vector(Symbol))

      value = Hamster.vector(
        Hamster.vector("a","b","c"),
        Hamster.vector(1,2,3),
        Hamster.vector(:birds, :bees, :puppies))

      expect_valid schema, value
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

  describe "using Hamster List as a fixed-length schema" do
    let(:schema) { Hamster::List[Integer,String,Symbol] }
    let(:value) { Hamster.list(1,"2", :three) }

    it "behaves like Ruby Arrays" do
      RSchema.validate!(schema, value)
    end

    it "raises for bad match" do
      expect_invalid schema, Hamster.list(1, 42, :hi),
        failing_value: 42,
        key_path: [1],
        reason: /String/
    end

    it "raises for wrong length" do
      expect_invalid schema, Hamster.list(1, 42, :hi, :longer),
        reason: /does not have 3/
    end

    it "raises for wrong type" do
      expect_invalid schema, [500, "hi", :a_sym],
        reason: /is not a Hamster List/
    end
  end

  describe "using Hamster List as an n-length schema" do
    let(:schema) { Hamster.list(Symbol) }
    let(:nums) { Hamster.list(:one, :two, :three) }
    let(:single_length) { Hamster.list(:forty_two) }
    let(:empty_list) { Hamster.list }

    it "validates Lists of numericals" do
      expect_valid schema, nums
    end

    it "validates single-length Lists" do
      expect_valid schema, single_length
    end

    it "validates empty Lists" do
      expect_valid schema, empty_list
    end

    it "validates Lists in Lists" do
      schema = Hamster.list(
        Hamster.list(String),
        Hamster.list(Integer),
        Hamster.list(Symbol))

      value = Hamster.list(
        Hamster.list("a","b","c"),
        Hamster.list(1,2,3),
        Hamster.list(:birds, :bees, :puppies))

      expect_valid schema, value
    end

    it "rejects wrong type" do
      expect_invalid schema, Hamster.list(:one,:two,3),
        failing_value: 3,
        key_path: [2],
        reason: /not a Symbol/
    end

    it "rejects nil" do
      expect_invalid schema, nil
    end
  end

  # Mixing Vectors and Lists

  # Hamster::Vectors using other RSchema schemas:
  # - enum
  # - boolean
  
  describe ""

  describe "Hamster Hashes with known keys" do
    let(:schema) {
      Hamster.hash(
        name: String,
        age: Integer,
        role: Symbol
      )
    }

    let(:correct_value) {
      Hamster.hash(name: "Dave", age: 38, role: :dev)
    }

    it "validates correctly structure hashes" do
      expect_valid schema, correct_value
    end

    it "rejects missing keys" do
      bad = correct_value.delete(:age)
      expect_invalid schema, bad, 
        reason: /missing required keys.*:age/
    end

    it "rejects extraneous keys" do
      bad = correct_value.put(:pet, "indy")
      expect_invalid schema, bad,
        reason: /extraneous key.*:pet/
    end

    it "rejects bad values" do
      bad = correct_value.put(:name, 85)
      expect_invalid schema, bad,
        failing_value: 85,
        key_path: [:name],
        reason: /not a String/
    end
  end

  # Hashes using other RSchema schemas:
  # - enum
  # - boolean
  # - optional keys
  

  # Hashes with variable keys

  # Hashes w Vectors
  # Vectors w Hashes
  # Hashes w Hashes


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
