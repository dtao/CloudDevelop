require 'mongoid'

class Collaboration
  include Mongoid::Document

  field :language, :type => String
  field :content, :type => String
  field :contributors, :type => Array
  field :owner, :type => String
end