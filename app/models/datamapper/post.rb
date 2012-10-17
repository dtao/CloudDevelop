require "language"
require "randy"

class Post
  include DataMapper::Resource

  belongs_to :user
  has n, :submissions, "PostSubmission"

  property :id,         Serial
  property :user_id,    Integer
  property :token,      String, :unique_index => true
  property :label,      String
  property :created_at, DateTime

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

  def snippet
    if self.source.length < 250
      self.source
    else
      self.source[0..247] + "..."
    end
  end
end
