require_relative "../spec/environment"

module OrderReport; end

module OrderReport::RubySchema
  Name    = String
  Id      = Integer
  Dollars = BigDecimal

  Totals = {
    owed:         Dollars,
    order_total:  Dollars,
    delivery_fee: Dollars,
    market_fee:   Dollars,
  }

  OrderRow = {
    order_id:     Id,
    order_number: Name,
    order_totals: Totals,
  }

  AccountOption = [ [ Name, Id ] ]

  MarketBlock = {
    market_id:        Id,
    market_name:      Name,
    account_dropdown: [ AccountOption ],
    order_rows:       [ OrderRow ],
    market_totals:    Totals
  }
end

module OrderReport::HamsterSchema
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

  AccountOption = Hamster.vector(Name, Id)

  MarketBlock = Hamster.hash(
    market_id:        Id,
    market_name:      Name,
    account_dropdown: Hamster.vector(AccountOption),
    order_rows:       Hamster.vector(OrderRow),
    market_totals:    Totals
  )
end

def self.dollars(str); BigDecimal.new(str); end

market_block = Hamster.from(
  { 
    market_id: 42,
    market_name: "The Restaurant at the End of the Universe",
    account_dropdown: [
      [ "Hotblack Desiato", 1 ], 
      [ "Zaphod Beeblebrox", 3 ]
    ],
    order_rows: [
      { order_id: 101, order_number: "MILLIWAYS-00101", order_totals: { gross: dollars("120"), tax: dollars("14.4"), fee: dollars("20"), net: dollars("85.6") } },
      { order_id: 102, order_number: "MILLIWAYS-00102", order_totals: { gross: dollars("3030"), tax: dollars("363.6"), fee: dollars("505.10"), net: dollars("2161.3") } },
    ],
    market_totals: { gross: dollars("3150"), tax: dollars("378"), fee: dollars("525.10"), net: dollars("2246.9") }
  }
) 

RSchema.validate!(OrderReport::HamsterSchema::MarketBlock, market_block)

Name = String
PageNumber = Integer

Appearances = Hamster.vector(
  Hamster.hash(character: Name, page: PageNumber)
)

guide = Hamster.vector(
  Hamster.hash(character: "Arthur", page: 1), 
  Hamster.hash(character: "Zaphod", page: 98)
)

RSchema.validate!(Appearances, guide)

ford = Hamster.hash(name: "Ford Prefect", gender: :male)
arthur = ford.put(:name, "Arthur Dent")

binding.pry

