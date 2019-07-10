rm -rf /root/.bash_aliases && ln -s /usr/src/swt.git/root/.bash_aliases.sh /root/.bash_aliases.sh
rm -rf /root/.bash_aliasxml && ln -s /usr/src/swt.git/root/.bash_aliasxml.sh /root/.bash_aliasxml.sh
rm -rf /root/.bash_aliasxmlb && ln -s /usr/src/swt.git/root/.bash_aliasxmlb.sh /root/.bash_aliasxmlb.sh
rm -rf /root/.bashrc && ln -s /usr/src/swt.git/root/.bashrc /root/.bashrc
rm -rf /root/.emacs.d && ln -s /usr/src/swt.git/root/.emacs.d /root/.emacs.d
rm -rf /root/.screenrc && ln -s /usr/src/swt.git/root/.screenrc /root/.screenrc
rm -rf /root/.ssh && ln -s /usr/src/swt.git/root/.ssh /root/.ssh
rm -rf /root/.emacs && ln -s /usr/src/swt.git/root/.emacs /root/.emacs
rm -rf /root/.fs_cli_conf && ln -s /usr/src/swt.git/root/.fs_cli_conf /root/.fs_cli_conf
rm -rf /root/.profile && ln -s /usr/src/swt.git/root/.profile /root/.profile

mv /usr/local/freeswitch/conf /usr/local/freeswitch/conf_backup && ln -s /usr/src/swt.git/usr/local/freeswitch/conf /usr/local/freeswitch/conf
mv /usr/share/freeswitch/scripts /usr/share/freeswitch/scripts_backup && ln -s /usr/src/swt.git/usr/share/freeswitch/scripts /usr/share/freeswitch/scripts
mv /etc/freeswitch /etc/freeswitch_backup && ln -s /usr/src/swt.git/etc/freeswitch /etc/freeswitch

chown -h freeswitch:freeswitch /etc/freeswitch
chown -h freeswitch:freeswitch /usr/local/freeswitch/conf
chown -h freeswitch:freeswitch /usr/share/freeswitch/scripts
