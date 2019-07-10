local has_tts = true

function get_json_string(s, k)
	if not s then return nil end

	local i, j = string.find(s, '"' .. k .. '":');

	if j then
		s = s:sub(j+1)
		i, j = s:find('".-"');
		if i then
			return s:sub(i+1, j-1)
		end
	end

	return nil
end

function onInput(s, type, obj)
	if type == "event" then
		s:consoleLog("DEBUG", obj:serialize())
	end

	if obj:getHeader("Speech-Type") == "detected-speech" then
        json = obj:getBody();

        if json then
			text = get_json_string(json, "text")
        end

		if text and not (text == '') then
			session:consoleLog("ERR", "speak: " .. text .. "\n")
			session:speak(text)
		else
			session:speak("Not heard")
		end

		text = ""

		session:execute("detect_speech", "resume")
		session:execute("detect_speech", "start_input_timers")
	end

	return ""
end

session:answer()

if (has_tts) then
	session:set_tts_params("gcloud", "default")
	session:speak("welcome, what can I do for you?")
end

session:setInputCallback("onInput");
session:execute("detect_speech", "gcloud_speech default default default")
session:execute("detect_speech", "param start-input-timers true")
session:execute("detect_speech", "param no-input-timeout 5000")
session:execute("detect_speech", "param speech-timeout 5000")
session:execute("detect_speech", "param language en-US")
session:execute("detect_speech", "start_input_timers")
session:streamFile("silence_stream://90000000")
