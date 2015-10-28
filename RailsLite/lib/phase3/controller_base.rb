require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
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
  end
end
