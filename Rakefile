begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  puts "(no rspec, no spec task)"
end

task default: :spec

require "bundler/gem_tasks"

task :console do
  $: << "lib"
  require "rschema_hamster"
  require 'pry'
  binding.pry
end
