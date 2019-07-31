#
# MULTI-WINDOW EMACS ALIASES
#

alias ncready='netcat_ready'
netcat_ready () {
    screen -X layout select F3
    sleep 1
    screen -X focus top
    sleep 1
    screen -X select 4
    sleep 1
    screen -X stuff "ncext"^M
    sleep 1
    screen -X focus right
    sleep 1
    screen -X select 5
    sleep 1
    screen -X stuff "ncfs"^M
    sleep 1
    screen -X focus bottom
    sleep 1
    screen -X select 1
    sleep 1
    screen -X stuff "originate user/1000 8026"^M
    sleep 1
    screen -X focus top
    screen -X focus right
    sleep 1
    screen -X stuff "connect"^M^M

}

alias undofscert='if [ -f /etc/freeswitch/tls/wss.pem.orig ]; then \
cd /etc/freeswitch/tls \
&& rm -f self.crt self.key wss.pem \
&& mv wss.pem.orig wss.pem \
&& systemctl restart freeswitch; else printf "wss.pem.orig file not found.\n"; fi'

alias fscert='fs_self_cert'
fs_self_cert () {
    cd /etc/freeswitch/tls
    openssl req -x509 -newkey rsa:4096 -keyout self.key -out self.crt -nodes -days 365 -sha256 \
	    -subj "/C=US/ST=freeswitch/L=freeswitch/O=freeswitch/OU=freeswitch/CN=freeswitch"
    mv -f /etc/freeswitch/tls/wss.pem /etc/freeswitch/tls/wss.pem.orig
    cat /etc/freeswitch/tls/self.key > /etc/freeswitch/tls/wss.pem
    cat /etc/freeswitch/tls/self.crt >> /etc/freeswitch/tls/wss.pem
    systemctl restart freeswitch
}

fsbt () {
    if [ $1 ]; then # for when freeswitch crashed
	gdb -ex "set logging file /tmp/backtrace.log" \
	    -ex "set logging on" \
	    -ex "set pagination off" \
	    -ex "thread apply all bt" \
	    -ex "thread apply all bt full" \
	    -ex "info threads" \
	    -ex "detach" \
	    -ex "quit" \
	    /usr/bin/freeswitch /tmp/core.$1 \
	    && printf "\n\n\n" \
	    && curl -d private=1 --data-urlencode text@/tmp/backtrace.log https://pastebin.freeswitch.org/api/create \
	    && printf "\n\n\n" \
	    && rm /tmp/core.$1
    else # for when freeswitch freezes/hangs
	gdb -ex "attach $(pidof -s freeswitch)" \
	    -ex "set logging file /tmp/backtrace.log" \
	    -ex "set logging on" \
	    -ex "set pagination off" \
	    -ex "thread apply all bt" \
	    -ex "thread apply all bt full" \
	    -ex "info threads" \
	    -ex "detach" \
	    -ex "quit" \
	    && printf "\n\n\n" \
	    && curl -d private=1 --data-urlencode text@/tmp/backtrace.log https://pastebin.freeswitch.org/api/create \
	    && printf "\n\n\n"
    fi
}

alias fscrash='FSPID=$(pidof -s freeswitch) && echo $FSPID > /tmp/fsa.pid && fs_cli -x "fsctl crash" && fsbt $FSPID'

alias btready='cd /tmp && ulimit -c unlimited && sysctl -w kernel.core_pattern=/tmp/core.%p && apt-get install -y gdb curl libfreeswitch1-dbg freeswitch-all-dbg'

alias gitready='rm -f /etc/freeswitch/.git; cd /etc/freeswitch && git init && git add --all && git commit -am "initial commit" && git log'

alias fslogpaste='bugon && callpaste && bugoff'

alias mslog='make_slog'
make_slog () {
    screen -X layout select F2
    sleep 1
    screen -X focus top
    sleep 1
    screen -X stuff 'git clean -fdx && /usr/src/freeswitch.git/bootstrap.sh && /usr/src/freeswitch.git/configure -C --prefix=/usr --localstatedir=/var --sysconfdir=/etc  --enable-core-psql-support --enable-core-odbc-support --enable-zrtp && make mod_logfile-install && fs_cli -x "reload mod_logfile" && fs_cli -x "fsctl send_sighup"'^M
}

alias kslog='kill_slog'
kill_slog () {
    screen -X layout select F2
    sleep 1
    screen -X focus top
    sleep 1
    screen -X stuff ^X^C
    sleep 1
    screen -X stuff "clear"^M
    sleep 1
    screen -X select 2
    sleep 1
    screen -X focus bottom
    sleep 1
    screen -X select 1
    sleep 1
    screen -X stuff ^C
    sleep 1
    screen -X stuff "clear"^M
    sleep 1
    screen -X layout select F1
    sleep 1
    screen -X select 0
    sleep 1
    screen -X stuff "clear"^M
}

