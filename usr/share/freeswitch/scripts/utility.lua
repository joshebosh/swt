-- utility.lua
--function shell(c)
--   local o, h
--   h = assert(io.popen(c,"r"))
--   o = h:read("*all")
--   h:close()
--   return o
--end

function shell(c)
	 session:execute("set","response=${system " .. c .. "}")
	 return session:getVariable("response")
end

freeswitch.consoleLog("INFO", "utility.lua has been executed")
