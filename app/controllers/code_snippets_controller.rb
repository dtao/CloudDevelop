class CodeSnippetsController < ApplicationController
  # GET /code_snippets
  # GET /code_snippets.xml
  def index
    @code_snippet = CodeSnippet.last

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @code_snippet }
    end
  end

  # GET /code_snippets/1
  # GET /code_snippets/1.xml
  def show
    @code_snippet = CodeSnippet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js   { render :json => @code_snippet }
      format.xml  { render :xml => @code_snippet }
    end
  end

  # POST /code_snippets.js
  def create
    @code_snippet = CodeSnippet.new

    snippet = params[:code_snippet]
    language = params[:language]

    @code_snippet.snippet = snippet
    @code_snippet.language = language

    service = IdeoneCompilerService.new(ENV["IDEONE_USER"], ENV["IDEONE_PASS"])
    result = service.compile(snippet, language)
      
    if @code_snippet.save
      if result[:info].nil?
        result[:info] = "Snippet Id for future reference: #{@code_snippet.id}."
      end
    else
      result[:info] = "Unable to save code snippet :("
      result[:isError] = true
    end
    
    respond_to do |format|
      format.js { render :json => result, :status => :created }
    end
  end
end
