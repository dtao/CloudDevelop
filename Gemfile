source "http://rubygems.org"

# Application framework
gem "sinatra", :github => "sinatra"
gem "sinatra-contrib", :github => "sinatra/sinatra-contrib"
gem "sinatra-flash"

# Server requirement
gem "thin"

# Libraries
gem "coffee-script"
gem "haml"
gem "heredoc_unindent"
gem "omniauth"
gem "omniauth-github"
gem "pusher"
gem "randy"
gem "redcarpet"
gem "rspec"
gem "sass"
gem "savon"
gem "tux"

# Database stuff
gem "datamapper"
gem "dm-noisy-failures"
gem "mongoid", "~> 2.1"
gem "bson_ext", "~> 1.3"

group :production do
  gem "dm-postgres-adapter"
  gem "pg"
end

group :development do
  gem "dm-sqlite-adapter"
  gem "shotgun"
end
