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

    snippet = params[:code_snippet]
    language = params[:language]

    @code_snippet.snippet = snippet

    respond_to do |format|
      if @code_snippet.save
        client = Savon::Client.new do
          wsdl.document = "http://ideone.com/api/1/service.wsdl"
        end
        
        response = client.request "createSubmission" do
          soap.body = {
            :user => "dtao",
            :pass => "clouddevelop",
            :sourceCode => snippet,
            :language => language,
            :input => "",
            :run => true,
            :private => true
          }
        end

        format.js { render :json => response, :status => :created }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @code_snippet.errors, :status => :unprocessable_entity }
      end
    end
  end
end
