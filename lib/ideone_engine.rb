require "savon"

class IdeoneEngine
  LANGUAGE_CODES = {
    "c"          => 11,
    "clojure"    => 111,
    "cpp"        => 1,
    "cs"         => 27,
    "haskell"    => 21,
    "groovy"     => 121,
    "java"       => 10,
    "javascript" => 35,
    "lua"        => 26,
    "perl"       => 54,
    "php"        => 29,
    "python"     => 4,
    "ruby"       => 17,
    "scheme"     => 33,
    "smalltalk"  => 23,
    "vb"         => 101
  }.freeze

  def initialize(user, pass)
    @user = user
    @pass = pass
  end
  
  def process(params, post=nil)
    result = compile(params[:source], params[:language])
    last_submission = post.submissions.last unless post.nil?
    last_submission.update(:output => result[:output]) unless last_submission.nil?
    { :action => "render", :output => result[:output] }
  end

  def uses_specs?
    false
  end

  private
  def compile(code, language)
    info = ""
    output = ""
    is_error = false
    
    begin
      client = Savon::Client.new do
        wsdl.document = "http://ideone.com/api/1/service.wsdl"
      end
      
      user = @user
      pass = @pass
      
      submission_response = client.request "createSubmission" do
        soap.body = {
          :user => user,
          :pass => pass,
          :sourceCode => code,
          :language => LANGUAGE_CODES[language],
          :input => "",
          :run => true,
          :private => true
        }
      end
      
      submission_response_hash = submission_response.to_hash[:create_submission_response]
      link = value_from_response(submission_response_hash, "link")
  
      finished = false
      until finished
        status_response = client.request "getSubmissionStatus" do
          soap.body = {
            :user => user,
            :pass => pass,
            :link => link
          }
        end
  
        status_response_hash = status_response.to_hash[:get_submission_status_response]
        if value_from_response(status_response_hash, "status").to_i == 0
          finished = true
        else
          sleep 3
        end
      end
  
      details_response = client.request "getSubmissionDetails" do
        soap.body = {
          :user => user,
          :pass => pass,
          :link => link,
          :withSource => false,
          :withInput => false,
          :withOutput => true,
          :withStderr => true,
          :withCmpinfo => true
        }
      end
  
      details_response_hash = details_response.to_hash[:get_submission_details_response]
      output = value_from_response(details_response_hash, "output")

      unless output.is_a? String
        output = ""
      end
  
      error_output = value_from_response(details_response_hash, "stderr")
      if error_output.is_a? String
        unless output.empty?
          output = error_output + "\n\n" + output
        else
          output = error_output
        end
      end

      result = value_from_response(details_response_hash, "result").to_i
      case result
      when 11
        info = "An error occurred during compilation."
        output = value_from_response(details_response_hash, "cmpinfo")
        unless output.is_a? String
          output = ""
        end
        is_error = true
      when 12
        info = "A runtime error occurred during execution."
        is_error = true
      when 13
        info = "Time limit exceeded :("
      when 17
        info = "Memory limit exceeded :("
      when 19
        info = "Illegal system call :("
      when 20
        info = "Internal error :("
      else
        info = nil
      end
    rescue Exception => e
      info = "The CloudDevelop server experienced an error: #{e.message}."
      output = e.backtrace.inspect
      is_error = true
    end

    return {
      :info => info,
      :output => output,
      :isError => is_error
    }
  end
  
  def value_from_response(hash, key)
    value = ""

    items = hash[:return][:item]
    items.each do |item|
      if item[:key] == key
        value = item[:value]
        break
      end
    end

    value
  end
end
