class CompileController < ApplicationController
  # POST /compile.js
  def create
    snippet = params[:code_snippet]
    language = params[:language]

    service = IdeoneCompilerService.new(ENV["IDEONE_USER"], ENV["IDEONE_PASS"])
    result = service.compile(snippet, language)
      
    respond_to do |format|
      format.js { render :json => result, :status => :created }
    end
  end
end