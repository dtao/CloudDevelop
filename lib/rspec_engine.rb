require "heredoc_unindent"

class RSpecEngine
  def initialize(spec_path)
    @spec_path = spec_path
  end

  def process(params, post=nil)
    filename = "#{Randy.string(20)}.rb"
    filepath = File.join(@spec_path, filename)

    File.open(filepath, "w") do |io|
      io.write <<-RUBY.unindent
        require "rspec"
        
        #{params[:source]}
        
        #{params[:spec]}
      RUBY
    end

    output = `rspec #{filepath} --format html`.strip

    submission = Submission.create({
      :language => params[:language],
      :source   => params[:source],
      :spec     => params[:spec],
      :output   => output
    })

    { :action => "frame", :url => "/rspec_result/#{submission.id}" }
  end

  def uses_specs?
    true
  end
end
