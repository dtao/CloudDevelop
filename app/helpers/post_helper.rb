module PostHelper
  def post_belongs_to_someone_else?(post)
    post && post.user && post.user != current_user
  end

  def can_vote_for_post?(post)
    current_user && current_user != post.user && current_user.upvote_for(post).nil?
  end
end
