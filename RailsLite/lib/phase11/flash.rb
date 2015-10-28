class Flash
  attr_accessor :now
  COUNTER_KEY = "fdjksafjdklsafsladfjsldafjsdlafjkdsalfjsadklsa"
  def initialize(req)
    @now = {}
    process(req)
  end

  def process(req)
    cookie_json = req.cookies.find {|cookie| cookie.name == '_rails_lite_app_flash'}
    if cookie_json.nil?
      @f_hash = {}
      @f_hash[COUNTER_KEY] = 0
      return
    end

    cookie_value = JSON.parse(cookie_json.value)
    if cookie_value[COUNTER_KEY] > 2
      @f_hash = {}
      @f_hash[COUNTER_KEY] = 0
    else
      @f_hash = cookie_value
    end
  end

  def []=(key, value)
    @f_hash[key.to_s] = value
  end

  def [](key)
    @f_hash[key]
  end

  def store_flash(res)
    p @f_hash
    @f_hash[COUNTER_KEY] += 1
    res.cookies << WEBrick::Cookie.new('_rails_lite_app_flash',
                                         JSON.generate(@f_hash))
  end

end
