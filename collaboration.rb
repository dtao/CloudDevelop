class Collaboration
  include Mongoid::Document

  field :content, :type => String
  field :contributors, :type => Array
  field :owner, :type => String
end