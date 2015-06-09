require 'rschema_hamster'

# 'require' this file to extend RSchema's DSL with RSchema-Hamster's own DSL methods.
# Provides more convenient access to the full set of DSL methods (hash_of AND hamster_hash_of, etc.) by typing 
#   RSchema.schema { ... } 
# instead of
#   RSchema.schema(RSchemaHamster::DSL) { ... }
# ...at the expense of monkey-patching RSchema's DSL module, which shouldn't really cause problems, but would be rude to presume on.
module RSchema
  module DSL
    extend RSchemaHamster::DSL::Base
  end
end
