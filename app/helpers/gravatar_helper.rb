module GravatarHelper
  def gravatar(user, options={})
    email = user.email.strip.downcase
    hash  = Digest::MD5.hexdigest(email)
    %Q[<img alt="#{user.name}" src="http://www.gravatar.com/avatar/#{hash}?d=identicon#{query_string_for_options(options)}" />]
  end

  def query_string_for_options(options)
    options.map { |key, value| "&#{key}=#{value}" }.join("")
  end
end
