require "heredoc_unindent"

class RSpecEngine
  def initialize(spec_path)
    @spec_path = spec_path
  end

  def process(params, post=nil)
    submission = Submission.create({
      :language => params[:language],
      :source   => params[:source],
      :spec     => params[:spec]
    })

    filename = "#{Randy.string(20)}.rb"
    filepath = File.join(@spec_path, filename)

    File.open(filepath, "w") do |io|
      io.write <<-RUBY.unindent
        require "rspec"
        
        #{submission.source}
        
        #{submission.spec}
      RUBY
    end

    output = `rspec #{filepath} --format nested`.strip

    { :action => "render", :output => output }
  end

  def uses_specs?
    true
  end
end
