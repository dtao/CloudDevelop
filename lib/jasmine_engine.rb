class JasmineEngine
  def process(params, post=nil)
    submission = Submission.create({
      :language => params[:language],
      :source   => params[:source],
      :spec     => params[:spec]
    })

    { :action => "frame", :url => "/result/#{submission.id}" }
  end

  def uses_specs?
    true
  end
end
