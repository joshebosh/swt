#!/usr/bin/lua

#git clone https://github.com/joshebosh/luasocket.git /usr/src/luasocket
#cd /usr/src/luasocket
#make
#make install
## specific to my server, yours might go else where
#cp -r /usr/local/freeswitch/share/lua/* /usr/local/share/lua/
#cp -r /usr/local/freeswitch/lib/lua/* /usr/local/lib/lua/
   

-----------------
-- server stuff
-----------------

require("ESL")
local socket = require("socket")

host = host or "*"
port = port or 8023

print("Binding to host '" ..host.. "' and port " ..port.. "...")
s = assert(socket.bind(host, port))
c = assert(s:accept())
fd = c:getfd()
esl = ESL.ESLconnection(fd)

info = esl:getInfo()
--print(info:serialize())
--esl:sendRecv("myevents")

uuid = info:getHeader("unique-id")
print(uuid)
 
esl:execute("answer")
esl:execute("playback", "tone_stream://%(2000,4000,440,480);loops=-1")
esl:execute("echo")



------------------------------------------------------
-- client stuff
------------------------------------------------------


local host, port = "127.0.0.1", 8021;
local socket = require("socket");
local tcp = assert(socket.tcp());
local connect = tcp:connect(host, port);
local auth_send = tcp:send("auth ClueCon\n\n");
local count = 0;
while true do
   local auth_data, auth_error, auth_partial = tcp:receive();
   print(auth_data or "no data");
   print(auth_error or "no error");
   print(auth_partial or "no partial");
   if auth_data == "\n" then break end
end


while true do
   print("> ");
   command = io.read()
   --io.write(command)
   if command == "exit" then tcp:send("api hupall\n\n"); tcp:close(); end
   tcp:send(command.."\n\n")
   local data, status, partial = tcp:receive()
   print(data or status or partial)
end
