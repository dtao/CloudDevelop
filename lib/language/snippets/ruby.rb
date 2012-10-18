require "heredoc_unindent"

class Language
  module Snippets
    module Ruby
      SOURCE = <<-RUBY.unindent
        class String
          def is_palindrome?
            (0..(self.length / 2)).each do |i|
              return false if self[i] != self[-i - 1]
            end
            
            true
          end
        end
      RUBY

      SPEC = <<-RUBY.unindent
        describe String do
          describe "#is_palindrome?" do
            it "returns true for palindromic strings" do
              "racecar".is_palindrome?.should be_true
            end
            
            it "returns false for ordinary (non-palindromic) strings" do
              "pineapple".is_palindrome?.should be_false
            end
          end
        end
      RUBY

      INSTRUCTIONS = <<-HTML
        <p>
          <a href="http://en.wikipedia.org/wiki/Ruby_(programming_language)">Ruby</a> is an
          open-source dynamic object-oriented interpreted language created by Yukihiro Matsumoto
          (Matz) in 1993.
        </p>
        <p>
          In Ruby mode, use <a href="http://rspec.info/">RSpec</a> to write specs as in the example
          above. Clicking 'Run' will run your specs along with your code and show you the results.
        </p>
      HTML
    end
  end
end
