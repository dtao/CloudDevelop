class CodeSnippetsController < ApplicationController
  # GET /code_snippets
  # GET /code_snippets.xml
  def index
    @code_snippets = CodeSnippet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @code_snippets }
    end
  end

  # GET /code_snippets/1
  # GET /code_snippets/1.xml
  def show
    @code_snippet = CodeSnippet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @code_snippet }
    end
  end

  # POST /code_snippets.js
  def create
    @code_snippet = CodeSnippet.new

    @code_snippet.snippet = params[:code_snippet]

    respond_to do |format|
      if @code_snippet.save
        format.js { render :json => @code_snippet, :status => :created }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @code_snippet.errors, :status => :unprocessable_entity }
      end
    end
  end
end
