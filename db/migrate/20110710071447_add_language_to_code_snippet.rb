class AddLanguageToCodeSnippet < ActiveRecord::Migration
  def self.up
    add_column :code_snippets, :language, :string
  end

  def self.down
    remove_column :code_snippets, :language
  end
end
