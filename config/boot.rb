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

Pusher.app_id = ENV["PUSHER_APP_ID"]
Pusher.key    = ENV["PUSHER_API_KEY"]
Pusher.secret = ENV["PUSHER_SECRET"]
