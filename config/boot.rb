require "coffee_script"
require "data_mapper"
require "haml"
require "mongoid"
require "pusher"
require "sass"

$LOAD_PATH << File.join(PROJECT_ROOT, "lib")
$LOAD_PATH << File.join(APP_ROOT, "models")

Dir.glob(File.join(PROJECT_ROOT, "lib", "**", "*.rb")) do |filename|
  require filename
end

Dir.glob(File.join(APP_ROOT, "models", "**", "*.rb")) do |filename|
  require filename
end

require File.join(PROJECT_ROOT, "config", "database")

DataMapper.finalize

Mongoid.load!(File.join(PROJECT_ROOT, "config", "mongoid.yml"))

if ENV["RACK_ENV"].nil? || ENV["RACK_ENV"] == "development"
  # TODO: Write code to read YAML config files and load them into ENV.
end
