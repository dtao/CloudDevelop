require 'rubygems'
require 'sinatra'

require 'mongoid'
require 'savon'
require 'diff/lcs'
require './code_snippet'
require './ideone_compiler_service'

configure do
    Mongoid.load!('config/mongoid.yml')
end

get '/' do
	haml :index
end

get '/:snippet_id' do |snippet_id|
    @code_snippet = CodeSnippet.find(snippet_id)
    haml :index
end

# I don't know what the 'Sinatra' way of doing this is...
get '/snippet/:snippet_id' do |snippet_id|
    content_type :json

    CodeSnippet.find(snippet_id).to_json
end

post '/' do
    content_type :json

    snippet = params[:code_snippet]
    language = params[:language]

    @code_snippet = CodeSnippet.new
    @code_snippet.snippet = snippet
    @code_snippet.language = language
    @code_snippet.version = 1
    @code_snippet.updates = []
    @code_snippet.latest = snippet

    result = { :codeSnippet => @code_snippet }

    if @code_snippet.save
      result[:id] = @code_snippet.id
      result[:info] = "Snippet Id for future reference: #{@code_snippet.id}."
    else
      result[:info] = "Unable to save code snippet :("
    end

    result.to_json
end

put '/' do
    content_type :json

    @code_snippet = CodeSnippet.find(params[:id])

    original_snippet = @code_snippet.latest
    new_snippet = params[:code_snippet]
    diff = Diff::LCS.diff(original_snippet, new_snippet)

    @code_snippet.updates << structure_diff(diff)
    @code_snippet.version += 1
    @code_snippet.latest = new_snippet

    result = { :id => @code_snippet.id, :codeSnippet => @code_snippet }

    if @code_snippet.save
      result[:info] = "Snippet Id: #{@code_snippet.id}, version ##{@code_snippet.version}"
    else
      result[:info] = "Unable to update code snippet :("
    end

    result.to_json
end

post '/compile' do
    content_type :json

    snippet = params[:code_snippet]
    language = params[:language]

    service = IdeoneCompilerService.new(ENV["IDEONE_USER"], ENV["IDEONE_PASS"])
    service.compile(snippet, language).to_json
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