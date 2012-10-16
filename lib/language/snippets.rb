require "heredoc_unindent"

class Language
  module Snippets
    module JavaScript
      SOURCE = <<-JAVASCRIPT.unindent
        function isPalindrome(str) {
          if (typeof str !== 'string') {
            return false;
          }
          
          var i = 0,
              j = str.length - 1;
          
          while (i < j) {
            if (str.charAt(i++) !== str.charAt(j--)) {
              return false;
            }
            return true;
          }
        };
      JAVASCRIPT

      SPEC = <<-JAVASCRIPT.unindent
        describe("isPalindrome", function() {
          it("returns true for palindromic strings", function() {
            expect(isPalindrome("racecar")).toBe(true);
          });
          
          it("returns false for ordinary (non-palindromic) strings", function() {
            expect(isPalindrome("foo")).toBe(false);
          });
          
          it("returns false for undefined", function() {
            expect(isPalindrome()).toBe(false);
          });
          
          it("returns false for null", function() {
            expect(isPalindrome(null)).toBe(false);
          });
          
          it("returns false for non-string objects", function() {
            expect(isPalindrome({})).toBe(false);
          });
        });
      JAVASCRIPT
    end

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
              test "foo", false
      COFFEESCRIPT
    end
  end
end
