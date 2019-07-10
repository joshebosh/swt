#!/bin/bash
sed -i 's/#Banner none/Banner \/etc\/issue.net/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#systemctl restart ssh

# training lab macs
MAC="$(cat /sys/class/net/ens18/address)"
if [ $MAC == "00:25:90:00:00:10" ]; then HOSTNAME="TRAINING10"; fi
if [ $MAC == "00:25:90:00:00:11" ]; then HOSTNAME="TRAINING11"; fi
if [ $MAC == "00:25:90:00:00:12" ]; then HOSTNAME="TRAINING12"; fi
if [ $MAC == "00:25:90:00:00:13" ]; then HOSTNAME="TRAINING13"; fi
if [ $MAC == "00:25:90:00:00:14" ]; then HOSTNAME="TRAINING14"; fi
if [ $MAC == "00:25:90:00:00:15" ]; then HOSTNAME="TRAINING15"; fi
if [ $MAC == "00:25:90:00:00:16" ]; then HOSTNAME="TRAINING16"; fi
if [ $MAC == "00:25:90:00:00:17" ]; then HOSTNAME="TRAINING17"; fi
if [ $MAC == "00:25:90:00:00:18" ]; then HOSTNAME="TRAINING18"; fi
if [ $MAC == "00:25:90:00:00:19" ]; then HOSTNAME="TRAINING19"; fi
if [ $MAC == "00:25:90:00:00:20" ]; then HOSTNAME="TRAINING20"; fi
if [ $MAC == "00:25:90:00:00:21" ]; then HOSTNAME="TRAINING21"; fi
if [ $MAC == "00:25:90:00:00:22" ]; then HOSTNAME="TRAINING22"; fi
if [ $MAC == "00:25:90:00:00:23" ]; then HOSTNAME="TRAINING23"; fi
if [ $MAC == "00:25:90:00:00:24" ]; then HOSTNAME="TRAINING24"; fi
if [ $MAC == "00:25:90:00:00:25" ]; then HOSTNAME="TRAINING25"; fi
if [ $MAC == "00:25:90:00:00:26" ]; then HOSTNAME="TRAINING26"; fi
if [ $MAC == "00:25:90:00:00:27" ]; then HOSTNAME="TRAINING27"; fi
if [ $MAC == "00:25:90:00:00:28" ]; then HOSTNAME="TRAINING28"; fi
if [ $MAC == "00:25:90:00:00:29" ]; then HOSTNAME="TRAINING29"; fi
if [ $MAC == "00:25:90:00:00:30" ]; then HOSTNAME="TRAINING30"; fi
if [ $MAC == "00:25:90:00:00:31" ]; then HOSTNAME="TRAINING31"; fi
if [ $MAC == "00:25:90:00:00:32" ]; then HOSTNAME="TRAINING32"; fi
if [ $MAC == "00:25:90:00:00:33" ]; then HOSTNAME="TRAINING33"; fi
if [ $MAC == "00:25:90:00:00:34" ]; then HOSTNAME="TRAINING34"; fi
if [ $MAC == "00:25:90:00:00:35" ]; then HOSTNAME="TRAINING35"; fi
if [ $MAC == "00:25:90:00:00:36" ]; then HOSTNAME="TRAINING36"; fi
if [ $MAC == "00:25:90:00:00:37" ]; then HOSTNAME="TRAINING37"; fi
if [ $MAC == "00:25:90:00:00:38" ]; then HOSTNAME="TRAINING38"; fi
if [ $MAC == "00:25:90:00:00:39" ]; then HOSTNAME="TRAINING39"; fi
if [ $MAC == "00:25:90:00:00:40" ]; then HOSTNAME="TRAINING40"; fi
if [ $MAC == "00:25:90:00:00:41" ]; then HOSTNAME="TRAINING41"; fi
if [ $MAC == "00:25:90:00:00:42" ]; then HOSTNAME="TRAINING42"; fi

hostname $HOSTNAME
printf "%s" "$HOSTNAME" > /etc/hostname

# install freeswitch packages
apt-get update && apt-get install -y gnupg2 wget
wget -O - https://files.freeswitch.org/repo/deb/freeswitch-1.8/fsstretch-archive-keyring.asc | apt-key add -
echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.8/ stretch main" > /etc/apt/sources.list.d/freeswitch.list
echo "deb-src http://files.freeswitch.org/repo/deb/freeswitch-1.8/ stretch main" >> /etc/apt/sources.list.d/freeswitch.list
apt-get update && apt-get install -y freeswitch-meta-all

# compile and install Verto Communicator
curl -sL https://deb.nodesource.com/setup_12.x | bash -
apt-get update
apt-get -y install nodejs

