require "heredoc_unindent"

class JUnitEngine
  def initialize(junit_path, class_path)
    @junit_path = junit_path
    @class_path  = class_path
  end

  def process(params, post=nil)
    unique_package = Randy.string(10, "abcdefghijklmnopqrstuvwxyz")
    Dir.mkdir(File.join(@class_path, "org", "clouddevelop", unique_package))

    source = params[:source]
    spec   = params[:spec]

    source_classname = source.match(/^\s*public class ([a-z0-9_]+)/i)[1]
    source_filename  = "#{source_classname}.java"
    source_filepath  = File.join(@class_path, "org", "clouddevelop", unique_package, source_filename)

    spec_classname = spec.match(/^\s*public class ([a-z0-9_]+)/i)[1]
    spec_filename  = "#{spec_classname}.java"
    spec_filepath  = File.join(@class_path, "org", "clouddevelop", unique_package, spec_filename)

    File.open(source_filepath, "w") do |io|
      io.write "package org.clouddevelop.#{unique_package};\n\n#{source}"
    end

    File.open(spec_filepath, "w") do |io|
      io.write "package org.clouddevelop.#{unique_package};\n\n#{spec}"
    end

    output = STDOUTReader.from_command("javac -cp #{@junit_path} #{source_filepath} #{spec_filepath}")

    if output.blank?
      output = `java -cp #{@junit_path}:#{@class_path} org.junit.runner.JUnitCore org.clouddevelop.#{unique_package}.#{spec_classname}`.strip
    else
      output = output.match(/\.java:\d+: (.*)/m)[1]
    end

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
