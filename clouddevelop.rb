require 'rubygems'
require 'sinatra'

require 'mongoid'
require 'mongoid_auto_inc'
require 'savon'
require 'diff/lcs'
require 'pusher'
require './code_snippet'
require './collaboration'
require './ideone_compiler_service'

configure do
    ENV['RACK_ENV'] = 'development'

    Mongoid.load!('config/mongoid.yml')
    Pusher.app_id = ENV['PUSHER_APP_ID']
    Pusher.key = ENV['PUSHER_API_KEY']
    Pusher.secret = ENV['PUSHER_SECRET']
end

get '/' do
    @template = :start
    haml :index
end

post '/start' do
    name = params[:name]

    collaboration = Collaboration.new
    collaboration.source = ''
    collaboration.contributors = [name]

    if collaboration.save
        redirect "/#{collaboration.collaboration_id}/#{name}"
    else
        @error = 'Unable to start a new session :('
        redirect '/'
    end
end

post '/*/enter' do |collaboration_id|
    name = params[:name]
    collaboration = Collaboration.first :conditions => { :collaboration_id => collaboration_id }

    original_name = name
    i = 1
    while collaboration.contributors.include?(name)
        name = "#{original_name}#{i}"
        i += 1
    end

    collaboration.push :contributors, name
    Pusher[collaboration_id].trigger('new_contributor', {
        'contributor' => name
    })

    redirect "/#{collaboration_id}/#{name}"
end

get %r{^\/(\d+)$} do |collaboration_id|
    @template = :enter
    @collaboration = Collaboration.first :conditions => { :collaboration_id => collaboration_id }
    haml :index
end

get %r{\/(\d+)\/(.*)} do |collaboration_id, contributor|
    @template = :edit
    @collaboration = Collaboration.first :conditions => { :collaboration_id => collaboration_id }
    @contributor = contributor
    haml :index
end

get '/snippet/*.js' do |snippet_id|
    content_type :json
    CodeSnippet.find(snippet_id).to_json
end

get '/snippet/:snippet_id' do |snippet_id|
    begin
        @code_snippet = CodeSnippet.find(snippet_id)
    rescue
        @alert = "There isn't any code snippet with ID '#{snippet_id}'!"
    end

    haml :index
end

post '/compile' do
    content_type :json

    snippet = params[:code_snippet]
    language = params[:language]

    service = IdeoneCompilerService.new(ENV["IDEONE_USER"], ENV["IDEONE_PASS"])
    service.compile(snippet, language).to_json
end

post '/collaborate' do
    collaboration_id = params[:collaboration_id]
    Pusher[collaboration_id].trigger('update', {
        'contributor' => params[:contributor],
        'change' => params[:change]
    })
end

def structure_diff(diff)
    changes = []

    diff.each do |segment|
        segment.each do |change|
            changes << format_change(change)
        end
    end

    changes
end

def format_change(change)
    "#{change.position}#{change.action}#{change.element}"
end