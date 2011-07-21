class CodeSnippetsController < ApplicationController
  # GET /code_snippets
  # GET /code_snippets.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
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
    
    respond_to do |format|
      format.js { render :json => result, :status => :created }
    end
  end

  # PUT /code_snippets.js
  def update
    @code_snippet = CodeSnippet.find(params[:id])

    original_snippet = @code_snippet.snippet
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

    respond_to do |format|
      format.js { render :json => result }
    end
  end

  private
  def structure_diff(diff)
    segments = []

    diff.each do |segment|
      changes = []
      segment.each do |change|
        changes << structure_change(change)
      end

      segments << changes
    end

    segments
  end

  def structure_change(change)
    {
      :action => change.action,
      :element => change.element,
      :position => change.position
    }
  end
end
