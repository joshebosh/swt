#!/usr/bin/lua
require("ESL")
local esl = ESL.ESLconnection("127.0.0.1", "8021", "ClueCon")
local aleg_uuid_create = esl:api("create_uuid")
local aleg_uuid = aleg_uuid_create:getBody()

esl:api("log","notice created aleg_uuid: " .. aleg_uuid)
print("created aleg_uuid: " .. aleg_uuid)

--esl:api("originate","{ignore_early_media=true,origination_uuid="..aleg_uuid..",originate_timeout=60,origination_caller_id_number=1021,origination_caller_id_name=LuaClient,loopback_bowout_on_execute=false}loopback/echo &endless_playback($${recordings_dir}/josh_video_loop.mp4)")

--esl:api("originate","{ignore_early_media=true,origination_uuid="..aleg_uuid..",originate_timeout=60,origination_caller_id_number=1021,origination_caller_id_name=LuaClient,loopback_bowout_on_execute=false}loopback/echo &echo()")

--print("type commmand")
--input = io.read()
stream:write("api version")
