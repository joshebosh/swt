freeswitch.consoleLog("info", "\n\nstart acid.lua\n\n\n\n\n\n\n\n");

local uuid = freeswitch.API():executeString("global_getvar aleg");

local caller_id_name = freeswitch.API():executeString("expand uuid_getvar $${aleg} caller_id_name") or 0;
local caller_id_number = freeswitch.API():executeString("expand uuid_getvar $${aleg} caller_id_number") or 0;
local orig_caller_id_name = freeswitch.API():executeString("expand uuid_getvar $${aleg} orig_caller_id_name") or 0;
local orig_caller_id_number = freeswitch.API():executeString("expand uuid_getvar $${aleg} orig_caller_id_number") or 0;
local callee_id_name = freeswitch.API():executeString("expand uuid_getvar $${aleg} callee_id_name") or 0;
local callee_id_number = freeswitch.API():executeString("expand uuid_getvar $${aleg} callee_id_number") or 0;
local outbound_caller_id_name = freeswitch.API():executeString("expand uuid_getvar $${aleg} outbound_caller_id_name") or 0;
local outbound_caller_id_number = freeswitch.API():executeString("expand uuid_getvar $${aleg} outbound_caller_id_number") or 0;
local original_caller_id_name = freeswitch.API():executeString("expand uuid_getvar $${aleg} original_caller_id_name") or 0;
local original_caller_id_number = freeswitch.API():executeString("expand uuid_getvar $${aleg} original_caller_id_number") or 0;
local last_sent_callee_id_name = freeswitch.API():executeString("expand uuid_getvar $${aleg} last_sent_callee_id_name") or 0;
local last_sent_callee_id_number = freeswitch.API():executeString("expand uuid_getvar $${aleg} last_sent_callee_id_number") or 0;
local pre_transfer_caller_id_name = freeswitch.API():executeString("expand uuid_getvar $${aleg} pre_transfer_caller_id_name") or 0;
local pre_transfer_caller_id_number = freeswitch.API():executeString("expand uuid_getvar $${aleg} pre_transfer_caller_id_number") or 0;
local conference_auto_outcall_caller_id_name = freeswitch.API():executeString("expand uuid_getvar $${aleg} conference_auto_outcall_caller_id_name") or 0;
local conference_auto_outcall_caller_id_number = freeswitch.API():executeString("expand uuid_getvar $${aleg} conference_auto_outcall_caller_id_number") or 0;
local origination_caller_id_name = freeswitch.API():executeString("expand uuid_getvar $${aleg} origination_caller_id_name") or 0;
local origination_caller_id_number = freeswitch.API():executeString("expand uuid_getvar $${aleg} origination_caller_id_number") or 0;
local voicemail_caller_id_name = freeswitch.API():executeString("expand uuid_getvar $${aleg} voicemail_caller_id_name") or 0;
local voicemail_formatted_caller_id_number = freeswitch.API():executeString("expand uuid_getvar $${aleg} voicemail_formatted_caller_id_number") or 0;
local voicemail_caller_id_number = freeswitch.API():executeString("expand uuid_getvar $${aleg} voicemail_caller_id_number") or 0;
local verto_remote_caller_id_name = freeswitch.API():executeString("expand uuid_getvar $${aleg} verto_remote_caller_id_name") or 0;
local verto_remote_caller_id_number = freeswitch.API():executeString("expand uuid_getvar $${aleg} verto_remote_caller_id_number") or 0;
local remote_caller_id_name = freeswitch.API():executeString("expand uuid_getvar $${aleg} remote_caller_id_name") or 0;
local remote_caller_id_number = freeswitch.API():executeString("expand uuid_getvar $${aleg} remote_caller_id_number") or 0;
local effective_caller_id_name = freeswitch.API():executeString("expand uuid_getvar $${aleg} effective_caller_id_name") or 0;
local effective_caller_id_number = freeswitch.API():executeString("expand uuid_getvar $${aleg} effective_caller_id_number") or 0;

