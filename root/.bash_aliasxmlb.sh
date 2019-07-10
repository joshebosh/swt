#
# MULTI-WINDOW EMACS ALIASES
#

alias ugroupsb='emacs \
-f split-window-vertically \
-f split-window-horizontally \
--eval "(find-file \"/usr/local/freeswitch/conf/dialplan/default.xml\")" \
--eval "(search-forward \"group_dial_sales\")" \
-f other-window \
--eval "(find-file \"/usr/local/freeswitch/conf/directory/default.xml\")" \
--eval "(search-forward \"sales\")" \
-f other-window \
--eval "(find-file \"/usr/local/freeswitch/conf/directory/default/1000.xml\")" \
-f split-window-horizontally \
-f other-window \
--eval "(find-file \"/usr/local/freeswitch/conf/directory/default/1001.xml\")" \
-f other-window \
'

alias overvarb='emacs \
-f split-window-vertically \
--eval "(find-file \"/usr/local/freeswitch/conf/directory/default.xml\")" \
--eval "(search-forward \"variables\")" \
-f other-window \
-f split-window-horizontally \
--eval "(find-file \"/usr/local/freeswitch/conf/directory/default/1000.xml\")" \
-f other-window \
--eval "(find-file \"/usr/local/freeswitch/conf/directory/default/1001.xml\")" \
-f other-window \
'


#
# PSUEDO FILENAME ALIASES
#

alias dialplanb='default.xmlb'
alias gatewaysb='gateways.xmlb'
alias phraseb='demo-ivr.xmlb'
alias fsuserb='user.xmlb'
alias varsb='vars.xmlb'



#
# VERBAITM FILNAME ALIASES
#

