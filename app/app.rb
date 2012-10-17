require "sinatra"

APP_ROOT     = File.dirname(__FILE__)
PROJECT_ROOT = File.join(APP_ROOT, "..")

configure do
  enable :sessions
  set :public, File.join(PROJECT_ROOT, "public")

  require File.join(PROJECT_ROOT, "config", "boot")
  require "omniauth"
  require "omniauth-github"
  require "sinatra/flash"

  use OmniAuth::Builder do
    provider :github, ENV["GITHUB_KEY"], ENV["GITHUB_SECRET"]
  end

  Pusher.app_id = ENV["PUSHER_APP_ID"]
  Pusher.key    = ENV["PUSHER_API_KEY"]
  Pusher.secret = ENV["PUSHER_SECRET"]
end

helpers do
  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.get(session[:user_id])
  end

  def stylesheet(filename)
    %Q[<link rel="stylesheet" href="/#{filename}.css" />]
  end

  def javascript(filename)
    %Q[<script type="text/javascript" src="/#{filename}.js"></script>]
  end

  def empty_link(text, properties={})
    %Q[<a #{attributes_from_hash(properties.merge(:href => "javascript:void(0);"))}>#{text}</a>]
  end

  def attributes_from_hash(properties)
    properties.map { |key, value| %Q[#{key}="#{value}"] }.join(" ")
  end
end

get "/" do
  @language = Language["javascript"]
  haml :index
end

get "/editor/:submission_id" do |submission_id|
  submission = Submission.find(submission_id)
  language   = Language[submission.language]
  haml :editor, :locals => { :id => "spec-editor", :mode => language.mode, :content => submission.spec }
end

get "/result/:submission_id" do |submission_id|
  @submission = Submission.find(submission_id)
  erb :jasmine_results
end

get "/source/*.js" do |submission_id|
  @submission = Submission.find(submission_id)
  case @submission.language
  when "coffeescript"
    coffee [@submission.source, @submission.spec].join("\n")
  when "javascript"
    @submission.source
  end
end

get "/spec/*.js" do |submission_id|
  @submission = Submission.find(submission_id)
  case @submission.language
  when "coffeescript"
    ""
  when "javascript"
    @submission.spec
  end
end

get "/sass/*.css" do |filename|
  sass :"sass/#{filename}"
end

get "/coffeescript/*.js" do |filename|
  coffee :"coffeescript/#{filename}"
end

get "/mode/:language_key" do |language_key|
  @language = Language[language_key]
  haml :index
end

get "/auth/:provider/callback" do |provider|
  auth_info = request.env["omniauth.auth"]

  identity_info = { :provider => provider, :uid => auth_info["uid"] }
  identity      = Identity.first(identity_info)

  if identity.nil?
    user_info = auth_info["info"]
    user      = User.first(:email => user_info["email"])

    if user.nil?
      user_info = { :name => user_info["name"], :email => user_info["email"] }
      user      = User.create(user_info)
    end

    identity = user.identities.create(identity_info)
  end

  flash[:notice] = "Successfully logged in as <span>#{user.name}</span>."

  session[:user_id] = identity.user.id

  redirect request.env["omniauth.origin"] || "/"
end

# This needs to go last as it is essentialy the "fall-through" case.
get "/:token" do |token|
  post      = Post.first(:token => token)
  @language = post.language
  @source   = post.source
  @spec     = post.spec
  haml :index
end

post "/" do
  content_type :json

  submission = Submission.create({
    :language => params[:language],
    :source   => params[:source],
    :spec     => params[:spec]
  })

  { :id => submission.id }.to_json
end

post "/save" do
  content_type :json

  post = nil
  Post.transaction do
    post = Post.create

    submission = Submission.create({
      :language => params[:language],
      :source   => params[:source],
      :spec     => params[:spec]
    })

    post_submission = post.submissions.create(:submission_id => submission.id)
  end

  { :token => post.token }.to_json
end
