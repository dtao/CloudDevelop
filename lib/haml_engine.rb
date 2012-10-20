class HAMLEngine
  def process(params, post=nil)
    submission = Submission.create({
      :language => params[:language],
      :source   => params[:source]
    })

    { :action => "frame", :url => "/haml_result/#{submission.id}" }
  end

  def uses_specs?
    false
  end
end
