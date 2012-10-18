require "heredoc_unindent"

class Language
  module Snippets
    module Ruby
      SOURCE = <<-RUBY.unindent
        class String
          def is_palindrome?
          end
        end
        
        ["pineapple", "racecar"].each do |word|
          puts "#\{word\}.is_palindrome? => #\{word.is_palindrome?\}"
        end
      RUBY

      INSTRUCTIONS = <<-HTML
        In Ruby mode, your code will be executed on the server. Use 'puts' to display output.
      HTML
    end
  end
end