os.execute("curl -G 'https://script.google.com/macros/s/AKfycbwlJv9fMuA6lnKkUqXtzu2b3h6lQfXZKblACboE13gA3zrB2SZu/exec?'" ..

" --data-urlencode " .. "'" .. "uuid=" .. uuid .. "'" ..

" --data-urlencode " .. "'" .. "caller_id_name=" .. caller_id_name .. "'" ..
" --data-urlencode " .. "'" .. "caller_id_number=" .. caller_id_number .. "'" ..
" --data-urlencode " .. "'" .. "orig_caller_id_name=" .. orig_caller_id_name .. "'" ..
" --data-urlencode " .. "'" .. "orig_caller_id_number=" .. orig_caller_id_number .. "'" ..
" --data-urlencode " .. "'" .. "callee_id_name=" .. callee_id_name .. "'" ..
" --data-urlencode " .. "'" .. "callee_id_number=" .. callee_id_number .. "'" ..
" --data-urlencode " .. "'" .. "outbound_caller_id_name=" .. outbound_caller_id_name .. "'" ..
" --data-urlencode " .. "'" .. "outbound_caller_id_number=" .. outbound_caller_id_number .. "'" ..
" --data-urlencode " .. "'" .. "original_caller_id_name=" .. original_caller_id_name .. "'" ..
" --data-urlencode " .. "'" .. "original_caller_id_number=" .. original_caller_id_number .. "'" ..
" --data-urlencode " .. "'" .. "last_sent_callee_id_name=" .. last_sent_callee_id_name .. "'" ..
" --data-urlencode " .. "'" .. "last_sent_callee_id_number=" .. last_sent_callee_id_number .. "'" ..
" --data-urlencode " .. "'" .. "pre_transfer_caller_id_name=" .. pre_transfer_caller_id_name .. "'" ..
" --data-urlencode " .. "'" .. "pre_transfer_caller_id_number=" .. pre_transfer_caller_id_number .. "'" ..
" --data-urlencode " .. "'" .. "conference_auto_outcall_caller_id_name=" .. conference_auto_outcall_caller_id_name .. "'" ..
" --data-urlencode " .. "'" .. "conference_auto_outcall_caller_id_number=" .. conference_auto_outcall_caller_id_number .. "'" ..
" --data-urlencode " .. "'" .. "origination_caller_id_name=" .. origination_caller_id_name .. "'" ..
" --data-urlencode " .. "'" .. "origination_caller_id_number=" .. origination_caller_id_number .. "'" ..
" --data-urlencode " .. "'" .. "voicemail_caller_id_name=" .. voicemail_caller_id_name .. "'" ..
" --data-urlencode " .. "'" .. "voicemail_formatted_caller_id_number=" .. voicemail_formatted_caller_id_number .. "'" ..
" --data-urlencode " .. "'" .. "voicemail_caller_id_number=" .. voicemail_caller_id_number .. "'" ..
" --data-urlencode " .. "'" .. "verto_remote_caller_id_name=" .. verto_remote_caller_id_name .. "'" ..
" --data-urlencode " .. "'" .. "verto_remote_caller_id_number=" .. verto_remote_caller_id_number .. "'" ..
" --data-urlencode " .. "'" .. "remote_caller_id_name=" .. remote_caller_id_name .. "'" ..
" --data-urlencode " .. "'" .. "remote_caller_id_number=" .. remote_caller_id_number .. "'" ..
" --data-urlencode " .. "'" .. "effective_caller_id_name=" .. effective_caller_id_name .. "'" ..
" --data-urlencode " .. "'" .. "effective_caller_id_number=" .. effective_caller_id_number .. "'" ..
"");

freeswitch.consoleLog("info", "caller_id_name=" .. caller_id_name);
freeswitch.consoleLog("info", "caller_id_number=" .. caller_id_number);
freeswitch.consoleLog("info", "orig_caller_id_name=" .. orig_caller_id_name);
freeswitch.consoleLog("info", "orig_caller_id_number=" .. orig_caller_id_number);
freeswitch.consoleLog("info", "callee_id_name=" .. callee_id_name);
freeswitch.consoleLog("info", "callee_id_number=" .. callee_id_number);
freeswitch.consoleLog("info", "outbound_caller_id_name=" .. outbound_caller_id_name);
freeswitch.consoleLog("info", "outbound_caller_id_number=" .. outbound_caller_id_number);
freeswitch.consoleLog("info", "original_caller_id_name=" .. original_caller_id_name);
freeswitch.consoleLog("info", "original_caller_id_number=" .. original_caller_id_number);
freeswitch.consoleLog("info", "last_sent_callee_id_name=" .. last_sent_callee_id_name);
freeswitch.consoleLog("info", "last_sent_callee_id_number=" .. last_sent_callee_id_number);
freeswitch.consoleLog("info", "pre_transfer_caller_id_name=" .. pre_transfer_caller_id_name);
freeswitch.consoleLog("info", "pre_transfer_caller_id_number=" .. pre_transfer_caller_id_number);
freeswitch.consoleLog("info", "conference_auto_outcall_caller_id_name=" .. conference_auto_outcall_caller_id_name);
freeswitch.consoleLog("info", "conference_auto_outcall_caller_id_number=" .. conference_auto_outcall_caller_id_number);
freeswitch.consoleLog("info", "origination_caller_id_name=" .. origination_caller_id_name);
freeswitch.consoleLog("info", "origination_caller_id_number=" .. origination_caller_id_number);
freeswitch.consoleLog("info", "voicemail_caller_id_name=" .. voicemail_caller_id_name);
freeswitch.consoleLog("info", "voicemail_formatted_caller_id_number=" .. voicemail_formatted_caller_id_number);
freeswitch.consoleLog("info", "voicemail_caller_id_number=" .. voicemail_caller_id_number);
freeswitch.consoleLog("info", "verto_remote_caller_id_name=" .. verto_remote_caller_id_name);
freeswitch.consoleLog("info", "verto_remote_caller_id_number=" .. verto_remote_caller_id_number);
freeswitch.consoleLog("info", "remote_caller_id_name=" .. remote_caller_id_name);
freeswitch.consoleLog("info", "remote_caller_id_number=" .. remote_caller_id_number);
freeswitch.consoleLog("info", "effective_caller_id_name=" .. effective_caller_id_name);
freeswitch.consoleLog("info", "effective_caller_id_number=" .. effective_caller_id_number);

freeswitch.consoleLog("info", "\n\nend acid.lua\n\n\n\n\n\n\n\n");
