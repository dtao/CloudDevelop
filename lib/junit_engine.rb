require "heredoc_unindent"

class JUnitEngine
  def initialize(junit_path, class_path)
    @junit_path = junit_path
    @class_path  = class_path
  end

  def process(params, post=nil)
    source_classname = params[:source].match(/^\s*public class ([^\s]+)/)[1]
    source_filename  = "#{source_classname}.java"
    source_filepath  = File.join(@class_path, "org", "clouddevelop", source_filename)

    spec_classname = params[:spec].match(/^\s*public class ([^\s]+)/)[1]
    spec_filename  = "#{spec_classname}.java"
    spec_filepath  = File.join(@class_path, "org", "clouddevelop", spec_filename)

    File.open(source_filepath, "w") do |io|
      io.write <<-JAVA.unindent
        package org.clouddevelop;
        
        #{params[:source]}
      JAVA
    end

    File.open(spec_filepath, "w") do |io|
      io.write <<-JAVA.unindent
        package org.clouddevelop;
        
        #{params[:spec]}
      JAVA
    end

    `javac -cp #{@junit_path} #{source_filepath} #{spec_filepath}`

    output = `java -cp #{@junit_path}:#{@class_path} org.junit.runner.JUnitCore org.clouddevelop.#{spec_classname}`.strip

    submission = Submission.create({
      :language => params[:language],
      :source   => params[:source],
      :spec     => params[:spec],
      :output   => output
    })

    { :action => "render", :output => output }
  end

  def uses_specs?
    true
  end
end
