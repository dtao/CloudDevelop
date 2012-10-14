require "mongoid"

class Submission
  include Mongoid::Document

  field :language,     :type => String
  field :content,      :type => String
end
