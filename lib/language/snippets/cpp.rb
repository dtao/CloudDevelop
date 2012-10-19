require "heredoc_unindent"

class Language
  module Snippets
    module CPP
      SOURCE = <<-CPP.unindent
        #include <iostream>
        #include <string>
        
        bool is_palindrome(std::string* str);
        
        int main() {
          std::string pineapple("pineapple");
          std::string racecar("racecar");
          std::cout << is_palindrome(&pineapple) << "\\n";
          std::cout << is_palindrome(&racecar) << std::endl;
        }
        
        bool is_palindrome(std::string* str) {
          size_t i = 0;
          size_t j = str->length() - 1;
          while (i < j) {
            if (str->at(i++) != str->at(j--)) {
              return false;
            }
          }
          
          return true;
        }
      CPP

      INSTRUCTIONS = <<-HTML
        <p>
          <a href="http://en.wikipedia.org/wiki/C++">C++</a> is a widely-used, statically-typed,
          free-form, compiled, multi-paradigm, multi-level, imperative, general-purpose,
          object-oriented programming language.
        </p>
        <p>
          In C++ mode, your code will be compiled and run on a server. Your program should include a
          <code>main</code> method. Use <code>std::cout</code> to display output.
        </p>
      HTML
    end
  end
end
