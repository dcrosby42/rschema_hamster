lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'rschema_hamster/version'

Gem::Specification.new do |s|
  s.name        = 'rschema_hamster'
  s.summary     = "RSchema extension to support Hamster's immutable Hash, Vector, List, Set"
  s.homepage    = 'https://github.com/dcrosby42/rschema_hamster'
  s.licenses    = ['MIT']
  s.description = <<-GEM_DESC
    RSchema extension to support Hamster's immutable Hash, Vector, List, Set.
    Immutable values, well-defined structures.
    Depends on tomdalling/rschema and hamstergem/hamster.
  GEM_DESC

  s.version = RSchemaHamster::VERSION
  s.authors = ['David Crosby']
  s.email = ['crosby' + '@' + 'atomicobject.com']

  s.files = Dir['lib/**/*'] + %w{LICENSE.txt Readme.md}
  s.add_runtime_dependency     'hamster', '~> 1.0'
  s.add_runtime_dependency     'rschema', '~> 1.1'
  s.add_development_dependency 'pry', '~> 0'
  s.add_development_dependency 'rake', '~> 10'
  s.add_development_dependency 'awesom_print', '~> 1'
  s.add_development_dependency 'rspec', '~> 3.2'
  s.require_paths = ['lib']
end
