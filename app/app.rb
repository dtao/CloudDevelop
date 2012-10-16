require "sinatra"

APP_ROOT     = File.dirname(__FILE__)
PROJECT_ROOT = File.join(APP_ROOT, "..")

configure do
  require File.join(PROJECT_ROOT, "config", "boot")
  set :public, File.join(PROJECT_ROOT, "public")
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

post "/save/*" do |token|
  content_type :json

  post = Post.first(:token => token)

  Post.transaction do
    post ||= Post.create

    submission = Submission.create({
      :language => params[:language],
      :source   => params[:source],
      :spec     => params[:spec]
    })

    post_submission = post.submissions.create(:submission_id => submission.id)
  end

  { :token => post.token }.to_json
end
