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

  # GET /code_snippets/new
  # GET /code_snippets/new.xml
  def new
    @code_snippet = CodeSnippet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @code_snippet }
    end
  end

  # GET /code_snippets/1/edit
  def edit
    @code_snippet = CodeSnippet.find(params[:id])
  end

  # POST /code_snippets
  # POST /code_snippets.xml
  def create
    @code_snippet = CodeSnippet.new(params[:code_snippet])

    respond_to do |format|
      if @code_snippet.save
        format.html { redirect_to(@code_snippet, :notice => 'Code snippet was successfully created.') }
        format.xml  { render :xml => @code_snippet, :status => :created, :location => @code_snippet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @code_snippet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /code_snippets/1
  # PUT /code_snippets/1.xml
  def update
    @code_snippet = CodeSnippet.find(params[:id])

    respond_to do |format|
      if @code_snippet.update_attributes(params[:code_snippet])
        format.html { redirect_to(@code_snippet, :notice => 'Code snippet was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @code_snippet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /code_snippets/1
  # DELETE /code_snippets/1.xml
  def destroy
    @code_snippet = CodeSnippet.find(params[:id])
    @code_snippet.destroy

    respond_to do |format|
      format.html { redirect_to(code_snippets_url) }
      format.xml  { head :ok }
    end
  end
end