alias slog='source_logfile'
source_logfile () {
    screen -X layout select F2
    sleep 1
    screen -X focus top
    sleep 1
    screen -X select 4
    sleep 1
    screen -X stuff "cd /usr/src/freeswitch.git"^M
    sleep 1
    screen -X stuff "emacs +192 /usr/src/freeswitch.git/src/mod/loggers/mod_logfile/mod_logfile.c"^M
    sleep 1
    screen -X focus bottom
    sleep 1
    screen -X select 1
}

alias rlogtarg='rotate_logtarg'
rotate_logtarg () {
    if [ -f /var/log/freeswitch/freeswitch.log.1 ]; then
	rm -f /var/log/freeswitch/freeswitch.log
	rm -f /var/log/freeswitch/freeswitch.log.{1,2,3}
	rm -f /var/log/freeswitch/reload-mods.log
	rm -f /var/log/freeswitch/reload-mods.log.{1,2,3}
	fs_cli -x "reload mod_logfile"
    fi
    screen -X layout select F3
    sleep 1
    screen -X focus top
    screen -X focus right
    screen -X select 5
    sleep 1
    screen -X stuff "cd /var/log/freeswitch; ls -l"^M
    screen -X focus bottom
    sleep 1
    screen -X stuff "fsctl send_sighup"^M
    sleep 1
    screen -X focus top
    screen -X focus right
    sleep 1
    screen -X stuff "ls -l"^M
    screen -X focus bottom
    sleep 1
    screen -X stuff "fsctl send_sighup"^M
    sleep 1
    screen -X focus top
    screen -X focus right
    sleep 1
    screen -X stuff "ls -l"^M
    sleep 1
    screen -X focus bottom
    sleep 1
    screen -X stuff "fsctl send_sighup"^M
    sleep 1
    screen -X focus top
    screen -X focus right
    sleep 1
    screen -X stuff "ls -l"^M
}

alias klogtarg='kill_logtarg'
kill_logtarg () {
    screen -X layout select F3
    sleep 1
    screen -X focus top
    sleep 1
    screen -X stuff ^X^C
    sleep 1
    screen -X stuff "clear"^M
    sleep 1
    screen -X focus right
    sleep 1
    screen -X stuff "clear"^M
    sleep 1
    screen -X focus bottom
    sleep 1
    #screen -X select 3
    #sleep 1
    #screen -X stuff ^C"clear"^M
    #sleep 1
    screen -X layout select F1
    sleep 1
    screen -X select 0
    screen -X stuff "clear"^M
}

alias logtarg='logfile_target'
logfile_target () {
    screen -X layout select F3
    sleep 1
    screen -X focus top
    sleep 1
    screen -X select 4
    sleep 1
    screen -X stuff 'emacs /etc/freeswitch/autoload_configs/logfile.conf.xml --eval "(search-forward \\"reload-mods\\")" --eval "(recenter-top-bottom)"  --eval "(recenter-top-bottom)"'^M
    sleep 1
    screen -X focus right
    sleep 1
    screen -X select 5
    sleep 1
    if [ -f /var/log/freeswitch/freeswitch.log.1 ]; then
	rm -f /var/log/freeswitch/freeswitch.log
	rm -f /var/log/freeswitch/freeswitch.log.{1,2,3}
	rm -f /var/log/freeswitch/reload-mods.log
	rm -f /var/log/freeswitch/reload-mods.log.{1,2,3}
	fs_cli -x "reload mod_logfile"
    fi
    screen -X stuff "cd /var/log/freeswitch; ls"^M
    sleep 1
    screen -X focus bottom
    sleep 1
    screen -X select 1
}

alias rlogger='rotate_logger'
rotate_logger () {
    if [ -f /var/log/freeswitch/freeswitch.log.1 ]; then
	rm -f /var/log/freeswitch/freeswitch.log
	rm -f /var/log/freeswitch/freeswitch.log.{1,2,3}
	rm -f /var/log/freeswitch/reload-mods.log
	rm -f /var/log/freeswitch/reload-mods.log.{1,2,3}
	fs_cli -x "reload mod_logfile"
    fi
    screen -X layout select F3
    sleep 1
    screen -X focus top
    screen -X focus right
    screen -X select 5
    sleep 1
    screen -X stuff "cd /var/log/freeswitch; ls -l"^M
    screen -X focus bottom
    sleep 1
    screen -X stuff "fsctl send_sighup"^M
    sleep 1
    screen -X focus top
    screen -X focus right
    sleep 1
    screen -X stuff "ls -l"^M
    screen -X focus bottom
    sleep 1
    screen -X stuff "fsctl send_sighup"^M
    sleep 1
    screen -X focus top
    screen -X focus right
    sleep 1
    screen -X stuff "ls -l"^M
    sleep 1
    screen -X focus bottom
    sleep 1
    screen -X stuff "fsctl send_sighup"^M
    sleep 1
    screen -X focus top
    screen -X focus right
    sleep 1
    screen -X stuff "ls -l"^M
}

