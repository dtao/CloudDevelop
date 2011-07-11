class CodeSnippetsChangeSnippetToText < ActiveRecord::Migration
  def self.up
  	change_column :code_snippets, :snippet, :text
  end

  def self.down
  	change_column :code_snippets, :snippet, :string
  end
end
