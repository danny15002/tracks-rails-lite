
class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  # checks if pattern matches path and method matches request method
  def matches?(req)
    req.request_method.downcase.to_sym == http_method &&
    (pattern =~ req.path) != nil
  end

  # use pattern to pull out route params (save for later?)
  # instantiate controller and call controller action
  def run(req, res)
    r_params = req.path.match(/(?<controller>\w+)\/(?<id>\d+)/)
    rout_params = Hash.new
    if r_params.nil?
      rout_params = {}
    else
      r_params.names.each do |key|
        rout_params[key] = r_params[key]
      end
    end
    controller_class.new(req,res,rout_params ).invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  # simply adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    self.routes << Route.new(pattern, method, controller_class, action_name)
  end

  # evaluate the proc in the context of the instance
  # for syntactic sugar :)
  def draw(&proc)
    instance_eval &proc
  end

  # make each of these methods that
  # when called add route
  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |path, controller, method|
      add_route(path, http_method, controller, method)
    end
  end

  # should return the route that matches this request
  def match(req)
    rout = routes.select {|route| route.matches?(req)}
    return nil if rout.empty?
    rout.first
  end

  # either throw 404 or call run on a matched route
  def run(req, res)
    matchh = match(req)
    if matchh.nil?
      res.status = 404
    else
      matchh.run(req, res)
    end
  end
end
