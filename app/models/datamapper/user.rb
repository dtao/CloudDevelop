class User
  include DataMapper::Resource

  has n, :identities
  has n, :posts
  has n, :upvotes

  property :id,    Serial
  property :email, String, :unique_index => true
  property :name,  String

  def self.by_post_count(options)
    # TODO: Figure out a way to do this without calling raw SQL (if possible).
    repository(:default).adapter.select <<-SQL
      SELECT u.id, u.email, u.name, COUNT(p.id) AS post_count
      FROM posts p
      INNER JOIN users u ON p.user_id = u.id
      GROUP BY p.user_id
      ORDER BY post_count DESC
      LIMIT #{options[:limit] || 20};
    SQL
  end

  def self.by_score(options={})
    # TODO: Figure out a way to do this without calling raw SQL (if possible).
    repository(:default).adapter.select <<-SQL
      SELECT u.id, u.email, u.name, COUNT(p.id) AS post_count, COUNT(uv.id) AS score
      FROM users u
      LEFT JOIN posts p ON p.user_id = u.id
      LEFT JOIN upvotes uv ON uv.record_id = p.id
      WHERE uv.record_type IS NULL OR uv.record_type = "Post"
      GROUP BY p.user_id
      ORDER BY score DESC
      LIMIT #{options[:limit] || 20};
    SQL
  end

  def vote_up(record)
    raise "You cannot vote for yourself!" if record.user == self

    self.upvotes.create({
      :record_id   => record.id,
      :record_type => record.class.name
    })
  end

  def upvote_for(record)
    self.upvotes.first(:record_type => record.class.name, :record_id => record.id)
  end
end
