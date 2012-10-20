require "heredoc_unindent"

class Language
  module Snippets
    module Java
      SOURCE = <<-JAVA.unindent
        // Note: you can only have one public class per submission.
        
        public class StringUtils {
          public static boolean isPalindrome(String text) {
            int i = 0;
            int j = text.length() - 1;
            while (i < j) {
              if (text.charAt(i++) != text.charAt(j--)) {
                return false;
              }
            }
            return true;
          }
        }
      JAVA

      SPEC = <<-JAVA.unindent
        import org.junit.*;
        import org.junit.Assert.*;
        
        public class StringUtilsTest {
          @Test
          public void isPalindromeReturnsTrueForPalindromicStrings() {
            assertTrue(StringUtils.isPalindrome("racecar"));
          }
        }
      JAVA

      INSTRUCTIONS = <<-HTML
        <p>
          <a href="http://en.wikipedia.org/wiki/Java_(programming_language)">Java</a> is an
          object-oriented language and runtime environment(JRE). Java programs are platform
          independent because the program execution is handled by a Virtual Machine called the Java
          VM or JVM.
        </p>
        <p>
          In Java mode, your code will be compiled and run on a server. Use
          <code>System.out.println</code> to display output.
        </p>
      HTML
    end
  end
end
