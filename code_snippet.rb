class CodeSnippet
	include Mongoid::Document

	field :snippet, :type => String
	field :language, :type => String
	field :version, :type => Integer
	field :updates, :type => Array
	field :latest, :type => String
end
