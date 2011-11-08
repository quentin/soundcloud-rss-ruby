$:.unshift File.join(File.dirname(__FILE__),"..","..","lib")

require 'soundcloudrss'
require 'webrick'

class SoundcloudRssServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(req,rep)
    rep.status = 200
    rep['Content-Type'] = 'application/rss+xml'
    soundrss = SoundcloudRSS.new
    rep.body = soundrss.rss.to_s
  end
end

server = WEBrick::HTTPServer.new :ServerName => '0.0.0.0', :Port => 8080
server.mount "/soundrss", SoundcloudRssServlet
trap('INT') { server.stop }
server.start
