#!/usr/bin/lua


--[[
if (hangup_now) then
   s:consoleLog("CRIT", "LOGGING: " .. hangup_now)
   print(hangup_now)
end
--]]




--simulate stuck call
--[[
while true do
   if session:ready() then
      --print("here")
   else
      session:destroy();
      os.exit()
end
--]]





local wav3 = "ivr/ivr-you_lose.wav"
function all_done(s, how)
   freeswitch.console_log("info", "done: " .. how .. "\n");
end

function my_cb(s, type, obj, arg)
   if (arg) then
      freeswitch.console_log("info", "\ntype: " .. type .. "\n" .. "arg: " .. arg .. "\n");
   else
      freeswitch.console_log("info", "\ntype: " .. type .. "\n");
   end

   if (type == "dtmf") then
      freeswitch.console_log("info", "\ndigit: [" .. obj['digit'] .. "]\nduration: [" .. obj['duration'] .. "]\n");

      if (obj['digit'] == "*") then
         return "stop";
      end

      if (obj['digit'] == "0") then
         return "pause";
      end

      if (obj['digit'] == "#") then
         return "break";
      end

   else
      freeswitch.console_log("info", obj:serialize("xml"));

   end
end

blah = "args";
session:setHangupHook("all_done");
session:setInputCallback("my_cb", "blah");
session:streamFile(wav3);




--[[
local wav3 = "ivr/ivr-you_lose.wav"
local uuid = session:getVariable("uuid")

--METHOD 1, Pound or Star to terminate playback
--session:setVariable("playback_terminators","#*")
--session:execute("playback", wav3)

--METHOD 2, Pound to exec break app
--session:execute("bind_digit_action","myrealm,#,exec:break," .. uuid .. ", aleg, aleg")
--session:streamFile(wav3)

--METHOD 3, Pound to uuid_break api
session:execute("bind_digit_action","myrealm,#,api:uuid_break," .. uuid .. ", aleg, aleg")
session:streamFile(wav3)
--]]





--[[
local max_len = 5
session:recordFile("/var/www/html/fs/my_record_file.wav", max_len)
rmsec = session:getVariable("record_ms")
rsam = session:getVariable("record_samples")
session:consoleLog("INFO","max length: " .. max_len .. " | record milliseconds: " .. rmsec .. " | samples: " .. rsam)
--]]





--[[
session:streamFile("file_string://misc/misc-freeswitch_is_state_of_the_art.wav")
plop = session:getVariable("playback_last_offset_pos")
psec = session:getVariable("playback_seconds")
pmsec = session:getVariable("playback_ms")
psam = session:getVariable("playback_samples")
session:consoleLog("INFO","last offset: " .. plop .. " | seconds: " .. psec .. " | millseconds: " .. pmsec .. " | samples: " .. psam)
--]]





--session:streamFile("file_string://ascii/40.wav!ascii/41.wav")
--session:execute("playback","file_string://ascii/42.wav!ascii/43.wav")





--[[
local auuid = "2bd8c98f-c8f4-40e0-bd8c-3c65ecd877ff"
local buuid = "726aefdd-88b1-45ff-b170-cb05a641c00d"
freeswitch.API():executeString("uuid_bridge " .. auuid .. " " .. buuid)
--]]




--session:execute("redirect","sip:music@iptel.org")
--session:execute("answer")
--session:execute("deflect","sip:music@iptel.org")





--[[
session:setVariable("bind_meta_key","9")
session:execute("bind_meta_app","1 ab s exec::hangup")
session:execute("bridge","${sofia_contact 1005}")
session:execute("playback","tone_stream://%(1000,0,350);loops=-1");

session:execute("bind_digit_action","myrealm,1,exec:hangup");
session:execute("bridge","${sofia_contact 1005}")
session:execute("playback","tone_stream://%(1000,0,350);loops=-1");
--]]





