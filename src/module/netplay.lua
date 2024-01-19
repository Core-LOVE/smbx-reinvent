local NetPlay = {}

local socket = require "socket"

NetPlay.address = "localhost"
NetPlay.port = 12345

function NetPlay:setup()
	local udp = socket.udp()
	udp:settimeout(0)
	udp:setpeername(self.address, self.port)

	NetPlay.udp = udp
end

function NetPlay:send(str)
	local udp = NetPlay.udp

	if udp then return udp:send(str) end
end

function NetPlay:receive()
	local udp = NetPlay.udp

	if udp then return udp:receive() end
end 

return NetPlay