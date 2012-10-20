module PostHelper
  def post_belongs_to_someone_else?(post)
    post && post.user && post.user != current_user
  end
end