alias klogger='kill_logger'
kill_logger () {
    screen -X layout select F3
    sleep 1
    screen -X focus top
    sleep 1
    screen -X focus right
    sleep 1
    screen -X select 5
    sleep 1
    screen -X stuff "clear"^M
    sleep 1
    screen -X focus bottom
    sleep 1
    screen -X select 3
    sleep 1
    screen -X stuff "clear"^M
    sleep 1
    screen -X layout select F1
    sleep 1
    screen -X select 4
    sleep 1
    screen -X stuff ^X^C
    sleep 1
    screen -X stuff "clear"^M
    sleep 1
    screen -X select 0
    clear
}

alias logger='logfile_profiles'
logfile_profiles () {
    screen -X layout select F3
    sleep 1
    screen -X focus top
    sleep 1
    screen -X select 4
    sleep 1
    screen -X stuff "logfile.conf.xml"^M
    sleep 1
    screen -X focus right
    sleep 1
    screen -X select 5
    sleep 1
    if [ -f /var/log/freeswitch/freeswitch.log.1 ]; then
	rm -f /var/log/freeswitch/freeswitch.log
	rm -f /var/log/freeswitch/freeswitch.log.{1,2,3}
	rm -f /var/log/freeswitch/reload-mods.log
	rm -f /var/log/freeswitch/reload-mods.log.{1,2,3}
	fs_cli -x "reload mod_logfile"
    fi
    screen -X stuff "cd /var/log/freeswitch; ls"^M
    sleep 1
    screen -X focus bottom
    sleep 1
    screen -X select 1
}

alias kcontarg='kill_contarg'
kill_contarg () {
    screen -X select 1
    screen -X stuff "..."^M
    sleep 1
    screen -X select 0
    while [[ $(fs_cli -x "module_exists mod_event_socket") == "true" ]]; do
	printf "Line: $LINENO - kcontarg - waiting on FS foreground to shutdown...\n"
	sleep 1
    done
    while [[ ! $(fs_cli -x "module_exists mod_event_socket") == "true" ]]; do
	printf "Line: $LINENO - 002 - waiting on FS background to startup...\n"
	sleep 1
    done
    screen -X quit
}

alias contarg='console_target'
console_target () {
    if [ ! -S /tmp/emacs0/server ]; then
	emacs --daemon
	wait
	printf "starting emacs daemon...\n"
	screen -X layout select F3
	sleep 2
	screen -X focus top
	sleep 2
	screen -X select 4
	sleep 2
	screen -X stuff "emacsclient -t /etc/freeswitch/autoload_configs/console.conf.xml"^M
	sleep 2
	emacsclient -e "(auto-dim-other-buffers-mode 0)"
	sleep 2
	screen -X focus right
	sleep 2
	screen -X select 5
	sleep 2
	screen -X stuff "emacsclient -t /usr/src/freeswitch.git/src/mod/applications/mod_avmd/mod_avmd.c"^M
	sleep 2
	emacsclient -e "(auto-dim-other-buffers-mode 0)"
	sleep 2
	screen -X focus bottom
	sleep 2
	screen -X select 1
	sleep 2
	screen -X stuff "..."^M
	sleep 2
	FSPID="$(pidof freeswitch)"
	screen -X stuff "fsf"^M
	sleep 2
	screen -X focus top
	sleep 2
	screen -X layout select F1
	sleep 2
	screen -X select 0
	sleep 2
	FSPID_CHECK="$(pidof freeswitch)"
	if [[ "$FSPID" == "$FSPID_CHECK" ]]; then
	    while [[ $(fs_cli -x "module_exists mod_event_socket") == "true" ]]; do
		printf "Line: $LINENO - 001 - waiting on FS background to shutdown...\n"
		sleep 1
	    done
	    while [[ $(fs_cli -x "module_exists mod_event_socket") == "false" ]]; do
		printf "Line: $LINENO - 002 - waiting on FS foreground to startup...\n"
		sleep 1
	    done
	else
	    while [[ $(fs_cli -x "module_exists mod_event_socket") == "false" ]]; do
		printf "Line: $LINENO - 003 - waiting on FS foreground to startup...\n"
		sleep 1
	    done
	fi
	sleep 2
	screen -X layout select F2
	sleep 2
	screen -X focus bottom
	sleep 2
	screen -X select 1
	sleep 2
	screen -X focus top
	sleep 2
	screen -X select 2
	sleep 2
	screen -X stuff "..."^M
	sleep 2
	screen -X stuff 'until [[ $(fs_cli -x "module_exists mod_event_socket") == "true" ]]; do printf "Line: $LINENO - 004 - waiting on FS foreground to startup...\n"; sleep 1; done; fsa'^M^M^M
	screen -X focus bottom
	sleep 2
	screen -X stuff ^M^M^M
	sleep 2
	screen -X layout select F1
	sleep 2
	screen -X select 0
	printf "\n\n\nhopefully everything is ready and working\n"
	printf "\n ${yellow}hit${stop} ${green}F3${stop} ${yellow}to continue with instructor and google slide${stop}\n\n"
    else
	screen -X layout select F1
	sleep 2
	screen -X select 1
	sleep 2
	FSPID="$(pidof freeswitch)"
	screen -X stuff "..."^M
	sleep 2
	screen -X select 0
	sleep 2
	stopfsa
	while [[ $(fs_cli -x "module_exists mod_event_socket") == "true" ]]; do
	    printf "Line: $LINENO - 005 - waiting on FS foreground to shutdown...\n"
	    sleep 1
	    FSPID_CHECK="$(pidof freeswitch)"
	    if [[ $FSPID == $FSPID_CHECK ]]; then
		kill $(pidof freeswitch)
		kill $(pidof freeswitch)
		kill $(pidof freeswitch)
	    fi
	done
	killemacs && sleep 1 && console_target
    fi
}

