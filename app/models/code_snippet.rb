class CodeSnippet
	include Mongoid::Document

	field :snippet, :type => String
	field :language, :type => String
end
