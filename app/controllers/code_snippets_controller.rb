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

    respond_to do |format|
      if @code_snippet.save
        client = Savon::Client.new do
          wsdl.document = "http://ideone.com/api/1/service.wsdl"
        end
        
        submission_response = client.request "createSubmission" do
          soap.body = {
            :user => "dtao",
            :pass => "clouddevelop",
            :sourceCode => snippet,
            :language => language_code(language),
            :input => "",
            :run => true,
            :private => true
          }
        end

        link = link_from_submission_response(submission_response)

        finished = false
        until finished
          status_response = client.request "getSubmissionStatus" do
            soap.body = {
              :user => "dtao",
              :pass => "clouddevelop",
              :link => link
            }
          end

          if status_from_status_response(status_response) == 0
            finished = true
          else
            sleep 3
          end
        end

        details_response = client.request "getSubmissionDetails" do
          soap.body = {
            :user => "dtao",
            :pass => "clouddevelop",
            :link => link,
            :withSource => false,
            :withInput => false,
            :withOutput => true,
            :withStderr => true,
            :withCmpinfo => true
          }
        end

        is_error = false

        case result_from_details_response(details_response)
        when 11
          output = value_from_response(details_response.to_hash[:get_submission_details_response], "cmpinfo")
          is_error = true
        when 12
          output = value_from_response(details_response.to_hash[:get_submission_details_response], "stderr")
          is_error = true
        when 13
          output = "Time limit exceeded :("
        when 17
          output = "Memory limit exceeded :("
        when 19
          output = "Illegal system call :("
        when 20
          output = "Internal error :("
        else
          output = value_from_response(details_response.to_hash[:get_submission_details_response], "output")
        end

        format.js { render :json => { :output => output, :isError => is_error }, :status => :created }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @code_snippet.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  def language_code(language)
    case language
    when "c"
      11
    when "cpp"
      1
    when "cs"
      27
    when "java"
      10
    when "php"
      29
    when "python"
      4
    end
  end

  def value_from_response(response_map, key)
    value = ""

    items = response_map[:return][:item]
    items.each do |item|
      if item[:key] == key
        value = item[:value]
        break
      end
    end

    value
  end

  def link_from_submission_response(response)
    value_from_response(response.to_hash[:create_submission_response], "link")
  end

  def status_from_status_response(response)
    value_from_response(response.to_hash[:get_submission_status_response], "status").to_i
  end

  def result_from_details_response(response)
    value_from_response(response.to_hash[:get_submission_details_response], "result").to_i
  end
end
