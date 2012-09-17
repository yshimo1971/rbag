require 'net/telnet'
require 'pp'

server = Net::Telnet.new("Host" => "192.168.36.140")
server.login("root","3ndea7g")
results=server.cmd("cat /etc/redhat-release")
server.cmd("exit")
server.close
pp results