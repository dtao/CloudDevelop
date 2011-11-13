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
    collaboration.content = ''
    collaboration.contributors = [name]
    collaboration.owner = name

    if collaboration.save
        redirect "/#{collaboration.id}/#{name}"
    else
        @error = 'Unable to start a new session :('
        redirect '/'
    end
end

post '/*/enter' do |collaboration_id|
    name = params[:name]
    collaboration = Collaboration.find(collaboration_id)

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

get %r{^\/([a-z0-9]+)$} do |collaboration_id|
    @template = :enter
    @collaboration = Collaboration.find(collaboration_id)
    haml :index
end

get %r{\/([a-z0-9]+)\/(.*)} do |collaboration_id, contributor|
    @template = :edit
    @collaboration = Collaboration.find(collaboration_id)
    @contributor = contributor
    haml :index
end

post '/update' do
    collaboration_id = params[:collaboration_id]
    content = params[:content]

    collaboration = Collaboration.find(collaboration_id)
    collaboration.content = content

    Pusher[collaboration_id].trigger('update', {
        'contributor' => params[:contributor],
        'content' => content,
        'changeId' => params[:change_id].to_i
    })
end

post '/change_control' do
    collaboration_id = params[:collaboration_id]
    owner = params[:owner]

    collaboration = Collaboration.find(collaboration_id)
    collaboration.set :owner, owner

    Pusher[collaboration_id].trigger('change_control', {
        'contributors' => collaboration.contributors,
        'owner' => owner
    })
end

post '/compile' do
    content_type :json

    snippet = params[:code_snippet]
    language = params[:language]

    service = IdeoneCompilerService.new(ENV["IDEONE_USER"], ENV["IDEONE_PASS"])
    service.compile(snippet, language).to_json
end