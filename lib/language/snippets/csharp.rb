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
        In C# mode, your code will be compiled and run on a server. Use 'Console.WriteLine' to
        display output.
      HTML
    end
  end
end
