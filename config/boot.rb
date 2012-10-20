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

Dir.glob(File.join(APP_ROOT, "helpers", "**", "*.rb")) do |filename|
  require filename
end

Dir.glob(File.join(APP_ROOT, "models", "**", "*.rb")) do |filename|
  require filename
end

parent_dir = PROJECT_ROOT
"tmp/java/org/clouddevelop".split("/").each do |dir|
  parent_dir = File.join(parent_dir, dir)
  Dir.mkdir(parent_dir) unless Dir.exists?(parent_dir)
end

# Yes, this needs to come after the models have already been included.
require "dm-noisy-failures"

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
