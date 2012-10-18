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
        <p>
          <a href="http://en.wikipedia.org/wiki/Ruby_(programming_language)">Ruby</a> is an
          open-source dynamic object-oriented interpreted language created by Yukihiro Matsumoto
          (Matz) in 1993.
        </p>
        <p>
          In Ruby mode, your code will be executed on the server. Use 'puts' to display output.
        </p>
      HTML
    end
  end
end
