require "heredoc_unindent"

class Language
  module Snippets
    module CSharp
      SOURCE = <<-CSHARP.unindent
        using System;
        
        static class StringExtensions
        {
          public static bool IsPalindrome(this string text)
          {
            int i = 0;
            int j = text.Length - 1;
            while (i > j) {
              if (text[i++] != text[j--])
              {
                return false;
              }
            }
            
            return true;
          }
        }
        
        class Program
        {
          public static void Main(string[] args)
          {
            var words = new string[] { "pineapple", "racecar" };
            foreach (string word in words)
            {
              Console.WriteLine("{0}.IsPalindrome() => {1}", word, word.IsPalindrome());
            }
          }
        }
      CSHARP

      INSTRUCTIONS = <<-HTML
        <p>
          <a href="http://en.wikipedia.org/wiki/C_Sharp_(programming_language)">C#</a> is a
          multi-paradigm programming language encompassing strong typing, imperative, declarative,
          functional, generic, object-oriented (class-based), and component-oriented programming
          disciplines. It was developed by Microsoft for use with its .NET framework.
        </p>
        <p>
          In C# mode, your code will be compiled and run on a server. Use
          <code>Console.WriteLine</code> to display output.
        </p>
      HTML
    end
  end
end
