#echo XML config loaded at `date` >> /usr/local/freeswitch/scripts/test.log
#echo `fs_cli -x 'global_setvar josh=ebosh'`
#fs_cli -x \'global_setvar josh=ebosh\'
gcore -o /tmp/fs_core_dump `pidof freeswitch`
