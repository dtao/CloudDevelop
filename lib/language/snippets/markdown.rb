require "heredoc_unindent"

class Language
  module Snippets
    module Markdown
      SOURCE = <<-MARKDOWN.unindent
        Heading Level 1
        ===============
        
        Heading Level 2
        ---------------
        
        Make text *italic* using single asterisks.
        
        Make text **bold** with double asterisks.
        
        Make unordered lists with '-':
        
        - Foo
        - Bar
        
        Make ordered lists with '1', '2', etc.:
        
        1. Item 1
        2. Item 2
        
        Use tickmarks for inline code: `var i = 0;`
        
        Use '>' for blockquotes:
        
        > I'm sick of following my dreams. I'm just going to ask them
        > where they're going and hook up with them later.
        > - Mitch Hedberg
      MARKDOWN

      INSTRUCTIONS = <<-HTML
        <p>
          <a href="http://en.wikipedia.org/wiki/Markdown">Markdown</a> is a lightweight markup
          language, originally created by John Gruber and Aaron Swartz to help maximum readability
          and "publishability" of both its input and output forms. The language takes many cues from
          existing conventions for marking up plain text in email. Markdown converts its marked-up
          text input to valid, well-formed XHTML and replaces left-pointing angle brackets ('&lt;')
          and ampersands with their corresponding character entity references.
        </p>
        <p>
          In Markdown mode, your code will be compiled and re-rendered as HTML. Click 'Render' to
          view the HTML output.
        </p>
      HTML
    end
  end
end
