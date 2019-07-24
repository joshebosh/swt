########################
#
# FreeSWITCH stuff
#
########################

alias tscreen='screen -c /root/.tscreen'
alias epop='emacs --eval "(find-file \"/usr/src/swt.git/SignalWire_SMS/index.html\")" --eval "(search-forward \"gwd.pop\")" '
alias epopjs='emacs --eval "(find-file \"/usr/src/swt.git/SignalWire_SMS/index.js\")" --eval "(search-forward \"function get_vars\")" '


alias fsdirs='freeswitch -h > /tmp/fshelp.txt; \
/usr/src/freeswitch.git/configure -h > /tmp/fsconfigure.txt; \
fs_cli -x global_getvar | grep _dir > /tmp/fsadirs.txt; \
fs_cli -P 8022 -x global_getvar | grep _dir > /tmp/fsbdirs.txt; \
emacs -q \
-f split-window-vertically \
--eval "(find-file \"/tmp/fshelp.txt\")" \
-f split-window-horizontally \
-f other-window \
--eval "(find-file \"/tmp/fsconfigure.txt\")" \
-f other-window \
-f split-window-horizontally \
--eval "(find-file \"/tmp/fsadirs.txt\")" \
-f other-window \
--eval "(find-file \"/tmp/fsbdirs.txt\")" \
-f other-window \
'

alias aliases='emacs ~/.bash_aliases.sh && sbashrc'
alias aliasxml='aliasesxml'
alias aliasesxml='emacs ~/.bash_aliasxml.sh && sbashrc'
alias aliasxmlb='aliasesxmlb'
alias aliasesxmlb='emacs ~/.bash_aliasxmlb.sh && sbashrc'
alias autoconf='cd /etc/freeswitch/autoload_configs'
alias autoconfb='cd /usr/local/freeswitch/conf/autoload_configs'
alias callpaste='fs_cli -x "fsctl send_sighup" \
&& LogLoc1=/var/log/freeswitch/freeswitch.log.1 \
&& LogLoc2=/usr/local/freeswitch/log/freeswitch.log.1 \
&& if test -f $LogLoc1; then RESULT=$LogLoc1; \
   elif test -f $LogLoc2; then RESULT=$LogLoc2; \
   else printf "freeswitch.log not found... Log rotation turned on?\n"; printf "try again...\n"; kill $(pidof tcpdump); fi \
&& read -p "Make call, then hit <ENTER> after call complete..." \
&& fs_cli -x "fsctl send_sighup" \
&& printf "#############################################\n\n\n\n\n" \
&& curl -d private=1 --data-urlencode text@$RESULT https://pastebin.freeswitch.org/api/create \
&& printf "\nhttp://$(curl -s ifconfig.me)/capture-$DATE.pcap\n\n" \
&& printf "\n\n\n\n#############################################\n\n"' \
|| fs_cli -x "fsctl send_sighup"
#
alias bugon='fs_cli -x "console loglevel debug" \
&& fs_cli -x "sofia global siptrace on" \
&& fs_cli -x "sofia tracelevel alert" \
&& fs_cli -x "sofia loglevel all 9" \
&& fs_cli -x "fsctl loglevel 7" \
&& fs_cli -x "fsctl debug_level 0"'
#
alias bugoff='fs_cli -x "console loglevel debug" \
&& fs_cli -x "sofia global siptrace off" \
&& fs_cli -x "sofia tracelevel console" \
&& fs_cli -x "sofia loglevel all 0" \
&& fs_cli -x "fsctl loglevel 3" \
&& fs_cli -x "fsctl debug_level 0"'

alias tls='certs'
alias tlsb='certsb'
alias certs='cd /etc/freeswitch/tls'
alias certsb='cd /usr/local/freeswitch/certs'

