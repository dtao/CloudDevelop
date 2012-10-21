require "sinatra"
require "sinatra/content_for"
require "sinatra/flash"

APP_ROOT     = File.dirname(__FILE__)
PROJECT_ROOT = File.join(APP_ROOT, "..")

configure do
  enable :sessions

  set :public_folder, File.join(PROJECT_ROOT, "public")

  require File.join(PROJECT_ROOT, "config", "boot")
  require "omniauth"
  require "omniauth-github"

  helpers Sinatra::ContentFor

  use OmniAuth::Builder do
    provider :github, ENV["GITHUB_CLIENT_ID"], ENV["GITHUB_CLIENT_SECRET"], :scope => "gist"
  end

  Engine.register(:haml, HAMLEngine.new)
  Engine.register(:ideone, IdeoneEngine.new(ENV["IDEONE_USER"], ENV["IDEONE_PASS"]))
  Engine.register(:jasmine, JasmineEngine.new)
  Engine.register(:junit, JUnitEngine.new(File.join(PROJECT_ROOT, "bin", "junit-4.10.jar"), File.join(PROJECT_ROOT, "tmp", "java")))
  Engine.register(:rspec, RSpecEngine.new(File.join(PROJECT_ROOT, "tmp")))
  Engine.register(:markdown, MarkdownEngine.new)

  Pusher.app_id = ENV["PUSHER_APP_ID"]
  Pusher.key    = ENV["PUSHER_API_KEY"]
  Pusher.secret = ENV["PUSHER_SECRET"]
end

helpers do
  include FormatHelper
  include HtmlHelper
  include PostHelper

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.get(session[:user_id])
  end
end

get "/" do
  @language = Language["javascript"]
  @source   = @language.snippets[:source]
  @spec     = @language.snippets[:spec]
  haml :index
end

get "/posts" do
  if !logged_in?
    flash[:notice] = "You must be logged in for that."
    halt redirect("/")
  end

  @posts = current_user.posts(:order => [ :id.desc ])
  haml :posts
end

get "/posts/:user_id" do |user_id|
  @user  = User.get(user_id)
  if @user.nil?
    flash[:notice] = "That user does not exist."
    halt redirect("/")
  end

  @posts = @user.posts(:order => [ :id.desc ])
  haml :posts
end

get "/logout" do
  session.delete(:user_id)
  flash[:notice] = "Successfully logged out."
  redirect "/"
end

get "/editor/:submission_id" do |submission_id|
  submission = Submission.find(submission_id)
  language   = Language[submission.language]
  haml :editor, :locals => { :id => "spec-editor", :mode => language.mode, :content => submission.spec }, :layout => false
end

get "/haml_result/:submission_id" do |submission_id|
  submission = Submission.find(submission_id)
  haml submission.source, :layout => false
end

get "/jasmine_result/:submission_id" do |submission_id|
  @submission = Submission.find(submission_id)
  erb :jasmine_results
end

get "/markdown_result/:submission_id" do |submission_id|
  @submission = Submission.find(submission_id)
  haml :markdown, :layout => false
end

get "/rspec_result/:submission_id" do |submission_id|
  submission = Submission.find(submission_id)
  submission.output
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
  if @language.nil?
    flash[:notice] = "That isn't a supported language."
    halt redirect("/")
  end

  @source = @language.snippets[:source]
  @spec   = @language.snippets[:spec]
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

  else
    user = identity.user
  end

  flash[:notice] = "Successfully logged in as <span>#{user.name}</span>."

  session[:user_id] = user.id

  redirect request.env["omniauth.origin"] || "/"
end

# This needs to go last as it is essentialy the "fall-through" case.
get "/:token" do |token|
  @post     = Post.first(:token => token)
  @language = @post.language
  @source   = @post.source
  @spec     = @post.spec
  haml :index
end

delete "/:token" do |token|
  content_type :json

  post = Post.first(:token => token)

  unless post.nil?
    Post.transaction do
      post.submissions.destroy
      post.reload
      post.destroy
    end
  end

  { :success => true }.to_json
end

post "/:token" do |token|
  content_type :json

  post     = Post.first(:token => token)
  language = Language[params[:language]]
  language.engine.process(params, post).to_json
end

post "/save/:token" do |token|
  content_type :json

  post = Post.first(:token => token)

  if post && post.user && (post.user != current_user)
    if !logged_in?
      flash[:notice] = "You must log in to update a post."
      flash[:style]  = "error"
    else
      flash[:notice] = "You can only update your own posts."
      flash[:style]  = "error"
    end

  else
    Post.transaction do
      if post.nil?
        properties = {}
        properties[:label] = params[:label] unless params[:label].blank?
          
        if logged_in?
          post = current_user.posts.create(properties)
        else
          post = Post.create(properties)
        end
      end

      if post.label != params[:label] && !params[:label].blank?
        post.update(:label => params[:label])
      end

      submission = Submission.create({
        :language => params[:language],
        :source   => params[:source],
        :spec     => params[:spec]
      })

      post_submission = post.submissions.create(:submission_id => submission.id)
    end
  end

  flash[:notice] = "Saved post <span>#{post.label || post.token}</span>."

  # The browser will redirect after this.
  { :token => post.token }.to_json
end

error do
  flash[:notice] = "An unexpected error occurred."
  redirect "/"
end
