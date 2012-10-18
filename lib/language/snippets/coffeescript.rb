require "heredoc_unindent"

class Language
  module Snippets
    module CoffeeScript
      SOURCE = <<-COFFEESCRIPT.unindent
        class Stringy
          constructor: (@value) ->
            throw 'A Stringy object requires a string value!' if typeof @value isnt 'string'
          
          isPalindrome: ->
            i = 0
            j = @value.length - 1
            
            while i < j
              return false if @value[i++] isnt @value[j--]
            
            true
      COFFEESCRIPT

      SPEC = <<-COFFEESCRIPT.unindent
        describe "Stringy", ->
          it "cannot be contructed with a non-string value", ->
            expect(-> new Stringy(null)).toThrow()
            expect(-> new Stringy(5)).toThrow()
            expect(-> new Stringy({})).toThrow()
          
          it "instantiates cleanly for a string value", ->
            expect(-> new Stringy("foo")).not.toThrow()
          
          describe "isPalindrome", ->
            test = (input, expectation) ->
              expect(new Stringy(input).isPalindrome()).toBe expectation
            
            it "returns true for palindromic strings", ->
              test "racecar", true
            
            it "returns false for ordinary (non-palindromic) strings", ->
              test "pineapple", false
      COFFEESCRIPT

      INSTRUCTIONS = <<-HTML
        <p>
          <a href="http://en.wikipedia.org/wiki/Coffeescript">CoffeeScript</a> is a little language
          that compiles into JavaScript. Underneath all of those embarrassing braces and semicolons,
          JavaScript has always had a gorgeous object model at its heart. CoffeeScript is an attempt
          to expose the good parts of JavaScript in a simple way.
        </p>
        <p>
          In CoffeeScript mode, use <a href="http://pivotal.github.com/jasmine/">Jasmine</a> to
          write specs. Clicking 'Run' will run your specs along with your code and show what passed
          and what failed.
        </p>
      HTML
    end
  end
end
