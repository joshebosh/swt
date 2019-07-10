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

session:set_tts_params("gcloud", "default")
session:setVariable("tts_engine", "gcloud")
session:setVariable("tts_voice", "default")
session:answer()

text = 'Hello, what I can do for you?'
last_text = text
while session:ready() do
	arg = "say:" .. text .. " detect:gcloud_speech " ..
		"{language=en-US,start-input-timers=true,no-input-timeout=5000,speech-timeout=5000}default"
	session:execute("play_and_detect_speech", arg)
	res = session:getVariable("detect_speech_result")
	session:consoleLog("INFO", res)

	if res then
		text = get_json_string(res, "text")
	end

	if not text or text == "" then
		text = "I heard nothing"
		last_text = "text"
	else
		last_text = text
	end
end
