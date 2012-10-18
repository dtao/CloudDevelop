require "heredoc_unindent"

class Language
  module Snippets
    module CPlusPlus
      SOURCE = <<-CPP.unindent
        #include <iostream>
        
        using namespace std;
        
        int main() {
          cout << "Hello, world!" << endl;
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
