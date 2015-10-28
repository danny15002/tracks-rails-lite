require_relative '../phase3/controller_base'
require_relative './session'

module Phase4
  class ControllerBase < Phase3::ControllerBase
    def redirect_to(url)
      super
      session.store_session(self.res)
    end

    def render_content(content, content_type)
      super
      session.store_session(self.res)
      res.status = 200
    end

    # method exposing a `Session` object
    def session
      @session ||= Session.new(self.req)
    end
  end
end
