class JasmineEngine
  def process(params)
    submission = Submission.create({
      :language => params[:language],
      :source   => params[:source],
      :spec     => params[:spec]
    })

    { :action => "frame", :url => "/result/#{submission.id}" }
  end
end
