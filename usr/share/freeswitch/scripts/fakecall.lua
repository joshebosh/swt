---------------------------------
-----Simulates a random call-----
-----------RpG-RoughRaf-2009-----

-- released under the terms of the
-- WTF Public License http://sam.zoy.org/wtfpl/

function logInfo(what)
   freeswitch.consoleLog("info", "fakecall-" .. seed .. " - " .. what .. "\n\r");
end

function waitARandomTime()
   wait = math.random(3000, 15000) ;
   logInfo("waiting " .. (wait) .. " msecs");
   session:sleep(wait);
end

function saySomethingNRandomTimes()
   n = math.random(1,10);
   logInfo("saying something " .. n .. " times");
   session:set_tts_parms("flite", "kal");
   session:speak("Hello! Who's speaking?");
   session:sleep(2000);
   session:speak("As I am a stupid robot I will just say something " .. n .. " times.");
   for i=1,n do
      if session:ready() == false then break end;
      logInfo("saying something for the " .. i .. " out of " .. n .. " time");
      session:speak("" .. i .. " out of " .. n .. ": Please stay tuned for more happy days");
   end
end

function randomize()
   api = freeswitch.API();
   seed = tonumber(api:execute("global_getvar", "randomseed"));
   if seed == 12345678 or seed == "" or seed == nil then
      seed = os.time();
   end
   math.randomseed(seed);
   seed = math.random(1,999999)
   api:execute("global_setvar", "randomseed=" .. seed)
end

function simulateNetworkLatency()
   logInfo("simulating network latency");
   session:sleep(math.random(100,500));
end

immediateHangupCauses = {"USER_BUSY", "NO_ROUTE_DESTINATION", "SUBSCRIBER_ABSENT"};
lateHangupCauses = {"CALL_REJECTED", "NO_ANSWER", "NO_USER_RESPONSE"};

function rejectCall()
   if math.random(1,3) == 1 then
      cause = immediateHangupCauses[math.random(1,table.getn(immediateHangupCauses))];
      logInfo("cause is " .. cause);
   else
      cause = lateHangupCauses[math.random(1,table.getn(lateHangupCauses))];
      delay = math.random(1000,5000);
      logInfo("cause will be " .. cause .. " rejecting in " .. delay .. " seconds");
      session:sleep(delay);
   end
   session:execute("hangup", cause);
   logInfo("hangup");
end

seed=12345678;
randomize()

logInfo("fakecall.lua up and running");
session:preAnswer();
simulateNetworkLatency()

if math.random(1,3) == 1 then
   logInfo("I will accept the call");
   waitARandomTime();
   session:answer();
   saySomethingNRandomTimes();
   logInfo("hanging up");
   session:hangup();
else
   logInfo("I will reject the call");
   rejectCall();
end

logInfo("bye...");
