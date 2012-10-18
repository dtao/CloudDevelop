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
