require 'webrick'
require_relative '../lib/phase2/controller_base'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html

class MyController < Phase2::ControllerBase
  def go
    if @req.path == "/cats"
      render_content("hello cats!", "text/html")
    else
      redirect_to("/cats")
    end
  end
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  MyController.new(req, res).go
end
############################PHASE 1/WARM UP#####################################
# server = WEBrick::HTTPServer.new(Port: 3000)
# server.mount_proc('/') do |req, res|
#   res.content_type = 'text/text'
#   res.body = req.path #response automatically sent back
# end
################################################################################
trap('INT') { server.shutdown }
server.start
