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

      INSTRUCTIONS = <<-HTML
        In JavaScript mode, use <a href="http://pivotal.github.com/jasmine/">Jasmine</a> to write
        tests.
      HTML
    end
  end
end