--------------------------------------------------------
-- SETUP "ESL.so" FOR LUA TO COMMUNICATE TO FREESWITCH
--    apt-get install lua5.2
--    git clone https://freeswitch.org/stash/scm/fs/freeswitch.git /usr/src/freeswitch.git
--    cd /usr/src/freeswitch.git
--    ./bootstrap.sh
--    ./configure
--    make -j
--    cd /usr/src/freeswitch.git/libs/esl
--    make luamod
--    mkdir -p /usr/local/lib/lua/5.2
--    cp lua/ESL.so /usr/local/lib/lua/5.2/ESL.so
-------------------------------------------------------
--[[
require("ESL")

--connect to freeswitch esl
local con = ESL.ESLconnection("127.0.0.1", "8021", "ClueCon");

--if sucessful connection give notice in FS log and lua script
if con:connected() == 1 then
    con:api("log","notice Lua ESL connected")
    print("connected!")
end

--notify the aleg_uuid creation
local aleg_uuid_create = con:api("create_uuid","");
aleg_uuid = aleg_uuid_create:getBody()
con:api("log","notice created aleg_uuid: " .. aleg_uuid)
print("created aleg_uuid: " .. aleg_uuid)

--send originate command
originate_response_body = con:api("originate","{origination_uuid=" .. aleg_uuid .. "}user/1000 1010 XML default")

--log origination notice
con:api("log","notice originated " .. aleg_uuid .. " to specified extension")
print("originated " .. aleg_uuid .. " to specified extension")
--]]





--session:consoleLog("CRIT","STATE is : " .. session:getState())

--timez = freeswitch.API():executeString("strftime_tz America/New_York %Z");
--session:say(timez,"en","CURRENT_DATE_TIME","pronounced");
--or
--session:say("1527100299","en","CURRENT_DATE_TIME","pronounced");

--session:execute("sleep","1000")

--session:say("","en","CURRENT_TIME","counted");





--alarm = freeswitch.API():executeString("strepoch");
--session:say(timez,"en","CURRENT_TIME","pronounced");
--session:execute("say","en CURRENT_TIME pronounced ${strepoch()}");







--session:execute("curl","https://cloudpanel-api.1and1.com/v1/servers/0ABED950D9582B5D2D54EB4137FC604D/status/action append_headers X-TOKEN:4d2b3ecc12929ab1e2c8f31118b9246e content-type application/json put '{\"action\": \"POWER_ON\", \"method\": \"SOFTWARE\"}'")

--session:execute("curl","https://cloudpanel-api.1and1.com/v1/servers/0ABED950D9582B5D2D54EB4137FC604D/status/action append_headers X-TOKEN:4d2b3ecc12929ab1e2c8f31118b9246e content-type application/json put '{\"action\": \"POWER_OFF\", \"method\": \"SOFTWARE\"}'")






--[[
function myServerToggle(s, type, obj, arg)
   if (type == "dtmf") then
      if (obj['digit'] == "*") then
      	 server_status = session:getVariable("server_status")
	 if (server_status == "on") then
	    session:setVariable("server_status","off")
	    session:execute("curl","https://cloudpanel-api.1and1.com/v1/servers/0ABED950D9582B5D2D54EB4137FC604D/status/action append_headers X-TOKEN:4d2b3ecc12929ab1e2c8f31118b9246e content-type application/json put '{\"action\": \"POWER_ON\", \"method\": \"SOFTWARE\"}'")
	    return
	 else
            session:execute("playback","misc/error.wav")
	    session:setVariable("server_status","on")
            session:execute("curl","https://cloudpanel-api.1and1.com/v1/servers/0ABED950D9582B5D2D54EB4137FC604D/status/action append_headers X-TOKEN:4d2b3ecc12929ab1e2c8f31118b9246e content-type application/json put '{\"action\": \"POWER_OFF\", \"method\": \"SOFTWARE\"}'")
	    return
         end
      end

   else
      freeswitch.console_log("info", obj:serialize("xml"));
   end
end

if session:ready() then
  session:answer()
  session:setInputCallback("myServerToggle");
  session:execute("playback","tone_stream://%(100,0,350);loops=-1");
end
--]]






