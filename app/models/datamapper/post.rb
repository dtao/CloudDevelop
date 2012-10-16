require "language"
require "randy"

class Post
  include DataMapper::Resource

  has n, :submissions, "PostSubmission"

  property :id,    Serial
  property :token, String, :unique_index => true

  before :create do
    # Very little chance of a collision.
    self.token = Randy.string(8)
  end

  def last_submission
    @last_submission ||= begin
      record = self.submissions.last
      record ? record.submission : nil
    end
  end

  def language
    Language[last_submission.language]
  end

  def source
    last_submission ? last_submission.source : nil
  end

  def spec
    last_submission ? last_submission.spec : nil
  end
end
