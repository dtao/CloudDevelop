require "mongoid"

class Submission
  include Mongoid::Document

  field :language, :type => String
  field :source,   :type => String
  field :spec,     :type => String
  field :keep,     :type => Boolean
end
