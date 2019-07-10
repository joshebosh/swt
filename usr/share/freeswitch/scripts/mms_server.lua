#!/usr/bin/lua
local socket = require("socket")

local host = host or "192.168.150.3"
local port = port or 8090

print("Binding to host '" ..host.. "' and port " ..port.. "...")
s = assert(socket.bind(host, port))
c = assert(s:accept())
fd = c:getfd()


while true do
   command = io.read()
   --io.write(command)
   if command == "exit" then tcp:close(); end
   c:send("HTTP/1.1 200 OK")
   local data, status, partial = c:receive()
   print("data: " .. data or "status: " .. status or "partial: " .. partial)
   c:send("HTTP/1.1 200 OK")
   
end
