require "language"
require "randy"

class Post
  include DataMapper::Resource

  belongs_to :user
  belongs_to :challenge
  has n, :submissions, "PostSubmission"

  property :id,           Serial
  property :user_id,      Integer
  property :challenge_id, Integer
  property :token,        String, :unique_index => true
  property :label,        String
  property :created_at,   DateTime

  before :create do
    # Very little chance of a collision.
    self.token = Randy.string(8)
  end

  def identifier
    return self.label unless self.label.blank?
    self.token
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
    last_submission && last_submission.source
  end

  def spec
    last_submission && last_submission.spec
  end

  def output
    last_submission && last_submission.output
  end

  def upvotes
    Upvote.all(:record_type => "Post", :record_id => self.id)
  end
end
