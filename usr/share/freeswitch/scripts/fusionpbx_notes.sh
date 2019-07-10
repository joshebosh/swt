#FROM ENCORETG
sed -i '13iExecStartPre=/bin/mkdir -p /var/run/freeswitch/' /lib/systemd/system/freeswitch.service
sed -i '14iExecStartPre=/bin/chown -R www-data:www-data /var/run/freeswitch/' /lib/systemd/system/freeswitch.service
sed -i /lib/systemd/system/freeswitch.service -e s:"-u freeswitch -g freeswitch::"
sed -i /usr/lib/tmpfiles.d/freeswitch.conf -e s:"freeswitch freeswitch:www-data www-data:"
systemctl daemon-reload
chown -R www-data:www-data /var/run/freeswitch/
chown -R www-data:www-data /etc/freeswitch
chown -R www-data:www-data /usr/share/freeswitch/
chown -R www-data:www-data /var/lib/freeswitch
chown -R www-data:www-data /var/lib/freeswitch/images
chown -R www-data:www-data /var/lib/freeswitch/recordings
chown -R www-data:www-data /var/lib/freeswitch/storage
chown -R www-data:www-data /var/log/freeswitch/xml_cdr/
chown -R www-data:www-data /usr/include/freeswitch/
chown -R www-data:www-data /var/log/freeswitch
chown -R www-data:www-data /var/run/freeswitch/

#FROM ME
# removed keys to start fresh
apt-key list
apt-key del A2B57698
apt-key del 25E010CF 
apt-key del F14D5181

# remove freeswitch packages
apt-get purge freeswitch* libfreeswitch*

# keep checking and ensure they're gone, often have to do a couple times
dpkg -l | grep freeswitch
apt-get purge freeswitch*

# clean up
apt-get autoremove
apt-get autoclean

# removed public source code from out initial attempt at compile (so we can compile FSA source)
rm -fr /usr/src/freeswitch/ || rm -fr /usr/src/freeswitch.git

# edited for FSA repo
emacs sources.list.d/freeswitch.list

# get FSA repo key
wget -O - https://cloud_voice_support%40encoretg.com:Cl0ud%21FREEswitch@fsa.freeswitch.com/repo/deb/fsa/pubkey.gpg | apt-key add - 

# edited auth.conf to remove URL encoded symbold, and use plain text
emacs ../auth.conf 

apt-get update

# had to use "aptitude" because "apt-get" kept giving dependency errors, likely due to some other repo's enabled with experimental package? i dont know...
# building all deps for compiling
aptitude build-dep freeswitch

# setup user ssh config file
cd /root/.ssh
printf 'host stash\n     User git\n     Hostname stash.freeswitch.org\n     port 7999\n          IdentitiesOnly yes' >> ~/.ssh/config

# clone FSA source code
git clone https://cloud_voice_support%40encoretg.com:Cl0ud%21FREEswitch@freeswitch.org/stash/scm/fsa/freeswitch-advantage.git /usr/src/freeswitch.git
cd freeswitch.git/

# I didnt actually do this step this time around, but this is a good idea. Currently system has FSA "master" compiled, but you really want "v1.8-fsa"
git checkout v1.8-fsa

# I simply hand edited the patch... removed like 5 lines, added 1 line
emacs +1994 src/mod/endpoints/mod_sofia/mod_sofia.c

# bootstrap compilation code
./bootstrap.sh

# uncommented all various mods you use in system, and made backup copy in /root/modules.conf
emacs modules.conf 
cp modules.conf /root/

# this is the configure for enabling core pgsql and laying out installation in FHS (packages) compliant manner
./configure -C --prefix=/usr --localstatedir=/var --sysconfdir=/etc --enable-core-pgsql-support
make
make install

# use same persmission as FusionPBX (www-data)
chown -R www-data:www-data /run/freeswitch /var/lib/freeswitch /var/log/freeswitch /etc/freeswitch
chmod -R ug=rwX,o= /run/freeswitch /var/lib/freeswitch /var/log/freeswitch
cd /usr/bin
chmod -R u=rwx,g=rx freeswitch fs_cli fs_encode fs_ivrd fsxs gentls_cert tone2wav

# copy (and edit for www-data) the freeswitch.service file
cp /usr/src/freeswitch.git/debian/freeswitch-systemd.freeswitch.service /etc/systemd/system/freeswitch.service
emacs /etc/systemd/system/freeswitch.service
systemctl daemon-reload
service freeswitch start

# sometimes have to remove freeswitch.pid if failed start
rm /var/run/freeswitch/freeswitch.pid 
service freeswitch start

# backup original db (FS will write new one)
cd /usr/local/freeswitch/db
mv core.db core.db.encoretg
service freeswitch start

# sometimes have to delete a corrupt database
rm /usr/local/freeswitch/db/core.db
service freeswitch start

# start FS in foreground to inspect startup log on fs_cli (can also check /var/log/freeswitch/freeswitch.log)
service freeswitch stop
./freeswitch -u www-data -g www-data -nonat  # three dots (...) to shutdown

# found some random file needing permissions
chown www-data:www-data mwi.tmp 

service freeswitch start
fs_cli
