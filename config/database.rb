DataMapper.logger = Logger.new(STDOUT)
DataMapper::Property::String.length(255)

DB_ROOT = File.join(PROJECT_ROOT, "db")

case ENV["RACK_ENV"] || "development"
  when "production"  then DataMapper.setup(:default, ENV["DATABASE_URL"])
  when "development" then DataMapper.setup(:default, "sqlite3://" + File.join(PROJECT_ROOT, "db", "clouddevelop_development.db"))
  when "test"        then DataMapper.setup(:default, "sqlite3://" + File.join(PROJECT_ROOT, "db", "clouddevelop_test.db"))
end