alias fkeys='emacs \
--eval "(find-file \"/root/.fs_cli_conf\")" --eval "(search-forward \"custom\")" \
-f recenter-top-bottom -f recenter-top-bottom \
-f split-window-horizontally \
-f other-window \
--eval "(find-file \"/etc/freeswitch/autoload_configs/switch.conf.xml\")" \
-f other-window \
'

alias logsets='emacs \
-f split-window-horizontally \
--eval "(find-file \"/root/.fs_cli_conf\")" --eval "(search-forward \"log\")" \
-f split-window-vertically \
-f other-window \
--eval "(find-file \"/etc/freeswitch/autoload_configs/switch.conf.xml\")" --eval "(search-forward \"loglevel\" nil nil 3)" \
-f split-window-vertically \
-f other-window \
--eval "(find-file \"/etc/freeswitch/autoload_configs/console.conf.xml\")" --eval "(search-forward \"logleve\")" \
-f split-window-vertically \
-f other-window \
--eval "(find-file \"/etc/freeswitch/autoload_configs/logfile.conf.xml\")" --eval "(search-forward \"map name\")" \
-f other-window \
-f balance-windows \
--eval "(find-file \"/etc/freeswitch/autoload_configs/sofia.conf.xml\")" --eval "(search-forward \"log\")" \
-f split-window-vertically \
-f other-window \
--eval "(find-file \"/etc/freeswitch/autoload_configs/verto.conf.xml\")" --eval "(search-forward \"debug\")" \
-f split-window-vertically \
-f other-window \
--eval "(find-file \"/etc/freeswitch/sip_profiles/internal.xml\")" --eval "(search-forward \"sip-trace\")" \
-f split-window-vertically \
-f other-window \
--eval "(find-file \"/etc/freeswitch/sip_profiles/external.xml\")" --eval "(search-forward \"sip-trace\")" \
-f balance-windows \
-f other-window \
'

alias mavmd='emacs \
--eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"mod_avmd\")" \
-f split-window-vertically \
-f other-window \
--eval "(find-file \"/etc/freeswitch/autoload_configs/avmd.conf.xml\")" \
-f split-window-vertically \
-f other-window \
-f split-window-horizontally \
--eval "(find-file \"/etc/freeswitch/autoload_configs/lua.conf.xml\")" --eval "(search-forward \"avmd::\")" \
-f other-window \
--eval "(find-file \"/usr/share/freeswitch/scripts/avmd.lua\")" \
-f other-window \
'

alias nibble='emacs \
--eval "(find-file \"/etc/freeswitch/autoload_configs/nibblebill.conf.xml\")" \
-f split-window-vertically \
-f shrink-window-if-larger-than-buffer \
-f other-window \
--eval "(find-file \"/etc/freeswitch/directory/default/1000.xml\")" \
-f split-window-horizontally \
-f other-window \
--eval "(find-file \"/etc/freeswitch/directory/default/1001.xml\")" \
-f other-window \
'

alias fifo='emacs \
--eval "(find-file \"/etc/freeswitch/autoload_configs/fifo.conf.xml\")" \
-f split-window-vertically \
-f shrink-window-if-larger-than-buffer \
-f other-window \
--eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"fifo agent\")" \
-f other-window \
'

alias confer='emacs \
-f split-window-vertically \
-f split-window-horizontally \
--eval "(shrink-window 15)" \
--eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"video_mcu_stereo_conference\")" \
-f other-window \
--eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"conf mod\")" \
-f other-window \
-f split-window-horizontally \
--eval "(find-file \"/etc/freeswitch/autoload_configs/conference.conf.xml\")" --eval "(search-forward \"caller-controls\")" \
-f split-window-vertically \
-f other-window \
--eval "(search-forward \"video-mcu-stereo\")" \
-f other-window \
-f split-window-vertically \
--eval "(find-file \"/etc/freeswitch/autoload_configs/conference_layouts.conf.xml\")" --eval "(search-forward \"3x3\")" \
-f other-window \
--eval "(find-file \"/etc/freeswitch/autoload_configs/conference_layouts.conf.xml\")" --eval "(search-forward \"group\")" \
-f other-window \
'

alias phrases='emacs \
-f split-window-vertically \
-f split-window-horizontally \
-f other-window \
-f other-window \
-f split-window-horizontally \
-f other-window \
-f other-window \
--eval "(find-file \"/etc/freeswitch/freeswitch.xml\")" --eval "(search-forward \"languages\")" \
-f other-window \
--eval "(find-file \"/etc/freeswitch/lang/en/en.xml\")" \
-f other-window \
--eval "(find-file \"/etc/freeswitch/lang/en/demo/demo-ivr.xml\")" \
-f other-window \
--eval "(find-file \"/etc/freeswitch/ivr_menus/demo_ivr.xml\")" \
'

