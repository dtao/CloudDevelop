require "heredoc_unindent"

class Language
  module Snippets
    module VisualBasic
      SOURCE = <<-VB.unindent
        Imports System
        
        Module Program
          
          Sub Main(ByVal args() As String)
            Console.WriteLine("IsPalindrome(""pineapple"") => {0}", IsPalindrome("pineapple"))
            Console.WriteLine("IsPalindrome(""racecar"") => {0}", IsPalindrome("racecar"))
          End Sub
          
          Function IsPalindrome(ByVal text As String) As Boolean
            Dim i As Integer = 0
            Dim j As Integer = text.Length - 1
            
            While i < j
              If text(i) <> text(j) Then
                Return False
              End If
              i += 1
              j -= 1
            End While
            
            Return True
          End Function
          
        End Module
      VB

      INSTRUCTIONS = <<-HTML
        <p>
          <a href="http://en.wikipedia.org/wiki/VB.NET">Visual Basic .NET</a> (VB.NET) is an
          object-oriented computer programming language that can be viewed as an evolution of
          Microsoft's Visual Basic 6 (VB6) but implemented on the Microsoft .NET Framework.
        </p>
        <p>
          In VB.NET mode, your code will be compiled and run on a server. Use
          <code>Console.WriteLine</code> to display output.
        </p>
      HTML
    end
  end
end
