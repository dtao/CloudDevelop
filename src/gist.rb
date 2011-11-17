require 'httparty'

class Gist
  include HTTParty

  format :json

  def initialize(user, password)
    self.class.basic_auth user, password
  end

  def create(name, description, content)
    body = {
      :description => description,
      :public => true,
      :files => {
        name => {
          :content => content
        }
      }
    }

    self.class.post 'https://api.github.com/gists', :body => body.to_json
  end
end