alias demoivr='emacs \
--eval "(find-file \"/etc/freeswitch/autoload_configs/ivr.conf.xml\")" \
-f split-window-horizontally \
-f split-window-vertically \
-f other-window \
--eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"ivr_demo\")" \
-f split-window-vertically \
-f other-window \
--eval "(search-backward \"operator\")" \
-f split-window-vertically \
-f balance-windows \
-f other-window \
--eval "(find-file \"/etc/freeswitch/dialplan/features.xml\")" --eval "(search-forward \"please_hold\")" \
-f split-window-vertically \
-f balance-windows \
-f other-window \
--eval "(switch-to-buffer \"default.xml\")" \
--eval "(search-backward \"Local_Extension\")" \
--eval "(search-backward \"Local_Extension\")" \
--eval "(search-backward \"Local_Extension\")" \
-f other-window \
--eval "(find-file \"/etc/freeswitch/ivr_menus/demo_ivr.xml\")" \
'

alias flowroute='emacs \
--eval "(find-file \"/etc/freeswitch/sip_profiles/external/gateways.xml\")" --eval "(search-forward \"flowroute\")" \
-f recenter-top-bottom -f recenter-top-bottom \
-f split-window-vertically \
-f other-window \
--eval "(find-file \"/etc/freeswitch/dialplan/public.xml\")" --eval "(search-forward \"flowroute\")" \
-f split-window-horizontally \
-f other-window \
--eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"flowroute\")" \
-f other-window \
'

alias bothdid='emacs --eval "(find-file \"/etc/freeswitch/dialplan/public.xml\")" --eval "(search-forward \"public_did\")" \
-f split-window-vertically \
-f other-window \
-f recenter \
--eval "(find-file \"/usr/local/freeswitch/conf/dialplan/public.xml\")" --eval "(search-forward \"public_did\")" \
-f recenter \
-f other-window \
'

alias bindmeta='emacs \
--eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"dx XML features\")" \
-f split-window-vertically \
-f other-window \
--eval "(find-file \"/etc/freeswitch/dialplan/features.xml\")" --eval "(search-forward \"dx\")" \
-f other-window \
'

alias contexts='emacs \
--eval "(find-file \"/etc/freeswitch/sip_profiles/internal.xml\")" --eval "(search-forward \"context\")" \
-f split-window-vertically \
-f split-window-horizontally \
-f other-window \
--eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"context\")" \
-f other-window \
--eval "(find-file \"/etc/freeswitch/sip_profiles/external.xml\")" --eval "(search-forward \"public\")" \
-f split-window-horizontally \
-f other-window \
--eval "(find-file \"/etc/freeswitch/dialplan/public.xml\")" --eval "(search-forward \"public\")" \
-f other-window \
'

alias localextinfo='emacs \
--eval "(find-file \"/etc/freeswitch/dialplan/dial411.xml\")" \
-f split-window-vertically \
-f other-window \
--eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"Local_Extension\")" \
'

alias inlinetrue='emacs \
--eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"tod_example\")" \
-f split-window-vertically \
-f other-window \
--eval "(search-forward \"Local_Extension\")" \
-f other-window \
'

alias dialplans='emacs \
--eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" \
-f split-window-vertically \
-f other-window \
--eval "(find-file \"/usr/local/freeswitch/conf/dialplan/default.xml\")" \
-f other-window \
'

alias dial411='emacs \
--eval "(find-file \"/etc/freeswitch/dialplan/dial411.xml\")" \
-f split-window-vertically \
-f other-window \
--eval "(find-file \"/etc/freeswitch/directory/default/1000.xml\")" --eval "(search-forward \"user_context\")" \
-f other-window \
'

alias ugroups='emacs \
--eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"group_dial_sales\")" \
-f split-window-vertically \
-f split-window-horizontally \
-f other-window \
--eval "(find-file \"/etc/freeswitch/directory/default.xml\")" --eval "(search-forward \"sales\")" \
-f other-window \
--eval "(find-file \"/etc/freeswitch/directory/default/1000.xml\")" --eval "(search-forward \"callgroup\")" \
-f split-window-horizontally \
-f other-window \
--eval "(find-file \"/etc/freeswitch/directory/default/1001.xml\")" --eval "(search-forward \"callgroup\")" \
-f other-window \
'

alias overvar='emacs \
-f split-window-vertically \
--eval "(find-file \"/etc/freeswitch/directory/default.xml\")" \
--eval "(search-forward \"variables\")" \
-f other-window \
-f split-window-horizontally \
--eval "(find-file \"/etc/freeswitch/directory/default/1000.xml\")" \
-f other-window \
--eval "(find-file \"/etc/freeswitch/directory/default/1001.xml\")" \
-f other-window \
'

