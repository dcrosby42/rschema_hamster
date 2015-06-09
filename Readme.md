# RSchema-Hamster

Use schemas to define the shape of your immutable data structures.  Combines the declarative data-driven schemas from [RSchema][RSCHEMA-DOC] with the persistent collections from [Hamster][HAMSTER-DOC].

### Baseline

Peek at the examples in this Readme, but head over to RSchema's docs for a much better intro to using Ruby data to define and validate data structures... RSchema-Hamster merely extends RSchema by bringing Hamster's classes into the fold, and you can still mix-and-match Ruby's built-in collections as well as RSchema's DSL for generic and optional values. Likewise, see Hamster's docs for an intro to immutable structures in Ruby.

[![Build Status](https://travis-ci.org/dcrosby42/rschema_hamster.svg?branch=master)](https://travis-ci.org/dcrosby42/rschema_hamster)

## What this gem adds

### Hamster::Hash as a schema
Hamster's immutable Hash structures may be used as schemas, and will be validated using the same algorithm RSchema uses to evaluate Ruby's built-in Hash, with the additional requirement that values are, in fact, Hamster::Hashes.

*Example*:
```ruby
Address = Hamster.hash(
  street: String,
  postal_code: Integer
)

RSchema.validate!(Address, Hamster.hash(street: "187 Drury Ln", postal_code: 1234))
```

### Generic Hashes: consistent key/value types
Use RSchemaHamster::DSL.hamster_hash_of(s1 => s2) to describe a variable-sized Hash whose keys all conform to s1 and whose values conform to s2.

*Example*:
```ruby
PlayerScores = RSchemaHanster.schema {
  hamster_hash_of(String => Integer)
}

RSchema.validate!(PlayerScores, Hamster.hash("Link" => 12, "Samus" => 132))
```

### Hamster::Vector as a schema
Hamster's immutable Vector structures may be used as schemas, and will be validated using the same rules and alternatives RSchema uses to evaluate Ruby's built-in Array, with the additional requirement that values are, in fact, Hamster::Vectors.

Vectors with length > 1 are interprested as tuples, validating Vectors of same length whose nth element validates according to the nth subschema.

```ruby
Token = Hamster.vector(Symbol, String)

RSchema.validate!(Token, Hamster.vector(:keyword, "require"))
```

Single-length Vectors validates a 0-or-more-length Vector whose elements validate according to the single subschema.  

```ruby
Tokens = Hamster.vector(Token)

RSchema.validate!(Tokens, Hamster.vector(
  Hamster.vector(:keyword, "require"),
  Hamster.vector(:quot, "'"),
  Hamster.vector(:string_lit, "rschema_hamster"),
  Hamster.vector(:quot, "'")
))
```


### Hamster::List as a schema
(Actually Hamster::Cons) currently implemented in parallel to Hamster::Vector.  Consider making this a "lazy validated" schema?

### Sets

```ruby
Words = RSchemaHamster.schema {
  hamster_set_of(String)
}
RSchema.validate!(TheSyms, Hamster.set("some", "of", "words"))
```

## Example:

The schema:

```ruby
module OrderReport::Schema
  Name    = String
  Id      = Integer
  Dollars = BigDecimal

  Totals = Hamster.hash(
    gross: Dollars,
    tax:   Dollars,
    fee:   Dollars,
    net:   Dollars,
  )

  OrderRow = Hamster.hash(
    order_id:     Id,
    order_number: Name,
    order_totals: Totals,
  )

  MarketBlock = Hamster.hash(
    market_id:        Id,
    market_name:      Name,
    account_dropdown: RSchemaHamster.schema {
      hamster_hash_of(Name => Id)
    },
    order_rows:       Hamster.vector(OrderRow),
    market_totals:    Totals
  )
end
```

The data (Hamster.from is a convenience that recursively converts Hash and Array to Hamster::Hash and Hamster::Vector):
```ruby
def self.dollars(str); BigDecimal.new(str); end

market_block = Hamster.from(  
  { 
    market_id: 42,
    market_name: "The Restaurant at the End of the Universe",
    account_dropdown: {
      "Hotblack Desiato" => 1, 
      "Zaphod Beeblebrox" => 3
    },
    order_rows: [
      { order_id: 101, order_number: "MILLIWAYS-00101", order_totals: { gross: dollars("120"), tax: dollars("14.4"), fee: dollars("20"), net: dollars("85.6") } },
      { order_id: 102, order_number: "MILLIWAYS-00102", order_totals: { gross: dollars("3030"), tax: dollars("363.6"), fee: dollars("505.10"), net: dollars("2161.3") } },
    ],
    market_totals: { gross: dollars("3150"), tax: dollars("378"), fee: dollars("525.10"), net: dollars("2246.9") }
  }
) 
```

The validation:
```ruby
RSchema.validate!(OrderReport::HamsterSchema::MarketBlock, market_block)
```

[HAMSTER-DOC]: https://github.com/hamstergem/hamster 
[RSCHEMA-DOC]: https://github.com/tomdalling/rschema
