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
			text = get_json_string(json, "query_text")
			response = get_json_string(json, "text")

			if not text or text == "" then
				text = last_text
			end
		end

		return "break";
	end

	return ""
end

session:answer()

session:set_tts_params("gcloud", "default")
last_text = "welcome, what can I do for you?"

session:setInputCallback("onInput");

while session:ready() do
	session:speak(last_text)

	text = "";
	response = "";

	while session:ready() and response == "" do
		session:execute("detect_speech", "gcloud_dialogflow default default default")
		session:execute("detect_speech", "param speech-timeout 25000")
		session:execute("detect_speech", "param start-input-timers true")
		session:execute("detect_speech", "param project-id my-gcloud-agent")
		session:execute("detect_speech", "param channel-uuid " .. session:get_uuid())
		session:execute("detect_speech", "start_input_timers")

		session:execute("detect_speech", "param clear-hint")
		session:execute("detect_speech", "param hint room")
		session:execute("detect_speech", "param hint 'book a room'")
		session:execute("detect_speech", "param hint today")
		session:execute("detect_speech", "param hint New York")
		session:execute("detect_speech", "param hint mountain")
		session:execute("detect_speech", "param hint 'mountain view'")
		session:execute("detect_speech", "param hint large")
		session:execute("detect_speech", "param hint 3 p.m")
		session:execute("detect_speech", "param hint 3 people")
		session:execute("detect_speech", "param hint 3 hours")
		session:execute("detect_speech", "param hint medium")
		session:execute("detect_speech", "param hint small")

		session:streamFile("silence_stream://5000")
		session:execute("detect_speech", "stop")
	end

	if (text) then
		session:speak("It sounds like you said: " .. text)
	end

	if (response) then
		session:speak("Google heard that and replied: ")
		last_text = response
	else
		last_text = "pardon?"
	end

end