alias fspasswords='emacs \
--eval "(find-file \"/etc/freeswitch/vars.xml\")" --eval "(search-forward \"default_password=\")" \
-f split-window-vertically \
-f other-window \
--eval "(find-file \"/usr/local/freeswitch/conf/vars.xml\")" --eval "(search-forward \"default_password=\")" \
-f split-window-vertically \
-f other-window \
--eval "(find-file \"/var/www/html/vc/config.json\")" \
-f other-window \
-f balance-windows \
'

alias fsa2fsb='emacs \
--eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"fsa_2_fsb\")" \
-f split-window-vertically \
-f other-window \
--eval "(find-file \"/usr/local/freeswitch/conf/dialplan/default.xml\")" --eval "(search-forward \"fsb_2_fsa\")" \
-f other-window \
'

alias breakers='emacs --eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"breakers\")"'
alias capgroups='emacs --eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"capture_group_test\")"'
alias confother='emacs --eval "(find-file \"/etc/freeswitch/autoload_configs/conference_layouts.conf.xml\")" --eval "(search-forward \"presenter-dual-horizontal\")"'
alias connectors='emacs --eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"SignalWire Connectors\")"'
alias dpchan='emacs --eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"dp_chan_var_test\")"'
alias enterprise='emacs --eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"enterprise_bridge\")"'
alias extglob='emacs --eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"call_debug\")" '
alias extdrop='emacs --eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"eavesdrop\")" '
alias extoper='emacs --eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"operator\")" '
alias extvm='emacs --eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"vmain\")" '
alias extpark='emacs --eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"park\")" '
alias fs2fs='emacs --eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"fs_2_fs\")" '
alias localext='emacs --eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"Local_Extension\")"'
alias localextb='emacs --eval "(find-file \"/usr/local/freeswitch/conf/dialplan/default.xml\")" --eval "(search-forward \"Local_Extension\")"'
alias internalport='emacs --eval "(find-file \"/etc/freeswitch/sip_profiles/internal.xml\")" --eval "(search-forward \"sip-port\")"'
alias internalportb='emacs --eval "(find-file \"/usr/local/freeswitch/conf/sip_profiles/internal.xml\")" --eval "(search-forward \"sip-port\")"'
alias logext='emacs --eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"log|564\")"'
alias ncfs='nc -k -v -l 127.0.0.1 -p 8026'
alias ncext='emacs --eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"netcat\")"'
alias nestcon='emacs --eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"nested_example\")" \
      -f recenter-top-bottom -f recenter-top-bottom'
alias nibbleadd='sqlite3 /var/lib/freeswitch/db/nibblebill.db "update accounts set cash = cash + 5 where name = 1000;" "update accounts set cash = cash + 2 where name = 1001;" ".exit"'
alias nibblebal='sqlite3 /var/lib/freeswitch/db/nibblebill.db "select * from accounts;" ".exit"'
alias pubdid='emacs --eval "(find-file \"/etc/freeswitch/dialplan/public.xml\")" --eval "(search-forward \"public_did\")" -f recenter'
alias pubdidb='emacs --eval "(find-file \"/usr/local/freeswitch/conf/dialplan/public.xml\")" --eval "(search-forward \"public_did\")" -f recenter'
alias shareext='emacs --eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"?-screen\")"'
alias throwfail='emacs --eval "(find-file \"/etc/freeswitch/dialplan/default.xml\")" --eval "(search-forward \"throw fail\")" \
      -f recenter-top-bottom -f recenter-top-bottom'


#
# PSUEDO FILENAME ALIASES
#

alias dialplan='dialplan.xml'
alias directory='directory.xml'
alias gateways='gateways.xml'
alias phrase='demo-ivr.xml'
alias fsuser='user.xml'
alias vars='vars.xml'



#
# VERBAITM FILNAME ALIASES
#

