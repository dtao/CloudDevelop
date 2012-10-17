class Identity
  include DataMapper::Resource

  belongs_to :user

  property :id,       Serial
  property :user_id,  Integer, :index => true
  property :provider, String,  :index => true
  property :uid,      String,  :index => true
end
