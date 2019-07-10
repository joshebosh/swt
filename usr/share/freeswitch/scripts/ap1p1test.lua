dofile("/usr/local/freeswitch/scripts/utility.lua")

session:setAutoHangup(false)

local queue_id = argv[1]
local SIPCallID = session:getVariable("sip_call_id")

api = freeswitch.API()

session:execute( "playback", "$${sounds_dir}/joshebosh/Error_Message.wav")

freeswitch.consoleLog("INFO", "QID=" .. queue_id .. "\n")

        curl_params = "https://brightforest.net/IVR -X POST -H \"Content-Type: application/json\""
        --curl_params = "-d private=1 -d text=\"this is test\" https://pastebin.freeswitch.org/api/create"
        freeswitch.consoleLog("INFO", "\nPosting data : \n" .. curl_params .. "\n")
        response = shell("curl " .. curl_params)
        freeswitch.consoleLog("INFO", "\n" .. response .. "\n")

session:transfer("AP1_exit")
