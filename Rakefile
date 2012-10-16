PROJECT_ROOT = File.dirname(__FILE__)
APP_ROOT     = File.join(PROJECT_ROOT, "app")

require File.join(PROJECT_ROOT, "config", "boot")

namespace :db do
  desc "Update the database"
  task :update do
    DataMapper.auto_upgrade!
  end
end
