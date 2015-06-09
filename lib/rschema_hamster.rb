require 'rschema'
require 'hamster'
require 'rschema_hamster/hamster_ext'
require 'rschema_hamster/dsl'

module RSchemaHamster
  def self.schema(dsl=RSchemaHamster::DSL, &block)
    RSchema.schema(dsl, &block)
  end
end
