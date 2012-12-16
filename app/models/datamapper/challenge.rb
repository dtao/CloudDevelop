class Challenge
  include DataMapper::Resource

  belongs_to :user
  has n, :posts

  property :id,          Serial
  property :user_id,     Integer
  property :label,       String
  property :description, Text
  property :created_at,  DateTime
  property :updated_at,  DateTime

  def url
    "/challenges/#{self.id}"
  end
end
