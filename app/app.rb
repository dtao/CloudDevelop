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

get "/:post_id" do |post_id|
  post      = Post.get(post_id)
  @language = post.language
  @source   = post.source
  @spec     = post.spec
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

get "/:language_key" do |language_key|
  @language = Language[language_key]
  haml :index
end

post "/" do
  
end

post "/:language_key" do |language_key|
  content_type :json

  source = params[:source]
  spec   = params[:spec]

  submission = Submission.create({
    :language => language_key,
    :source   => source,
    :spec     => spec
  })

  { :id => submission.id }.to_json
end