alias callie='cd /usr/share/freeswitch/sounds/en/us/callie'
alias conf='cd /etc/freeswitch'
alias confb='cd /usr/local/freeswitch/conf'
alias configurea="cd /usr/src/freeswitch.git && ./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc --enable-core-psql-support --enable-core-odbc-support --enable-zrtp"
alias configureb="cd /usr/src/freeswitch.git && ./configure --prefix=/usr/local/freeswitch --disable-fhs --enable-core-psql-support --enable-core-odbc-support --enable-zrtp"
alias dumpy='bugon && DATE=$(date +"%Y-%m-%d-%H-%M"); tcpdump -s 0 -w /var/www/html/fs/capture-$DATE.pcap & callpaste && bugoff && kill $(pidof tcpdump) && chown freeswitch:freeswitch /var/www/html/fs/capture-$DATE.pcap && chmod 777 /var/www/html/fs/capture-$DATE.pcap'
alias ebash='emacs ~/.bashrc && sbashrc'
alias eebosh='emacs ~/ebosh.sh'
alias eemacs='emacs ~/.emacs'
alias efscli='.fs_cli_conf'
alias fs_cli_conf='.fs_cli_conf'
alias .fs_cli_conf='emacs ~/.fs_cli_conf'
alias fs_cli.conf='emacs fs_cli.conf'
alias ehosts='emacs /etc/hosts'
alias escreen='emacs ~/.screenrc'
alias flr='fs_cli -x "fsctl send_sighup" && read -p "Make a call..." && fs_cli -x "fsctl send_sighup" && fslogp'
alias fsa='fs_cli'
alias fsb='fs_cli fsb'
alias fsc='fs_cli custom'
alias fsf='stopfsa && /usr/bin/freeswitch -u freeswitch -g freeswitch -c -nonat && startfsa'
alias fsfb='stopfsb && /usr/local/freeswitch/bin/freeswitch -u freeswitch -g freeswitch -c -nonat && startfsb'
alias fsr='/usr/bin/fs_cli -R'
alias fsrb='/usr/bin/fs_cli -R fsb'
alias fse='cd /etc/freeswitch'
alias fsl='cd /usr/local/freeswitch'
alias fslog='less /var/log/freeswitch/freeswitch.log'
alias fslog1='less /var/log/freeswitch/freeswitch.log.1'
alias fsxml='less -N /var/log/freeswitch/freeswitch.xml.fsxml'
alias fsxmlb='less -N /usr/local/freeswitch/log/freeswitch.xml.fsxml'
alias fss='cd /usr/src/freeswitch.git/'
alias swt.git='cd /usr/src/swt.git/'
alias freeswitch.service='emacs /lib/systemd/system/freeswitch.service'
alias freeswitchb.service='emacs /lib/systemd/system/freeswitchb.service'
alias both.service='emacs --eval "(find-file \"/lib/systemd/system/freeswitch.service\")" -f split-window-horizontally -f other-window --eval "(find-file \"/lib/systemd/system/freeswitchb.service\")"'
alias hupall='fs_cli -x hupall'
alias killemacs='emacsclient -e "(kill-emacs)"'
alias skillemacs='emacsclient -e "(save-buffers-kill-emacs)"'
alias killscreen='screen -ls | grep Detached | cut -d. -f1 | awk "{print $1}" | xargs kill'
alias l='ls $LS_OPTIONS -lA'
alias ll='ls$LS_OPTIONS -l'
alias ls='ls $LS_OPTIONS'
alias lsn="ls -la | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\"%0o \",k);print}'"
alias logs='cd /var/log/freeswitch'
alias logsb='cd /usr/local/freeswitch/log'
alias mv='mv -i'
alias recordings='cd /var/lib/freeswitch/recordings'
alias recordingsb='cd /freeswitch/recordings/'
alias reloadxml='/usr/bin/fs_cli -x reloadxml'
alias reloadxmlb='/usr/bin/fs_cli -x reloadxml -P 8022'
alias salias='source ~/.bash_aliases.sh'
alias sbashrc='source ~/.bashrc && echo "--->  .bashrc has been reloaded <---"'
alias scripts='cd /usr/share/freeswitch/scripts/'
alias scriptsb='cd /usr/local/freeswitch/scripts/'
alias selfcert='openssl req -x509 -newkey rsa:4096 -keyout self.key -out self.crt -subj "/C=US/ST=freeswitch/L=freeswitch/O=freeswitch/OU=freeswitch/CN=freeswitch" -nodes -days 365 -sha256'

alias restartfs='restartfsa'
alias startfs='startfsa'
alias stopfs='stopfsa'
alias restartfsa='systemctl restart freeswitch && fsa'
alias startfsa='systemctl start freeswitch && fsa'
alias stopfsa='systemctl stop freeswitch'
alias restartfsb='systemctl restart freeswitchb && fsb'
alias startfsb='systemctl start freeswitchb && fsb'
alias stopfsb='systemctl stop freeswitchb'
alias stopboth='systemctl stop freeswitch && systemctl stop freeswitchb'
alias startboth='systemctl start freeswitch && systemctl start freeswitchb'
alias restartboth='systemctl restart freeswitch && systemctl restart freeswitchb'

alias sharky='DATE=$(date +"%Y-%m-%d-%H-%M"); tshark -w /var/www/html/fs/capture-$DATE.pcap || chown freeswitch:freeswitch /var/www/html/fs/capture-$DATE.pcap && chmod 777 /var/www/html/fs/capture-$DATE.pcap'
alias jsounds='cd /usr/share/freeswitch/sounds/joshebosh'
alias sounds='cd /usr/share/freeswitch/sounds'
alias soundsb='cd /usr/local/freeswitch/sounds'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'
alias fsrc='cd /usr/src/freeswitch.git/src/'

