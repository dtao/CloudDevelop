require "coffee_script"
require "data_mapper"
require "haml"
require "mongoid"
require "pusher"
require "sass"

environment = ENV["RACK_ENV"] || "development"

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

if environment == "development"
  Dir.glob(File.join(PROJECT_ROOT, "config", "env", "*.yml")) do |filename|
    prefix = File.basename(filename, ".yml")
    config = YAML.load_file(filename)
    config[environment].each do |variable, value|
      ENV["#{prefix}_#{variable}".upcase] = "#{value}"
    end
  end
end
