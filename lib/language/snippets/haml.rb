require "heredoc_unindent"

class Language
  module Snippets
    module HAML
      SOURCE = <<-HAML.unindent
        %head
          :css
            body {
              color: #008;
              background-color: #eef;
              font-family: Helvetica, sans-serif;
              margin: 0;
              padding: 0;
            }
            
            .header {
              color: #800;
              background-color: #fee;
              margin: 0;
              padding: 10px;
            }
            
            .content {
              color: #000;
              background-color: #fff;
              margin: 0;
              padding: 10px;
            }
            
            h1, h2, h3, h4, h5, h6, p {
              margin: 0;
            }
            
            p {
              margin-bottom: 10px;
            }
        
        %body
          .header
            %h1 Lorem Ipsum
          
          .content
            %p
              Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor
              incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
              exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure
              dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
              Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt
              mollit anim id est laborum.
            
            %p Check it out, a list!
            
            %ul
              %li Yabba
              %li Dabba
              %li Doo
      HAML

      INSTRUCTIONS = <<-HTML.unindent
        <p>
          <a href="http://en.wikipedia.org/wiki/HAML">HAML</a> is a markup language that's used to
          cleanly and simply describe the HTML of any web document without the use of inline code.
          It can be used as a standalone HTML generation tool or as a template rendering engine in a
          web framework such as Ruby on Rails or Ramaze.
        </p>
        <p>
          In HAML mode, your code will be compiled and re-rendered as HTML. Click 'Render' to view
          the HTML output.
        </p>
      HTML
    end
  end
end