--[[
local wav3 = "ivr/ivr-you_lose.wav"
function all_done(s, how)
   freeswitch.console_log("info", "pause done now: " .. how .. "\n");
end

function myPause(s, type, obj, arg)
   if (type == "dtmf") then
      if (obj['digit'] == "*") then
      	 pause_status = session:getVariable("pause_status")
	 if (pause_status == "true") then
	    session:setVariable("pause_status","false")
	    return "pause";
	 else
            session:execute("playback","misc/error.wav")
	    session:setVariable("pause_status","true")
            return "pause";
         end
      end

   else
      freeswitch.console_log("info", obj:serialize("xml"));
   end
end

if session:ready() then
  session:answer()
  session:setHangupHook("all_done");
  session:setInputCallback("myPause");
  session:streamFile(wav3);
  session:execute("playback","tone_stream://%(100,0,350);loops=-1");
end
--]]







--[[
onMessageStreamCallBack=function(session, input_type, data, args)
freeswitch.consoleLog("debug", "Method Enter::onMessageStreamCallBack".. "\n");
if input_type == "dtmf" then
local playBackOption=data["digit"]

if(playBackOption=="7" and onMessageStreamCallBackOptionCount=="0") then
onMessageStreamCallBackOptionCount=playBackOption;
elseif(playBackOption=="7" and onMessageStreamCallBackOptionCount=="7") then
messageSkipOptions=messageSkipOptions..onMessageStreamCallBackOptionCount
end
if(playBackOption=="77") then
nextvmUpdateVMStatus("delete",args)
return
elseif(playBackOption=="99") then
nextvmUpdateVMStatus("save",args)
return
else
return
end
return
end
freeswitch.consoleLog("debug", "Method Exit::onMessageStreamCallBack".. "\n");
end

onMessageStreamCallBack=function(session, input_type, data, args)
freeswitch.consoleLog("debug", "Method Enter::onMessageStreamCallBack".. "\n");
if input_type == "dtmf" then
local playBackOption=data["digit"]

if(playBackOption=="7" and onMessageStreamCallBackOptionCount=="0") then
onMessageStreamCallBackOptionCount=playBackOption;
elseif(playBackOption=="7" and onMessageStreamCallBackOptionCount=="7") then
playBackOption=playBackOption..onMessageStreamCallBackOptionCount
end

if(playBackOption=="77") then
nextvmUpdateVMStatus("delete",args)
return
elseif(playBackOption=="99") then
nextvmUpdateVMStatus("save",args)
return
else
return
end
return
end
freeswitch.consoleLog("debug", "Method Exit::onMessageStreamCallBack".. "\n");
end
--]]








--[[
local wav3 = "ivr/ivr-you_lose.wav"
local uuid = session:get_uuid();
api = freeswitch.API()

function func1()
  api:executeString("uuid_break " .. uuid)
  session:execute("playback","misc/error.wav")
  session:destroy();
end

function func2()
  seek = api:executeString("uuid_getvar " .. uuid .. " playback_last_offset_pos")
  api:executeString("uuid_broadcast " .. uuid .. " " .. wav3 .. "@@" .. seek)
  --session:execute("playback",wav3 .. "@@".. seek)
  api:executeString("uuid_setvar " .. uuid .. " playback_last_offset_pos")
  session:destroy();
end

if argv[1] == "pause" then
    func1()
elseif argv[1] == "unpause" then
    func2()
end

if session:ready() then
  session:answer()
  session:execute("bind_digit_action","myrealm,*,exec:lua,test.lua pause");
  session:execute("bind_digit_action","myrealm,#,exec:lua,test.lua unpause");
  --session:execute("sleep","1000")
  --api:executeString("uuid_broadcast " .. uuid .. " " .. wav3)
  session:execute("playback",wav3)
  --session:execute("sleep","1000")
  session:execute("playback","tone_stream://%(100,0,350);loops=-1");
end
--]]







