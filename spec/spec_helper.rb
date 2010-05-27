current_path = File.dirname(__FILE__)

require 'yaml'

SignalAuth = YAML.load_file("#{current_path}/../signal-auth.yml")

require current_path  + "/../../../../config/environment"

require 'spec/autorun'
require 'spec/rails'

Spec::Runner.configure {}
