class Upvote
  include DataMapper::Resource

  belongs_to :user

  property :id,          Serial
  property :user_id,     Integer, :unique_index => :user_vote
  property :record_id,   Integer, :unique_index => :user_vote
  property :record_type, String,  :unique_index => :user_vote
  property :created_at,  DateTime
end