--[[
local uuid = session:get_uuid();
api = freeswitch.API()
function func1()
    api:executeString("uuid_fileman " .. uuid .. " seek:-2000")
    session:destroy();
end
function func2()
    api:executeString("uuid_fileman " .. uuid .. " seek:+2000")
    session:destroy();
end
if argv[1] == "myarg1" then
    func1()
elseif argv[1] == "myarg2" then
    func2()
end
if session:ready() then
   session:answer()
   session:execute("sleep","1000")
   session:execute("bind_digit_action","myrealm,*,exec:lua,test.lua myarg1");
   session:execute("bind_digit_action","myrealm,#,exec:lua,test.lua myarg2");
   session:execute("bind_digit_action","myrealm,0,api:uuid_break," .. uuid);
   --session:execute("playback","$${sounds_dir}/joshebosh/Answering_Machine.wav")
   session:execute("playback","tone_stream://%(100,0,350);loops=-1");
end
--]]





--[[
local wav1 = "ivr/ivr-welcome_to_freeswitch.wav";
local wav2 = "ivr/ivr-please_hold_while_party_contacted.wav";

function func1()
    session:consoleLog("CRIT","function 1 executed");
    session:execute("playback", wav1);
    session:destroy();
end
function func2()
    session:consoleLog("CRIT","function 2 executed");
    session:execute("playback", wav2);
    session:destroy();
end
if argv[1] == "myarg1" then
    func1()
elseif argv[1] == "myarg2" then
    func2()
end

session:answer();
session:execute("bind_digit_action","myrealm,*,exec:lua,test.lua myarg1");
session:execute("bind_digit_action","myrealm,#,exec:lua,test.lua myarg2");
session:execute("bind_digit_action","myrealm,0,api:uuid_break," .. uuid);

--HIGH TONE
session:execute("playback","tone_stream://%(500,500,1000,800,500);loops=1");

--ENDLESS TONE
session:execute("playback","tone_stream://%(100,0,150);loops=-1");
--session:execute("clear_digit_action","myrealm");
session:execute("playback","tone_stream://%(100,0,350);loops=-1");
--]]






--[[
wav1 = "$${sounds_dir}/joshebosh/Error_Message.wav"
wav2 = "$${sounds_dir}/joshebosh/All_Circuits_Busy.mp3"

session:execute("bind_digit_action","myrealm,555,exec:playback," .. wav1);
session:execute("bind_digit_action","myrealm,556,exec:lua,test2.lua");
session:execute("set","playback_delimiter=#");
session:execute("set","playback_sleep_val=100");
session:execute("bind_digit_action","myrealm,557,exec:playback," .. wav1 .. "#" .. wav2);
session:execute("bind_digit_action","myrealm,557,exec:playback,file_string://" .. wav1 .. "!" .. wav2);
--]]





--[[
wav1 = "ivr/ivr-welcome_to_freeswitch.wav"
wav2 = "ivr/ivr-you_are_number_one.wav"
function func1()
   session:consoleLog("CRIT","myarg1 executed");
   session:execute("playback", wav1);
end
function func2()
   session:consoleLog("CRIT","myarg2 executed");
   session:execute("playback", wav2);
end
if argv[1] == "myarg1" then
   func1()
elseif argv[1] == "myarg2" then
   func2()
   session:hangup()
end

session:answer();
session:execute("bind_digit_action","myrealm,558,exec:lua,test.lua myarg1");
session:execute("bind_digit_action","myrealm,559,exec:lua,test.lua myarg2");
session:execute("playback","tone_stream://%(1000,0,350);loops=5");
--]]





