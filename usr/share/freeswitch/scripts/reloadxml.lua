if argv[1] == "rxml" then
   freeswitch.console_log("info", "\n\n\n\nthis is a special reloadxml message\n\n\n\n");
elseif argv[1] == "vlogin" then
   freeswitch.console_log("info", "\n\n\n\nsomebody logged into Verto Communicator\n\n\n\n");
elseif argv[1] == "avmd" then
   freeswitch.console_log("info", "\n\n\n\nAVMD event found\n\n\n\n");
end