# build Verto Communicator
cd /usr/src/freeswitch.git/html5/verto/verto_communicator
npm install -g grunt grunt-cli bower
npm install
bower --allow-root install
grunt build

# copy contents of dist folder to a web directory
mkdir -p /var/www/html/vc
cp -r /usr/src/freeswitch/html5/verto/verto_communicator/dist/* /var/www/html/vc/

# update password to match what in vars.xml
sed -i 's/1234/12345/' /var/www/html/vc/config.json

# enable secure web browsing
a2enmod ssl
a2ensite default-ssl.conf
systemctl restart apache2

if [ ! -f /etc/freeswitch/tls/self.key ]; then
    cd /etc/freeswitch/tls || sms_error $LINENO
    openssl req -x509 -newkey rsa:4096 -keyout /etc/freeswitch/tls/self.key -out /etc/freeswitch/tls/self.crt \
	    -subj "/C=US/ST=freeswitch/L=freeswitch/O=freeswitch/OU=freeswitch/CN=freeswitch" -nodes -days 365 -sha256
    # stuff self-signed certs into wss.pem
    cat /etc/freeswitch/tls/self.crt > /etc/freeswitch/tls/wss.pem
    cat /etc/freeswitch/tls/self.key >> /etc/freeswitch/tls/wss.pem
else
    echo "self-signed cert already created"
fi

#
# above: at this point a single FS is installed via packages
#



#
# below: we'll install an auxillary FS that is compiled
#

# compile an auxillary freeswitch
apt-get build-dep freeswitch
if [ ! -d /usr/src/freeswitch.git ]; then
    git clone https://freeswitch.org/stash/scm/fs/freeswitch.git -bv1.8 /usr/src/freeswitch.git
fi
cd /usr/src/freeswitch.git
git config pull.rebase true
./bootstrap.sh -j
./configure
make
make install

# compile post install task setup group
local FSGROUP=$( awk -F':' '/^freeswitch/{print $1}' /etc/group )
if [ ! $FSGROUP ]; then
    groupadd freeswitch
else
    printf "group freeswitch already exists..."
fi

# compile post install task setup user
local FSUSER=$( awk -F':' '/^freeswitch/{print $1}' /etc/passwd )
if [ ! $FSUSER ]; then
    adduser --quiet --system --home /var/lib/freeswitch --gecos "FreeSWITCH open source softswitch" --ingroup freeswitch freeswitch --disabled-password
else
    printf "user freeswitch already exists...\n"
fi

if [ ! -d /etc/freeswitch/tls ]; then
    #this is needed doing preseed for some reason, because systemd and FS dont actually work? TODO
    mkdir -p /etc/freeswitch/tls
    chown freeswitch:freeswitch /etc/freeswitch/tls
fi

# do the permission for our auxillary compiled FreesWITCH
chown -R freeswitch:freeswitch /usr/local/freeswitch
chmod -R ug=rwX,o= /usr/local/freeswitch
chmod -R u=rwx,g=rx /usr/local/freeswitch/bin/*


# auxillary vars.xml
if [ -f /usr/local/freeswitch/conf/vars.xml ]; then
    sed -i 's/password=1234/password=12345/' /usr/local/freeswitch/conf/vars.xml
    sed -i 's/5060/5062/' /usr/local/freeswitch/conf/vars.xml
    sed -i 's/5061/5063/' /usr/local/freeswitch/conf/vars.xml
    sed -i 's/5080/5082/' /usr/local/freeswitch/conf/vars.xml
    sed -i 's/5081/5083/' /usr/local/freeswitch/conf/vars.xml
else
    sms_error $FUNCNAME $LINENO
fi

# auxillary switch.conf.xml
if [ -f /usr/local/freeswitch/conf/autoload_configs/switch.conf.xml ]; then
    #<param name="rtp-start-port" value="$${switch_media_start_port}"/>
    sed -i 's/<!-- <param name="rtp-start-port" value="16384"\/> -->/<param name="rtp-start-port" value="32769"\/>/' /usr/local/freeswitch/conf/autoload_configs/switch.conf.xml
    #<param name="rtp-end-port" value="$${switch_media_stop_port}"/>
    sed -i 's/<!-- <param name="rtp-end-port" value="32768"\/> -->/<param name="rtp-end-port" value="49152"\/>/' /usr/local/freeswitch/conf/autoload_configs/switch.conf.xml
else
    sms_error $FUNCNAME $LINENO
fi

# auxillary event_socket.conf.xml
if [ -f /usr/local/freeswitch/conf/autoload_configs/event_socket.conf.xml ]; then
    #<param name="listen-port" value="$${event_socket_port}"/>
    sed -i 's/8021/8022/' /usr/local/freeswitch/conf/autoload_configs/event_socket.conf.xml
else
    sms_error $FUNCNAME $LINENO
fi

# auxillary internal.xml
if [ -f /usr/local/freeswitch/conf/sip_profiles/internal.xml ]; then
    #<param name="rtp-ip" value="$${local_ip_v4}"/>
    #<param name="sip-ip" value="$${local_ip_v4}"/>
    #<param name="sip-port" value="$${internal_sip_port}"/>
    #<param name="tls-sip-port" value="$${internal_tls_port}"/>
    #<param name="ws-binding"  value=":$${sip_ws_port}"/>
    sed -i 's/5066/7344/' /usr/local/freeswitch/conf/sip_profiles/internal.xml
    #<param name="wss-binding" value=":$${sip_wss_port}"/>
    sed -i 's/7443/7444/' /usr/local/freeswitch/conf/sip_profiles/internal.xml
else
    sms_error $FUNCNAME $LINENO
fi

# auxillary external.xml
if [ -f /usr/local/freeswitch/conf/sip_profiles/external.xml ]; then
    :
    #<param name="sip-port" value="$${external_sip_port}"/>
    #<param name="tls-sip-port" value="$${external_tls_port}"/>
else
    sms_error $FUNCNAME $LINENO
fi

# auxillary verto.conf.xml
if [ -f /usr/local/freeswitch/conf/autoload_configs/verto.conf.xml ]; then
    #<param name="bind-local" value="$${local_ip_v4}:$${verto_v4_ws_port}"/>
    sed -i 's/8081/8083/' /usr/local/freeswitch/conf/autoload_configs/verto.conf.xml
    #<param name="bind-local" value="$${local_ip_v4}:$${verto_v4_wss_port}" secure="true"/>
    sed -i 's/8082/8084/' /usr/local/freeswitch/conf/autoload_configs/verto.conf.xml
    #<param name="mcast-ip" value="$${mcast_ip}"/>
    sed -i 's/224.1.1.1/224.1.1.2/' /usr/local/freeswitch/conf/autoload_configs/verto.conf.xml
    #<param name="mcast-port" value="$${mcast_port}"/>
    sed -i 's/1337/1338/' /usr/local/freeswitch/conf/autoload_configs/verto.conf.xml
    #<param name="rtp-ip" value="$${local_ip_v4}"/>
    #<param name="ext-rtp-ip" value="$${external_rtp_ip}"/>
else
    sms_error $FUNCNAME $LINENO
fi

# auxillary enable mod_av, mod_shout, for startup
if [ -f /usr/local/freeswitch/conf/autoload_configs/modules.conf.xml ]; then
    grep -wq '<!--<load module="mod_av"/>-->' /usr/local/freeswitch/conf/autoload_configs/modules.conf.xml \
	&& sed -i 's/<!--<load module="mod_av"\/>-->/<load module="mod_av"\/>/' /usr/local/freeswitch/conf/autoload_configs/modules.conf.xml \
	    || printf "mod_av enabled in xml config...\n"
    grep -wq '<!--<load module="mod_shout"/>-->' /usr/local/freeswitch/conf/autoload_configs/modules.conf.xml \
	&& sed -i 's/<!--<load module="mod_shout"\/>-->/<load module="mod_shout"\/>/' /usr/local/freeswitch/conf/autoload_configs/modules.conf.xml \
	    || printf "mod_shout enabled in xml config...\n"
else
    printf "modules.conf.xml does not exist..."
fi

if [ ! -f /lib/systemd/system/freeswitchb.service ]; then
    cp /usr/src/freeswitch.git/debian/freeswitch-systemd.freeswitch.service /lib/systemd/system/freeswitchb.service
    sed -i 's/PIDFile=\/run\/freeswitch\/freeswitch.pid/PIDFile=\/usr\/local\/freeswitch\/run\/freeswitch.pid/' /lib/systemd/system/freeswitchb.service
    sed -i 's/\/var\/lib\/freeswitch \/var\/log\/freeswitch \/etc\/freeswitch \/usr\/share\/freeswitch \/var\/run\/freeswitch/\/usr\/local\/freeswitch/' /lib/systemd/system/freeswitchb.service
    sed -i 's/ExecStart=\/usr\/bin\/freeswitch/ExecStart=\/usr\/local\/freeswitch\/bin\/freeswitch/' /lib/systemd/system/freeswitchb.service
    sed -i 's/UMask=0007/UMask=0002/' /lib/systemd/system/freeswitchb.service
else
    printf "freeswitchb.service already exists\n"
fi
