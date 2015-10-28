require 'json'
require 'webrick'


class Csrf
  # The auth token should be in the params hash.
  
  def initialize(req)
    cookie = req.cookies.find {|cookie| cookie.name == '_rails_lite_app'}
  end

  def generate_token
    @auth_token = SecureRandom.urlsafe_base64
  end

  def form_authenticity_token
    @auth_token
  end

  def [](key)
    @value[key]
  end

  def []=(key, val)
    @value[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_csrf(res)
    res.cookies << WEBrick::Cookie.new('_rails_lite_app',
                                       JSON.generate(@value))
  end
end
