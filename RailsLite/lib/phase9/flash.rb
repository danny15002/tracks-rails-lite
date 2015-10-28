class Flash

  def initialize(req)
    @cookies = req.cookies
     
  end

  def now=(message)
    @now = message
  end

  def remove_cookie
  end
end
