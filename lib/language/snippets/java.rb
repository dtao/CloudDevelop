require "heredoc_unindent"

class Language
  module Snippets
    module Java
      SOURCE = <<-JAVA.unindent
        public class StringUtils {
          public static boolean isPalindrome(String text) {
            if (text == null) {
              return false;
            }
            
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
        import static org.junit.Assert.*;
        
        public class StringUtilsTest {
          @Test
          public void returnsTrueForPalindromicStrings() {
            assertTrue(StringUtils.isPalindrome("racecar"));
          }
          
          @Test
          public void returnsFalseForOrdinaryStrings() {
            assertFalse(StringUtils.isPalindrome("pineapple"));
          }
          
          @Test
          public void returnsFalseForNull() {
            assertFalse(StringUtils.isPalindrome(null));
          }
        }
      JAVA

      INSTRUCTIONS = <<-HTML.unindent
        <p>
          <a href="http://en.wikipedia.org/wiki/Java_(programming_language)">Java</a> is an
          object-oriented language and runtime environment(JRE). Java programs are platform
          independent because the program execution is handled by a Virtual Machine called the Java
          VM or JVM.
        </p>
        <p>
          In Java mode, use <a href="http://junit.org/">JUnit</a> to write unit tests as in the
          example above. Clicking 'Compile' will run your unit tests and show you the results. Note
          that your source code must include exactly one public class as required by Java.
        </p>
      HTML
    end
  end
end
