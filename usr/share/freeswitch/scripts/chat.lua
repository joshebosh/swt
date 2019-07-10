--local body = message:getBody();
local body = freeswitch.Event("MESSAGES")

freeswitch.consoleLog("INFO","Message body: " .. body .. "\n");

--local api = freeswitch.API();
--api:executeString("sms_flowroute_send default|" .. sender .. "|" .. recipient .. "|Message received.");

--local new_destination = "19312989898";
--api:executeString("sms_flowroute_send default|" .. new_destination .. "|" .. recipient .. "|" .. body);
