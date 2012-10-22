module GravatarHelper
  def gravatar(user)
    email = user.email.strip.downcase
    hash  = Digest::MD5.hexdigest(email)
    %Q[<img alt="#{user.name}" src="http://www.gravatar.com/avatar/#{hash}?d=identicon" />]
  end
end
