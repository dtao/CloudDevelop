class Collaboration
  include Mongoid::Document

  field :source, :type => String
  field :contributors, :type => Array

  auto_increment :collaboration_id
end