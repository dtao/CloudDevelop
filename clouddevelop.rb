require "mongoid"
require "pusher"
require "sinatra"

require File.dirname(__FILE__) + "/src/collaboration"
require File.dirname(__FILE__) + "/src/ideone_compiler_service"
require File.dirname(__FILE__) + "/src/language"
require File.dirname(__FILE__) + "/src/gist"

configure do
  Mongoid.load!("config/mongoid.yml")
  Pusher.app_id = ENV["PUSHER_APP_ID"]
  Pusher.key = ENV["PUSHER_API_KEY"]
  Pusher.secret = ENV["PUSHER_SECRET"]
end

helpers do
  def languages
    Language.all
  end
end

get "/" do
  @template = :start
  haml :index
end

post "/start" do
  name = params[:name]

  collaboration = Collaboration.new
  collaboration.content = ""
  collaboration.language = "c"
  collaboration.contributors = [name]

  if collaboration.save
    redirect "/#{collaboration.id}/#{name}"
  else
    @error = "Unable to start a new session :("
    redirect "/"
  end
end

post "/*/enter" do |collaboration_id|
  name = params[:name]
  collaboration = Collaboration.find(collaboration_id)

  original_name = name
  i = 1
  while collaboration.contributors.include?(name)
    name = "#{original_name}#{i}"
    i += 1
  end

  collaboration.push :contributors, name
  Pusher[collaboration_id].trigger("new_contributor", {
    "contributor" => name
  })

  redirect "/#{collaboration_id}/#{name}"
end

get %r{^\/([a-z0-9]+)$} do |collaboration_id|
  @template = :enter
  @collaboration = Collaboration.find(collaboration_id)
  haml :index
end

get %r{\/([a-z0-9]+)\/(.*)} do |collaboration_id, contributor|
  @collaboration = Collaboration.find(collaboration_id)
  @contributor = contributor
  haml :edit
end

post "/select" do
  collaboration_id = params[:collaboration_id]
  contributor = params[:contributor]
  range = params[:range]

  Pusher[collaboration_id].trigger("select", {
    :contributor => contributor,
    :range => range
  })
end

post "/change_language" do
  collaboration_id = params[:collaboration_id]
  contributor = params[:contributor]
  language = params[:language]

  collaboration = Collaboration.find(collaboration_id)
  collaboration.set :language, language

  Pusher[collaboration_id].trigger("change_language", {
    :contributor => contributor,
    :language => language
  })
end

post "/compile" do
  content_type :json

  snippet = params[:code_snippet]
  language = params[:language]

  service = IdeoneCompilerService.new(ENV["IDEONE_USER"], ENV["IDEONE_PASS"])
  service.compile(snippet, language).to_json
end

post "/gist" do
  # raise "Creating a gist requires an HTTPS request." unless request.secure?
  Gist.new(params[:user], params[:password]).create params[:name], params[:description], params[:content]
end