class User
  include DataMapper::Resource

  has n, :identities
  has n, :posts

  property :id,    Serial
  property :email, String, :unique_index => true
  property :name,  String
end
