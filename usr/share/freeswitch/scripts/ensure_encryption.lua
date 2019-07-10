session:consoleLog("CRIT", "ensure_encryption.lua - Entered.");

local max_verto_retries = 20

--session:answer();
session:consoleLog("CRIT", "ensure_encryption.lua - Answered.");
session:streamFile("silence_stream://2000");

local source = session:getVariable("source");

--[[
if source == "mod_verto" then
    local rtp_has_crypto = session:getVariable("rtp_has_crypto");

    local count_of_verto_retries = 0
    while( count_of_verto_retries < max_verto_retries )
    do
        if rtp_has_crypto ~= nil then
            session:streamFile("silence_stream://500");
            rtp_has_crypto = session:getVariable("rtp_has_crypto");
        else
            break
        end
        count_of_verto_retries=count_of_verto_retries+1
    end
    if rtp_has_crypto ~= nil then
        session:streamFile("/etc/freeswitch/dialplan/WatsonTTS_YourCallCouldNotBeEncrypted_PleaseCloseSomeAppsOrUseAMorePowerfulComputer.wav");
        session:hangup("VERTO_DTLS_SETUP_FAILED");
    end
end
--]]

session:consoleLog("CRIT", "ensure_encryption.lua - Checking if source is sofia.");
if source == "mod_sofia" then
   session:consoleLog("CRIT", "customer is using mod_sofia...");
   local rtp_secure_media_negotiated = session:getVariable("rtp_secure_media_negotiated");
   if rtp_secure_media_negotiated == nil then
      session:consoleLog("CRIT", "ensure_encryption.lua - Rejecting SIP call for lack of encryption.");
      session:execute("speak","flite|slt|This call is unsecure, please try again");
      --session:hangup("SIPS_SETUP_FAILED");
      session:consoleLog("CRIT", "ensure_encryption.lua - Hangup with SIPS_SETUP_FAILED.");
   else
      session:consoleLog("CRIT", "ensure_encryption.lua - Sofia call has rtp_secure_media_negotiated = " .. rtp_secure_media_negotiated);
   end
end
