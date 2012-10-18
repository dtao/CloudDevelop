require "heredoc_unindent"

class Language
  module Snippets
    module Python
      SOURCE = <<-PYTHON.unindent
        def isPalindrome(str):
          i = 0
          j = len(str) - 1
          while i < j:
            if str[i] != str[j]:
              return False
            i += 1
            j -= 1
          return True
        
        print isPalindrome("pineapple")
        print isPalindrome("racecar")
      PYTHON

      INSTRUCTIONS = <<-HTML
        <p>
          <a href="http://en.wikipedia.org/wiki/Python_(programming_language)">Python</a> is a
          dynamically and strongly typed programming language whose design philosophy emphasizes
          code readability. Python is used for developing a wide range of applications.
        </p>
        <p>
          Python mode uses Python 2. Your code will be executed on the server. Use
          <code>print</code> to display output.
        </p>
      HTML
    end
  end
end
