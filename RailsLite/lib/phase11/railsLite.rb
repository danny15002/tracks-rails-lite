require_relative 'flash'
require_relative 'params'
require_relative 'router'
require_relative 'session'

class ControllerBase
  attr_reader :req, :res

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @already_built_response = false
    @params = Params.new(req, route_params)
    #create flash here
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    if already_built_response?
      raise Exception.new "already built response"
    else
      self.res.header["location"] = url
      self.res.status = 302
      @already_built_response = true
    end

    session.store_session(self.res)
    flash.store_flash(self.res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render(template_name)
    # rails also renders the application html and then renders a specific
    # page's view inside of that.
    file_name = "views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
    file_contents = ""
    File.open(file_name.to_s).each do |line|
      file_contents += line
    end
    erb_out = ERB.new(file_contents).result(binding)
    render_content(erb_out, 'text/html')
  end

  def render_content(content, content_type)
    if already_built_response?
      raise Exception.new "already built response"
    else
      self.res.content_type = content_type
      self.res.body = content
      @already_built_response = true
    end

    session.store_session(self.res)
    flash.store_flash(self.res)
    res.status = 200
  end

  def session
    @session ||= Session.new(self.req)
  end

  def flash
    @flash ||= Flash.new(self.req)
  end

  def invoke_action(name)
    send(name)
    #TO DO render
  end
end