alias abstraction.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/abstraction.conf.xml'
alias acl.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/acl.conf.xml'
alias alsa.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/alsa.conf.xml'
alias amd.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/amd.conf.xml'
alias amqp.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/amqp.conf.xml'
alias amr.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/amr.conf.xml'
alias amrwb.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/amrwb.conf.xml'
alias avmd.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/avmd.conf.xml'
alias av.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/av.conf.xml'
alias blacklist.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/blacklist.conf.xml'
alias callcenter.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/callcenter.conf.xml'
alias cdr_csv.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/cdr_csv.conf.xml'
alias cdr_mongodb.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/cdr_mongodb.conf.xml'
alias cdr_pg_csv.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/cdr_pg_csv.conf.xml'
alias cdr_sqlite.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/cdr_sqlite.conf.xml'
alias cepstral.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/cepstral.conf.xml'
alias chatplan.conf.xmlb='emacs /usr/local/freeswitch/conf/chatplan/default.xml'
alias cidlookup.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/cidlookup.conf.xml'
alias conference.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/conference.conf.xml'
alias conference_layouts.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/conference_layouts.conf.xml'
alias config.json='emacs /var/www/html/vc/config.json'
alias console.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/console.conf.xml'
alias db.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/db.conf.xml'
alias default.xmlb='emacs /usr/local/freeswitch/conf/dialplan/default.xml'
alias demo-ivr.xmlb='emacs /usr/local/freeswitch/conf/lang/en/demo/demo-ivr.xml'
alias dialplan_directory.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/dialplan_directory.conf.xml'
alias dingaling.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/dingaling.conf.xml'
alias directoryb='emacs /usr/local/freeswitch/conf/directory/default.xml'
alias directory.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/directory.conf.xml'
alias distributor.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/distributor.conf.xml'
alias easyroute.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/easyroute.conf.xml'
alias enum.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/enum.conf.xml'
alias en.xmlb='emacs /usr/local/freeswitch/conf/lang/en/en.xml'
alias erlang_event.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/erlang_event.conf.xml'
alias event_multicast.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/event_multicast.conf.xml'
alias event_socket.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/event_socket.conf.xml'
alias external.xmlb='emacs /usr/local/freeswitch/conf/sip_profiles/external.xml'
alias external-ipv6.xmlb='emacs /usr/local/freeswitch/conf/sip_profiles/external-ipv6.xml'
alias fail2ban.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/fail2ban.conf.xml'
alias fax.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/fax.conf.xml'
alias features.xmlb='emacs /usr/local/freeswitch/conf/dialplan/features.xml'
alias fifo.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/fifo.conf.xml'
alias format_cdr.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/format_cdr.conf.xml'
alias freeswitch.xmlb='emacs /usr/local/freeswitch/conf/freeswitch.xml'
alias gateways.xmlb='emacs /usr/local/freeswitch/conf/sip_profiles/external/gateways.xml'
alias gcloud.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/glcoud.conf.xml'
alias graylog2.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/graylog2.conf.xml'
alias hash.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/hash.conf.xml'
alias hiredis.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/hiredis.conf.xml'
alias httapi.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/httapi.conf.xml'
alias http_cache.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/http_cache.conf.xml'
alias internal.xmlb='emacs /usr/local/freeswitch/conf/sip_profiles/internal.xml'
alias internal-ipv6.xmlb='emacs /usr/local/freeswitch/conf/sip_profiles/internal-ipv6.xml'
alias ivr.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/ivr.conf.xml'
alias java.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/java.conf.xml'
alias json_cdr.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/json_cdr.conf.xml'
alias kazoo.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/kazoo.conf.xml'
alias lcr.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/lcr.conf.xml'
alias local_stream.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/local_stream.conf.xml'
alias logfile.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/logfile.conf.xml'
alias lua.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/lua.conf.xml'
alias memcache.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/memcache.conf.xml'
alias modules.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/modules.conf.xml'
alias mongo.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/mongo.conf.xml'
alias msrp.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/msrp.conf.xml'
alias nibblebill.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/nibblebill.conf.xml'
alias opal.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/opal.conf.xml'
alias opus.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/opus.conf.xml'
alias oreka.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/oreka.conf.xml'
alias osp.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/osp.conf.xml'
alias perl.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/perl.conf.xml'
alias pocketsphinx.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/pocketsphinx.conf.xml'
alias portaudio.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/portaudio.conf.xml'
alias post_load_modules.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/post_load_modules.conf.xml'
alias presence_map.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/presence_map.conf.xml'
alias public.xmlb='emacs /usr/local/freeswitch/conf/dialplan/public.xml'
alias python.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/python.conf.xml'
alias redis.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/redis.conf.xml'
alias rss.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/rss.conf.xml'
alias rtmp.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/rtmp.conf.xml'
alias sangoma_codec.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/sangoma_codec.conf.xml'
alias scgi.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/xml_scgi.conf.xml'
alias shout.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/shout.conf.xml'
alias skinny.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/skinny.conf.xml'
alias smpp.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/smpp.conf.xml'
alias sms_flowroute.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/sms_flowroute.conf.xml'
alias sofia.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/sofia.conf.xml'
alias spandsp.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/spandsp.conf.xml'
alias switch.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/switch.conf.xml'
alias syslog.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/syslog.conf.xml'
alias timezones.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/timezones.conf.xml'
alias translate.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/translate.conf.xml'
alias tts_commandline.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/tts_commandline.conf.xml'
alias unicall.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/unicall.conf.xml'
alias unimrcp.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/unimrcp.conf.xml'
alias user.xmlb='read -p "edit user: " READER && emacs /usr/local/freeswitch/conf/directory/default/$READER.xml'
alias v8.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/v8.conf.xml'
alias vars.xmlb='emacs /usr/local/freeswitch/conf/vars.xml'
alias verto.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/verto.conf.xml'
alias voicemail.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/voicemail.conf.xml'
alias voicemail_ivr.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/voicemail_ivr.conf.xml'
alias watson.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/watson.xml'
alias xml_cdr.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/xml_cdr.conf.xml'
alias xml_curl.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/xml_curl.conf.xml'
alias xml_rpc.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/xml_rpc.conf.xml'
alias xml_scgi.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/xml_scgi.conf.xml'
alias zeroconf.conf.xmlb='emacs /usr/local/freeswitch/conf/autoload_configs/zeroconf.conf.xml'
