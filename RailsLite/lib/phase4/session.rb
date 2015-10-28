require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      # p req.cookies
      cookie = req.cookies.find {|cookie| cookie.name == '_rails_lite_app'}
      if cookie.nil?
        @value = Hash.new
      elsif cookie.value.nil?
        @value = Hash.new
      else
        @value = JSON.parse(cookie.value)
      end
    end

    def [](key)
      @value[key]
    end

    def []=(key, val)
      @value[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)

      res.cookies << WEBrick::Cookie.new('_rails_lite_app',
                                         JSON.generate(@value))
    end
  end
end