alias swclean='fs_cli -P 8021 -x "sofia profile signalwire killgw signalwire" -x "unload mod_signalwire" && rm -f /var/lib/freeswitch/storage/{adoption-auth,adoption-token,signalwire-conf}.dat && fs_cli -P 8021 -x "load mod_signalwire" && swtoken'
alias swcleanb='fs_cli -P 8022 -x "sofia profile signalwire killgw signalwire" -x "unload mod_signalwire" && rm -f /usr/local/freeswitch/storage/{adoption-auth,adoption-token,signalwire-conf}.dat && fs_cli -P 8022 -x "load mod_signalwire" && swtokenb'
alias swcleanboth='swclean && swcleanb'
alias swtoken='fs_cli -P 8021 -x "signalwire token"'
alias swtokenb='fs_cli -P 8022 -x "signalwire token"'
alias swtokenboth='swtoken && swtokenb'

alias pastebin='read -p "filename: " PASTEBIN && curl -d private=1 --data-urlencode text@$PASTEBIN https://pastebin.freeswitch.org/api/create'

pg_ready () {
    apt-get install postgresql libpq-dev
    sed -i 's/peer/trust/' /etc/postgresql/9.6/main/pg_hba.conf
    su - postgres -c "psql -U postgres -d postgres -c \"alter user postgres with password 'postgres';\""
    systemctl restart postgresql
    su - postgres -c "createdb freeswitch;"
    #su - postgres -c "psql -U postgres -d freeswitch -c \"create user freeswitch with password 'freeswitch';\""
    #su - postgres -c "psql -U postgres -d freeswitch -c \"grant all privileges on database freeswitch to freeswitch;\""
    #su - postgres; createuser freeswitch; createdb freeswitch; psql freeswitch; \password freeswitch;
}
alias pgready='pg_ready'
alias pgclean='su - postgres -c "dropdb freeswitch;" && su - postgres -c "dropuser freeswitch;"'

alias psfs='ps auxwww | grep freeswitch'
alias telnetfs='telnet 127.0.0.1 8021'
alias telenetfs='telnet 127.0.0.1 8022'
alias wfs='cd /var/www/html/fs/'
alias vc='cd /var/www/html/vc/'
alias html='cd /var/www/html/'


alias eshowports='emacs --eval "(find-file \"/root/.bash_aliases.sh\")" --eval "(search-forward \"showports\")" '
alias showports='show_ports'
show_ports () {
    read -p "endpoint name: " EP
    UUID=$(fs_cli -x "show calls" | grep $EP | awk -F ',' '{print $1}')
    REMOTE_AUDIO_PORT=$(fs_cli -x "uuid_getvar $UUID remote_media_port")
    REMOTE_VIDEO_PORT=$(fs_cli -x "uuid_getvar $UUID remote_video_port")
    LOCAL_AUDIO_PORT=$(fs_cli -x "uuid_getvar $UUID local_media_port")
    LOCAL_VIDEO_PORT=$(fs_cli -x "uuid_getvar $UUID local_video_port")
    printf "remote_media_port: %s\n" $REMOTE_AUDIO_PORT
    printf "remote_video_port: %s\n" $REMOTE_VIDEO_PORT
    printf "local_media_port: %s\n" $LOCAL_AUDIO_PORT
    printf "local_video_port: %s\n" $LOCAL_VIDEO_PORT
}


alias train10='ssh root@192.168.234.10'
alias train11='ssh root@192.168.234.11'
alias train12='ssh root@192.168.234.12'
alias train13='ssh root@192.168.234.13'
alias train14='ssh root@192.168.234.14'
alias train15='ssh root@192.168.234.15'
alias train16='ssh root@192.168.234.16'
alias train17='ssh root@192.168.234.17'
alias train18='ssh root@192.168.234.18'
alias train19='ssh root@192.168.234.19'
alias train20='ssh root@192.168.234.20'
alias train21='ssh root@192.168.234.21'
alias train22='ssh root@192.168.234.22'
alias train23='ssh root@192.168.234.23'
alias train24='ssh root@192.168.234.24'
alias train25='ssh root@192.168.234.25'
alias train26='ssh root@192.168.234.26'
alias train27='ssh root@192.168.234.27'
alias train28='ssh root@192.168.234.28'
alias train29='ssh root@192.168.234.29'
alias train30='ssh root@192.168.234.30'
alias train31='ssh root@192.168.234.31'
alias train32='ssh root@192.168.234.32'
alias train33='ssh root@192.168.234.33'
alias train34='ssh root@192.168.234.34'
alias train35='ssh root@192.168.234.35'
alias train36='ssh root@192.168.234.36'
alias train37='ssh root@192.168.234.37'
alias train38='ssh root@192.168.234.38'
alias train39='ssh root@192.168.234.39'
alias train40='ssh root@192.168.234.40'
alias train41='ssh root@192.168.234.41'
