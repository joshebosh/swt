# signalwire training update script
rm -f /root/.bash_aliases && ln -s /usr/src/swt.git/root/.bash_aliases.sh /root/.bash_aliases.sh
rm -f /root/.bash_aliasxml && ln -s /usr/src/swt.git/root/.bash_aliasxml.sh /root/.bash_aliasxml.sh
rm -f /root/.bash_aliasxmlb && ln -s /usr/src/swt.git/root/.bash_aliasxmlb.sh /root/.bash_aliasxmlb.sh
reboot
