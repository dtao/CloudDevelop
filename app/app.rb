require "sinatra"

Dir.glob(File.join(File.dirname(__FILE__), "..", "lib", "*.rb")) do |filename|
  puts "Requiring #{filename}"
  require filename
end

configure do
  require "mongoid"
  require "pusher"
  require "haml"
  require "sass"
  require "coffee_script"

  Mongoid.load!("config/mongoid.yml")
  Pusher.app_id = ENV["PUSHER_APP_ID"]
  Pusher.key    = ENV["PUSHER_API_KEY"]
  Pusher.secret = ENV["PUSHER_SECRET"]
end

helpers do
  def stylesheet(filename)
    %Q[<link rel="stylesheet" href="/#{filename}.css" />]
  end

  def javascript(filename)
    %Q[<script type="text/javascript" src="/#{filename}.js"></script>]
  end
end

get "/" do
  @language = Language["javascript"]
  haml :index
end

get "/*.css" do |filename|
  sass :"sass/#{filename}"
end

get "/*.js" do |filename|
  coffee :"coffeescript/#{filename}"
end

get "/:language_key" do |language_key|
  @language = Language[language_key]
  haml :index
end

post "/compile" do
  content_type :json

  snippet = params[:code_snippet]
  language = params[:language]

  service = IdeoneCompilerService.new(ENV["IDEONE_USER"], ENV["IDEONE_PASS"])
  service.compile(snippet, language).to_json
end
