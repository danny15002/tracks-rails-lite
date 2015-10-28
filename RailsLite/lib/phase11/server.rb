require 'webrick'
require './railsLite'

router = Router.new
router.draw do
  #This should be the routes in the resources file of a rails project
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
