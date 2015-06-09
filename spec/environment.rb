# Establish absolute path to project root dir:
PROJ_ROOT = File.expand_path(File.dirname(__FILE__) + "/..")

# Get lib into the loadpath:
$: << "#{PROJ_ROOT}/lib"

require 'rschema_hamster'
# require 'rschema_hamster/extend_rschema_dsl'

# For testing
require 'pry'
require 'bigdecimal'
