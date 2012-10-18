require "mongoid/submission"

class PostSubmission
  include DataMapper::Resource

  belongs_to :post

  property :id,            Serial
  property :post_id,       Integer
  property :submission_id, String
  property :output,        Text

  after :create do
    self.submission.update_attributes(:keep => true)
  end

  before :destroy do
    self.submission.update_attributes(:keep => false)
  end

  def submission
    Submission.find(self.submission_id)
  end
end
