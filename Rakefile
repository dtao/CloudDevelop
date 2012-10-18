PROJECT_ROOT = File.dirname(__FILE__)
APP_ROOT     = File.join(PROJECT_ROOT, "app")

require File.join(PROJECT_ROOT, "config", "boot")

namespace :db do
  desc "Initialize the database"
  task :init do
    DataMapper.auto_migrate!
  end

  desc "Update the database"
  task :update do
    DataMapper.auto_upgrade!
  end
end

namespace :heroku do
  desc "Configure the Heroku environment with the appropriate variables"
  task :config do
    args = []
    Dir.glob(File.join(PROJECT_ROOT, "config", "env", "*.yml")) do |config_file|
      prefix = File.basename(config_file, ".yml")
      YAML.load_file(config_file).tap do |config|
        target_env = config["production"]
        args << target_env.keys.map { |k| "#{prefix.upcase}_#{k.upcase}='#{target_env[k]}'" }.join(" ")
      end
    end

    sh "heroku config:add #{args.join(' ')}"
  end
end