alias abstraction.conf.xml='emacs /etc/freeswitch/autoload_configs/abstraction.conf.xml'
alias acl.conf.xml='emacs /etc/freeswitch/autoload_configs/acl.conf.xml'
alias alsa.conf.xml='emacs /etc/freeswitch/autoload_configs/alsa.conf.xml'
alias amd.conf.xml='emacs /etc/freeswitch/autoload_configs/amd.conf.xml'
alias amqp.conf.xml='emacs /etc/freeswitch/autoload_configs/amqp.conf.xml'
alias amr.conf.xml='emacs /etc/freeswitch/autoload_configs/amr.conf.xml'
alias amrwb.conf.xml='emacs /etc/freeswitch/autoload_configs/amrwb.conf.xml'
alias avmd.conf.xml='emacs /etc/freeswitch/autoload_configs/avmd.conf.xml'
alias av.conf.xml='emacs /etc/freeswitch/autoload_configs/av.conf.xml'
alias blacklist.conf.xml='emacs /etc/freeswitch/autoload_configs/blacklist.conf.xml'
alias callcenter.conf.xml='emacs /etc/freeswitch/autoload_configs/callcenter.conf.xml'
alias cdr_csv.conf.xml='emacs /etc/freeswitch/autoload_configs/cdr_csv.conf.xml'
alias cdr_mongodb.conf.xml='emacs /etc/freeswitch/autoload_configs/cdr_mongodb.conf.xml'
alias cdr_pg_csv.conf.xml='emacs /etc/freeswitch/autoload_configs/cdr_pg_csv.conf.xml'
alias cdr_sqlite.conf.xml='emacs /etc/freeswitch/autoload_configs/cdr_sqlite.conf.xml'
alias cepstral.conf.xml='emacs /etc/freeswitch/autoload_configs/cepstral.conf.xml'
alias chatplan.conf.xml='emacs /etc/freeswitch/chatplan/default.xml'
alias cidlookup.conf.xml='emacs /etc/freeswitch/autoload_configs/cidlookup.conf.xml'
alias conference.conf.xml='emacs /etc/freeswitch/autoload_configs/conference.conf.xml'
alias conference_layouts.conf.xml='emacs /etc/freeswitch/autoload_configs/conference_layouts.conf.xml'
alias config.json='emacs /var/www/html/vc/config.json'
alias console.conf.xml='emacs /etc/freeswitch/autoload_configs/console.conf.xml'
alias db.conf.xml='emacs /etc/freeswitch/autoload_configs/db.conf.xml'
alias demo-ivr.xml='emacs /etc/freeswitch/lang/en/demo/demo-ivr.xml'
alias dialplan.xml='emacs /etc/freeswitch/dialplan/default.xml'
alias dialplan_directory.conf.xml='emacs /etc/freeswitch/autoload_configs/dialplan_directory.conf.xml'
alias dingaling.conf.xml='emacs /etc/freeswitch/autoload_configs/dingaling.conf.xml'
alias directory.xml='emacs /etc/freeswitch/directory/default.xml'
alias directory.conf.xml='emacs /etc/freeswitch/autoload_configs/directory.conf.xml'
alias distributor.conf.xml='emacs /etc/freeswitch/autoload_configs/distributor.conf.xml'
alias easyroute.conf.xml='emacs /etc/freeswitch/autoload_configs/easyroute.conf.xml'
alias enum.conf.xml='emacs /etc/freeswitch/autoload_configs/enum.conf.xml'
alias en.xml='emacs /etc/freeswitch/lang/en/en.xml'
alias erlang_event.conf.xml='emacs /etc/freeswitch/autoload_configs/erlang_event.conf.xml'
alias event_multicast.conf.xml='emacs /etc/freeswitch/autoload_configs/event_multicast.conf.xml'
alias event_socket.conf.xml='emacs /etc/freeswitch/autoload_configs/event_socket.conf.xml'
alias external.xml='emacs /etc/freeswitch/sip_profiles/external.xml'
alias external-ipv6.xml='emacs /etc/freeswitch/sip_profiles/external-ipv6.xml'
alias fail2ban.conf.xml='emacs /etc/freeswitch/autoload_configs/fail2ban.conf.xml'
alias fax.conf.xml='emacs /etc/freeswitch/autoload_configs/fax.conf.xml'
alias features.xml='emacs /etc/freeswitch/dialplan/features.xml'
alias fifo.conf.xml='emacs /etc/freeswitch/autoload_configs/fifo.conf.xml'
alias format_cdr.conf.xml='emacs /etc/freeswitch/autoload_configs/format_cdr.conf.xml'
alias freeswitch.xml='emacs /etc/freeswitch/freeswitch.xml'
alias gateways.xml='emacs /etc/freeswitch/sip_profiles/external/gateways.xml'
alias gcloud.conf.xml='emacs /etc/freeswitch/autoload_configs/glcoud.conf.xml'
alias graylog2.conf.xml='emacs /etc/freeswitch/autoload_configs/graylog2.conf.xml'
alias hash.conf.xml='emacs /etc/freeswitch/autoload_configs/hash.conf.xml'
alias hiredis.conf.xml='emacs /etc/freeswitch/autoload_configs/hiredis.conf.xml'
alias httapi.conf.xml='emacs /etc/freeswitch/autoload_configs/httapi.conf.xml'
alias http_cache.conf.xml='emacs /etc/freeswitch/autoload_configs/http_cache.conf.xml'
alias internal.xml='emacs /etc/freeswitch/sip_profiles/internal.xml'
alias internal-ipv6.xml='emacs /etc/freeswitch/sip_profiles/internal-ipv6.xml'
alias ivr.conf.xml='emacs /etc/freeswitch/autoload_configs/ivr.conf.xml'
alias java.conf.xml='emacs /etc/freeswitch/autoload_configs/java.conf.xml'
alias json_cdr.conf.xml='emacs /etc/freeswitch/autoload_configs/json_cdr.conf.xml'
alias kazoo.conf.xml='emacs /etc/freeswitch/autoload_configs/kazoo.conf.xml'
alias lcr.conf.xml='emacs /etc/freeswitch/autoload_configs/lcr.conf.xml'
alias local_stream.conf.xml='emacs /etc/freeswitch/autoload_configs/local_stream.conf.xml'
alias logfile.conf.xml='emacs /etc/freeswitch/autoload_configs/logfile.conf.xml'
alias lua.conf.xml='emacs /etc/freeswitch/autoload_configs/lua.conf.xml'
alias memcache.conf.xml='emacs /etc/freeswitch/autoload_configs/memcache.conf.xml'
alias modules.conf='emacs /usr/src/freeswitch.git/modules.conf'
alias modules.conf.xml='emacs /etc/freeswitch/autoload_configs/modules.conf.xml'
alias mongo.conf.xml='emacs /etc/freeswitch/autoload_configs/mongo.conf.xml'
alias msrp.conf.xml='emacs /etc/freeswitch/autoload_configs/msrp.conf.xml'
alias nibblebill.conf.xml='emacs /etc/freeswitch/autoload_configs/nibblebill.conf.xml'
alias opal.conf.xml='emacs /etc/freeswitch/autoload_configs/opal.conf.xml'
alias opus.conf.xml='emacs /etc/freeswitch/autoload_configs/opus.conf.xml'
alias oreka.conf.xml='emacs /etc/freeswitch/autoload_configs/oreka.conf.xml'
alias osp.conf.xml='emacs /etc/freeswitch/autoload_configs/osp.conf.xml'
alias perl.conf.xml='emacs /etc/freeswitch/autoload_configs/perl.conf.xml'
alias pocketsphinx.conf.xml='emacs /etc/freeswitch/autoload_configs/pocketsphinx.conf.xml'
alias portaudio.conf.xml='emacs /etc/freeswitch/autoload_configs/portaudio.conf.xml'
alias post_load_modules.conf.xml='emacs /etc/freeswitch/autoload_configs/post_load_modules.conf.xml'
alias presence_map.conf.xml='emacs /etc/freeswitch/autoload_configs/presence_map.conf.xml'
alias public.xml='emacs /etc/freeswitch/dialplan/public.xml'
alias python.conf.xml='emacs /etc/freeswitch/autoload_configs/python.conf.xml'
alias redis.conf.xml='emacs /etc/freeswitch/autoload_configs/redis.conf.xml'
alias rss.conf.xml='emacs /etc/freeswitch/autoload_configs/rss.conf.xml'
alias rtmp.conf.xml='emacs /etc/freeswitch/autoload_configs/rtmp.conf.xml'
alias sangoma_codec.conf.xml='emacs /etc/freeswitch/autoload_configs/sangoma_codec.conf.xml'
alias scgi.conf.xml='emacs /etc/freeswitch/autoload_configs/xml_scgi.conf.xml'
alias shout.conf.xml='emacs /etc/freeswitch/autoload_configs/shout.conf.xml'
alias skinny.conf.xml='emacs /etc/freeswitch/autoload_configs/skinny.conf.xml'
alias smpp.conf.xml='emacs /etc/freeswitch/autoload_configs/smpp.conf.xml'
alias sms_flowroute.conf.xml='emacs /etc/freeswitch/autoload_configs/sms_flowroute.conf.xml'
alias sofia.conf.xml='emacs /etc/freeswitch/autoload_configs/sofia.conf.xml'
alias spandsp.conf.xml='emacs /etc/freeswitch/autoload_configs/spandsp.conf.xml'
alias switch.conf.xml='emacs /etc/freeswitch/autoload_configs/switch.conf.xml'
alias syslog.conf.xml='emacs /etc/freeswitch/autoload_configs/syslog.conf.xml'
alias timezones.conf.xml='emacs /etc/freeswitch/autoload_configs/timezones.conf.xml'
alias translate.conf.xml='emacs /etc/freeswitch/autoload_configs/translate.conf.xml'
alias tts_commandline.conf.xml='emacs /etc/freeswitch/autoload_configs/tts_commandline.conf.xml'
alias unicall.conf.xml='emacs /etc/freeswitch/autoload_configs/unicall.conf.xml'
alias unimrcp.conf.xml='emacs /etc/freeswitch/autoload_configs/unimrcp.conf.xml'
alias user.xml='read -p "edit user: " READER && emacs /etc/freeswitch/directory/default/$READER.xml'
alias v8.conf.xml='emacs /etc/freeswitch/autoload_configs/v8.conf.xml'
alias vars.xml='emacs /etc/freeswitch/vars.xml'
alias verto.conf.xml='emacs /etc/freeswitch/autoload_configs/verto.conf.xml'
alias voicemail.conf.xml='emacs /etc/freeswitch/autoload_configs/voicemail.conf.xml'
alias voicemail_ivr.conf.xml='emacs /etc/freeswitch/autoload_configs/voicemail_ivr.conf.xml'
alias watson.xml='emacs /etc/freeswitch/autoload_configs/watson.xml'
alias xml_cdr.conf.xml='emacs /etc/freeswitch/autoload_configs/xml_cdr.conf.xml'
alias xml_curl.conf.xml='emacs /etc/freeswitch/autoload_configs/xml_curl.conf.xml'
alias xml_rpc.conf.xml='emacs /etc/freeswitch/autoload_configs/xml_rpc.conf.xml'
alias xml_scgi.conf.xml='emacs /etc/freeswitch/autoload_configs/xml_scgi.conf.xml'
alias zeroconf.conf.xml='emacs /etc/freeswitch/autoload_configs/zeroconf.conf.xml'