--session:execute("uuid_displace ".. uuid .. " start $${sounds_dir}/joshebosh/All_Circuits_Busy.mp3 0 mux"





--[[
--PLAY SINGLE FILE TO BOTH CHANNELS
freeswitch.API():executeString("uuid_broadcast " .. event:getHeader("variable_uuid") .. " tone_stream://%(500,500,500);loops=2 both");

--PLAY SEPERATE FILES TO EACH CHANNEL
--freeswitch.API():executeString("uuid_displace " .. event:getHeader("variable_uuid") .. " start tone_stream://%(500,500,500);loops=2 0 mux");
--freeswitch.API():executeString("uuid_displace " .. event:getHeader("variable_originate_signal_bond") .. " start tone_stream://%(500,500,500);loops=2 0 mux");
--]]







--[[
local event = freeswitch.Event("custom","stack::smasher");
stack_smasher = "sendmsg " .. uuid .. "\n" ..
	      "execute-app-name: playback" .. "\n" ..
	      "execute-app-arg: tone_stream://%(500,500,500);loops=-1" .. "\n";
event:addBody(stack_smasher);
event:fire();
--]]







--[[
#!/usr/local/bin/lua
require("ESL")
local con = ESL.ESLconnection("127.0.0.1", "8021", "ClueCon");
if con:connected() == 1 then print("connected!") end
local e = con:api("version");
print(e:getBody());
--]]








--session:say("10","en","NUMBER","pronounced");
--session:say("45","en","NUMBER","pronounced");
--session:say("PM","en","NAME_SPELLED","pronounced");

--session:set_tts_params("watson_ws", "en-US_LisaVoice");
--session:speak("joshua can do professional sounding TTS with mod_watson");







--[[
session:execute("set","amd_execute_on_machine=transfer machine_found XML default");
session:execute("set","amd_execute_on_person=transfer person_found XML default");
session:execute("set","amd_execute_on_unsure=transfer amd_unsure XML default");
session:execute("set","api_on_answer=uuid_displace ${uuid} start ${sounds_dir}/joshebosh/Answering_Machine.wav 0 mr");

session:execute("voice_start")
session:execute("answer");

--filename is optional
session:execute("waitforresult","ivr/ivr-one_moment_please.wav");
session:execute("info");

mystatus = session:getVariable("amd_status")

if mystatus == "machine" or "person" then~
   return
else
 session:consoleLog("CRIT","dont know")
end

session:execute("sleep","5000");
session:execute("playback","tone_stream://%(200,100,500,400,300,50,25);loops=2");
session:execute("sleep","200");
session:execute("log","CRIT AMD Result is => ${amd_status} => ${amd_result}");
session:execute("voice_stop");
session:execute("hangup");
--]]










--[[
local dst_number = argv[1]
-- Connecting to the freeswitch API.
api = freeswitch.API()
use_amd = api:executeString("amd_available")

subscriber_session = freeswitch.Session("{ignore_early_media=true}sofia/gateway/mygw/" .. dst_number)

while (subscriber_session:ready() and not subscriber_session:answered()) do
  -- Waiting for answer.
  freeswitch.msleep(500)
end

if subscriber_session:ready() and subscriber_session:answered() then
  freeswitch.consoleLog("INFO", string.format("Number answered call %s.", dst_number))
  freeswitch.consoleLog("INFO", string.format("AMD Enable on %s.", dst_number))
  if use_amd == "true" then
    subscriber_session:execute("voice_start")
    -- Giving some time to AMD to work on the call.
    subscriber_session:sleep(3000)
    subscriber_session:execute("voice_stop")
    amd_detect = subscriber_session:getVariable("amd_status")
    if amd_detect == "machine" then
      freeswitch.consoleLog("INFO", "amd_status: machine")
      subscriber_session:execute("wait_for_silence", "300 30 5 25000")
      subscriber_session:execute("playback", "/usr/local/freeswitch/sounds/en/us/callie/ivr/8000/ivr-welcome_to_freeswitch.wav")
      subscriber_session:hangup()
      return
    end
    -- Do your actions if human answered. Ex. Transfer to operator/user 100.
    subscriber_session:execute("bridge", "user/100")
  end
else
  freeswitch.consoleLog("INFO", string.format("Cannot call %s", dst_number))
  return
end
--]]










--[[
local event = freeswitch.Event("playfile");

test = "sendmsg " .. uuid .. "\n" ..
"call-command: execute\n" ..
"execute-app-name: playback\n" ..
"execute-app-arg: /usr/local/freeswitch/sounds/joshebosh/Error_Message.wav\n\n";
session:execute("log","CRIT " .. test);
stream:write(test);
--]]







--[[
i=0;
while (i<25)
do
	freeswitch.API():executeString("bgapi uuid_broadcast " .. uuid .. " " .. wav);
	--session:execute("playback", wav);
	i = i+1
end
--]]






--os.execute("sox /tmp/audio1.wav /tmp/audio2.wav /tmp/merge.wav")
-- or RECORD_APPEND=true








--[[
session:answer();

max_len_secs = 0
silence_threshold = 50
silence_secs = 5

record_filename="/var/www/html/fs/" .. uuid .. ".wav";
session:execute("set","playback_terminators=#");
session:execute("set","debug_energy_level=true");

ended_by_silence = session:recordFile(record_filename, max_len_secs, silence_threshold, silence_secs);

session:execute("info");

if (ended_by_silence == 1) then
   session:consoleLog("CRIT", "ended_by_silence = " .. ended_by_silence );
   silence = session:getVariable("silence_hits_exhausted")
   if (silence == "true") then
      session:consoleLog("CRIT", "recording ended by silence");
   end
end

if (ended_by_silence == 0)  then
    session:consoleLog("info","record success next voice mail");
    -- voice mail
end
session:hangup();
--]]








--[[
rec_time = session:getVariable("record_seconds")
if (silence_hits_exhausted=false) then
   if (max_rec_time == rec_time) then
      session:setVariable("max_record_time_exhausted=true")
   end
end
--]]









--[[
session:answer();

function onInputCBF(s, _type, obj, arg)
    local k, v = nil, nil
    local _debug = true
    if _debug then
        for k, v in pairs(obj) do
           --  printSessionFunctions(obj)
            print(string.format('obj k-> %s v->%s\n', tostring(k), tostring(v)))
        end
        if _type == 'table' then
            for k, v in pairs(_type) do
                print(string.format('_type k-> %s v->%s\n', tostring(k), tostring(v)))
            end
        end
        print(string.format('\n(%s == dtmf) and (obj.digit [%s])\n', _type, obj.digit))
    end
    if (_type == "dtmf") then
        return 'break'
    else
        return ''
    end
end

recording_dir = '/var/www/html/fs/'
filename = 'myfile.wav'
recording_filename = string.format('%s%s', recording_dir, filename)

if session:ready() then
    session:setInputCallback('onInputCBF', '');
    -- syntax is session:recordFile(file_name, max_len_secs, silence_threshold, silence_secs)
    max_len_secs = 30
    silence_threshold = 20
    silence_secs = 5
    session:execute("set","playback_terminators=#")
    ended_by_silence = session:recordFile(recording_filename, max_len_secs, silence_threshold, silence_secs);
    session:consoleLog("info", "session:recordFile() = " .. ended_by_silence )
    if (ended_by_silence == 1) then
       session:consoleLog("info", "recording end by silence time reached");
       silence = session:getVariable("silence_hits_exhausted")
       if (silence == "true") then
       	  session:consoleLog("CRIT", "recording ended by silence!");
       end
    end
    if (ended_by_silence == 0)  then
       session:consoleLog("info","record success next voice mail");
      -- voice mail
   end

end
--]]







--session:consoleLog("CRIT", "executed test.lua");
--while (session:ready() == true) do
--	session:execute("playback","tone_stream://%(100,0,200)");
--end
