# RSchema-Hamster

Extends [RSchema][RSCHEMA-DOC] to support [Hamster's][HAMSTER-DOC] immutable Hash, Vector, List and Set structures.

[![Build Status](https://travis-ci.org/dcrosby42/rschema_hamster.svg?branch=master)](https://travis-ci.org/dcrosby42/rschema_hamster)

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
* Test DSL:
** _?
** maybe
** hamster_hash_of
** hamster_set_of - Hasmter::Set -(GenericHamsterSetSchema)
** enum

TODO:

Project:
* Proper readme
* .gem

Implement someday:

* Structs
* Hamsterdam::Struct

[HAMSTER-DOC]: https://github.com/hamstergem/hamster 
[RSCHEMA-DOC]: https://github.com/tomdalling/rschema
