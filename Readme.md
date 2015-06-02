# RSchema-Hamster

Extends [RSchema][RSCHEMA-DOC] to support [Hamster's][HAMSTER-DOC] immutable Hash, Vector, List and Set structures.

```ruby
Email = String
PostalCode = String

Person = Hamster.hash(
  name: String,
  email: Email
)

Address = Hamster.hash(
  street: String,
  postal_code: PostalCode
)

Contact = Hamster.hash(
  person: Person,
  addresses: Hamster.vector(Address)
)

ContactList = Hamster.vector(Contact)
```

DONE:

* Hamster::Vector
* Hamster::Hash - known keys
* Hamster::List 
* DSL:
** hamster_hash_of
** hamster_set_of - Hasmter::Set -(GenericHamsterSetSchema)

TODO:

Project:
* Proper readme
* .gem

Implement: 

* Mix of Hamster and normal Ruby schemas
* DSL:
** _?
** set_of
** predicate
** maybe
** enum
** boolean

Implement someday:

* Structs
* Hamsterdam::Struct

[HAMSTER-DOC]: https://github.com/hamstergem/hamster 
[RSCHEMA-DOC]: https://github.com/tomdalling/rschema
