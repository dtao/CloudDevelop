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
          code readability. Python is used for developing a wide range of applications. Python has
          two major versions in use. Please mention the version of Python that you are using.
        </p>
        <p>
          In Python mode, your code will be executed on the server. Use <code>print</code> to
          display output.
        </p>
      HTML
    end
  end
end
