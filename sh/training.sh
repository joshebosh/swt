#!/bin/bash

# uncomment and fill to enable sms notifcation in case of script failures
#SW_SPACE_URL="example.signalwire.com"
#SW_PROJ_KEY="AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE"
#SW_TOKEN="PTXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#SW_PHONE="+18005551212"
#CELL_PHONE="+18885551234"

#
# setup debug and logging for install progress
#
ELOG=/var/log/elog
EBUG=/var/log/ebug
echo "" > $ELOG
echo "" > $EBUG

# dump all debug info into $EBUG file
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
exec 3> $EBUG
BASH_XTRACEFD=3

sms_error () {
    if [ "${1:-}" -eq "${1:-}" ] && [ ! "${2:-}" ]; then
	MSG="line $1"
    elif [ "${1:-}" == "${1:-}" ] && [ "${2:-}" -eq "${2:-}" ]; then
	ELINE="$(sed -n $2p $0)"
	ELINE="$(printf "%s" "$TLINE" | sed -e 's/^[[:space:]]*//')"
	LOGL=$(awk 'END{print}' $ELOG)
	MSG=$(printf "($HOSTNAME)-($1)-($2)--($LOGL)---($ELINE)")
    else
	MSG="$@"
    fi

    if [[ $SW_SPACE_URL && $SW_PHONE && $CELL_PHONE && $SW_PROJ_KEY && $SW_TOKEN ]]; then
	signalwire_sms "$MSG"
    fi

    printf "%s\n" "$MSG"
    printf "error on line %s\n" "${2:-}"

    exit 193

}

signalwire_sms () {
    if [[ $SW_SPACE_URL && $SW_PHONE && $CELL_PHONE && $SW_PROJ_KEY && $SW_TOKEN ]]; then
	curl https://$SW_SPACE_URL/api/laml/2010-04-01/Accounts/$SW_PROJ_KEY/Messages.json -X POST \
	     --data-urlencode "Body=$*" \
	     --data-urlencode "From=$SW_PHONE" \
	     --data-urlencode "To=$CELL_PHONE" \
	     -u "$SW_PROJ_KEY:$SW_TOKEN" | jq '.'
    else
	printf "SignalWire vars not enabled... sms notifications disabled...\n"
    fi
}


# check if stretch or buster
local version=$(cat /etc/debian_version)
IFS='.' read -ra version <<< "$version"
if [ "$version" == 10 ]; then
    RELEASE="buster"
elif [ "$version" == 9 ]; then
    RELEASE="stretch"
else
    printf "OS not suitable for this script. Use Debian 8 or 9... exiting script\n"
    exit 0
fi

if [ $(grep -c -e "^PermitRootLogin yes") -eq 0 ]; then
    # enable ssh root login
    sed -i 's/#Banner none/Banner \/etc\/issue.net/' /etc/ssh/sshd_config 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    #systemctl restart ssh
else
    printf "root login already enabled\n"
fi

# training lab mac addresses
MAC="$(cat /sys/class/net/ens18/address)"
if [ $MAC == "00:25:90:00:00:10" ]; then HOSTNAME="TRAINING10"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:11" ]; then HOSTNAME="TRAINING11"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:12" ]; then HOSTNAME="TRAINING12"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:13" ]; then HOSTNAME="TRAINING13"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:14" ]; then HOSTNAME="TRAINING14"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:15" ]; then HOSTNAME="TRAINING15"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:16" ]; then HOSTNAME="TRAINING16"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:17" ]; then HOSTNAME="TRAINING17"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:18" ]; then HOSTNAME="TRAINING18"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:19" ]; then HOSTNAME="TRAINING19"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:20" ]; then HOSTNAME="TRAINING20"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:21" ]; then HOSTNAME="TRAINING21"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:22" ]; then HOSTNAME="TRAINING22"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:23" ]; then HOSTNAME="TRAINING23"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:24" ]; then HOSTNAME="TRAINING24"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:25" ]; then HOSTNAME="TRAINING25"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:26" ]; then HOSTNAME="TRAINING26"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:27" ]; then HOSTNAME="TRAINING27"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:28" ]; then HOSTNAME="TRAINING28"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:29" ]; then HOSTNAME="TRAINING29"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:30" ]; then HOSTNAME="TRAINING30"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:31" ]; then HOSTNAME="TRAINING31"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:32" ]; then HOSTNAME="TRAINING32"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:33" ]; then HOSTNAME="TRAINING33"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:34" ]; then HOSTNAME="TRAINING34"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:35" ]; then HOSTNAME="TRAINING35"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:36" ]; then HOSTNAME="TRAINING36"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:37" ]; then HOSTNAME="TRAINING37"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:38" ]; then HOSTNAME="TRAINING38"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:39" ]; then HOSTNAME="TRAINING39"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:40" ]; then HOSTNAME="TRAINING40"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:41" ]; then HOSTNAME="TRAINING41"; else HOSTNAME=""; fi
if [ $MAC == "00:25:90:00:00:42" ]; then HOSTNAME="TRAINING42"; else HOSTNAME=""; fi

if [ $HOSTNAME != "" ]; then
    hostname $HOSTNAME 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    printf "%s" "$HOSTNAME" > /etc/hostname 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
else
    sms_error $FUNCNAME $LINENO
fi

#
# START PACKAGED FS INSTALL (fsa)
#

# install freeswitch packages
apt-get update  2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
apt-get install -y gnupg2 wget 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
wget -O - https://files.freeswitch.org/repo/deb/freeswitch-1.8/fsstretch-archive-keyring.asc | apt-key add - 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.8/ stretch main" > /etc/apt/sources.list.d/freeswitch.list 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
echo "deb-src http://files.freeswitch.org/repo/deb/freeswitch-1.8/ stretch main" >> /etc/apt/sources.list.d/freeswitch.list 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
apt-get update && apt-get install -y freeswitch-meta-all 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO

#
# END PACKAGED FS INSTALL (fsa)
#



# TODO: this is needed during preseed install for some reason, because systemd and FS arent running yet??
if [ ! -d /etc/freeswitch/tls ]; then
    mkdir -p /etc/freeswitch/tls 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    chown freeswitch:freeswitch /etc/freeswitch/tls 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
fi



#
# START VERTO COMMUNICATOR INSTALL
#

# compile and install Verto Communicator
curl -sL https://deb.nodesource.com/setup_12.x | bash - 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
apt-get update 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
apt-get -y install nodejs 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO


# build Verto Communicator
pushd /usr/src/freeswitch.git/html5/verto/verto_communicator 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
npm install -g grunt grunt-cli bower 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
npm install 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
bower --allow-root install 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
grunt build 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO

# copy contents of dist folder to a web directory
mkdir -p /var/www/html/vc 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
cp -r /usr/src/freeswitch/html5/verto/verto_communicator/dist/* /var/www/html/vc/ 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO

# update password to match what in vars.xml
sed -i 's/1234/12345/' /var/www/html/vc/config.json 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO

# enable secure web browsing
a2enmod ssl 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
a2ensite default-ssl.conf 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
systemctl restart apache2 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
popd

if [ ! -f /etc/freeswitch/tls/self.key ]; then
    pushd /etc/freeswitch/tls 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    openssl req -x509 -newkey rsa:4096 -keyout /etc/freeswitch/tls/self.key -out /etc/freeswitch/tls/self.crt \
	    -subj "/C=US/ST=freeswitch/L=freeswitch/O=freeswitch/OU=freeswitch/CN=freeswitch" -nodes -days 365 -sha256 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    # stuff self-signed certs into wss.pem
    cat /etc/freeswitch/tls/self.crt > /etc/freeswitch/tls/wss.pem 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    cat /etc/freeswitch/tls/self.key >> /etc/freeswitch/tls/wss.pem 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    popd
else
    echo "self-signed cert already created"
fi

#
# END VERTO COMMUNICATOR INSTALL
#


#
# START COMPILE FS INSTALL (fsb)
#
apt-get build-dep -y freeswitch
if [ ! -d /usr/src/freeswitch.git ]; then
    git clone https://freeswitch.org/stash/scm/fs/freeswitch.git -bv1.8 /usr/src/freeswitch.git 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
fi
pushd /usr/src/freeswitch.git 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
git config pull.rebase true 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
./bootstrap.sh -j 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
./configure 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
make 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
make install 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
popd

# compile post install task setup group
local FSGROUP=$( awk -F':' '/^freeswitch/{print $1}' /etc/group )
if [ ! $FSGROUP ]; then
    groupadd freeswitch 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
else
    printf "group freeswitch already exists..."
fi

# compile post install task setup user
local FSUSER=$( awk -F':' '/^freeswitch/{print $1}' /etc/passwd )
if [ ! $FSUSER ]; then
    adduser --quiet --system --home /var/lib/freeswitch --gecos "FreeSWITCH open source softswitch" --ingroup freeswitch freeswitch --disabled-password 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
else
    printf "user freeswitch already exists...\n"
fi

# do the permission for our auxillary compiled FreesWITCH
chown -R freeswitch:freeswitch /usr/local/freeswitch 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
chmod -R ug=rwX,o= /usr/local/freeswitch 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
chmod -R u=rwx,g=rx /usr/local/freeswitch/bin/* 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO


# auxillary vars.xml
if [ -f /usr/local/freeswitch/conf/vars.xml ]; then
    sed -i 's/password=1234/password=12345/' /usr/local/freeswitch/conf/vars.xml 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    sed -i 's/5060/5062/' /usr/local/freeswitch/conf/vars.xml 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    sed -i 's/5061/5063/' /usr/local/freeswitch/conf/vars.xml 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    sed -i 's/5080/5082/' /usr/local/freeswitch/conf/vars.xml 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    sed -i 's/5081/5083/' /usr/local/freeswitch/conf/vars.xml 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
else
    sms_error $FUNCNAME $LINENO
fi

# auxillary switch.conf.xml
if [ -f /usr/local/freeswitch/conf/autoload_configs/switch.conf.xml ]; then
    sed -i 's/<!-- <param name="rtp-start-port" value="16384"\/> -->/<param name="rtp-start-port" value="32769"\/>/' /usr/local/freeswitch/conf/autoload_configs/switch.conf.xml 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    sed -i 's/<!-- <param name="rtp-end-port" value="32768"\/> -->/<param name="rtp-end-port" value="49152"\/>/' /usr/local/freeswitch/conf/autoload_configs/switch.conf.xml 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
else
    sms_error $FUNCNAME $LINENO
fi

# auxillary event_socket.conf.xml
if [ -f /usr/local/freeswitch/conf/autoload_configs/event_socket.conf.xml ]; then
    sed -i 's/8021/8022/' /usr/local/freeswitch/conf/autoload_configs/event_socket.conf.xml 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
else
    sms_error $FUNCNAME $LINENO
fi

# auxillary internal.xml
if [ -f /usr/local/freeswitch/conf/sip_profiles/internal.xml ]; then
    sed -i 's/5066/7344/' /usr/local/freeswitch/conf/sip_profiles/internal.xml 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    sed -i 's/7443/7444/' /usr/local/freeswitch/conf/sip_profiles/internal.xml 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
else
    sms_error $FUNCNAME $LINENO
fi

# auxillary external.xml
if [ -f /usr/local/freeswitch/conf/sip_profiles/external.xml ]; then
    :
else
    sms_error $FUNCNAME $LINENO
fi

# auxillary verto.conf.xml
if [ -f /usr/local/freeswitch/conf/autoload_configs/verto.conf.xml ]; then
    sed -i 's/8081/8083/' /usr/local/freeswitch/conf/autoload_configs/verto.conf.xml 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    sed -i 's/8082/8084/' /usr/local/freeswitch/conf/autoload_configs/verto.conf.xml 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    sed -i 's/224.1.1.1/224.1.1.2/' /usr/local/freeswitch/conf/autoload_configs/verto.conf.xml 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    sed -i 's/1337/1338/' /usr/local/freeswitch/conf/autoload_configs/verto.conf.xml 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
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
    cp /usr/src/freeswitch.git/debian/freeswitch-systemd.freeswitch.service /lib/systemd/system/freeswitchb.service || sms_error $FUNCNAME $LINENO
    sed -i 's/PIDFile=\/run\/freeswitch\/freeswitch.pid/PIDFile=\/usr\/local\/freeswitch\/run\/freeswitch.pid/' /lib/systemd/system/freeswitchb.service 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    sed -i 's/\/var\/lib\/freeswitch \/var\/log\/freeswitch \/etc\/freeswitch \/usr\/share\/freeswitch \/var\/run\/freeswitch/\/usr\/local\/freeswitch/' /lib/systemd/system/freeswitchb.service 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    sed -i 's/ExecStart=\/usr\/bin\/freeswitch/ExecStart=\/usr\/local\/freeswitch\/bin\/freeswitch/' /lib/systemd/system/freeswitchb.service 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    sed -i 's/UMask=0007/UMask=0002/' /lib/systemd/system/freeswitchb.service 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    systemctl daemon-reload 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    systemctl enable freeswitchb 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
else
    printf "freeswitchb.service already exists\n"
fi

#
# END COMPILE FS INSTALL (fsb)
#


#
# START SIGNALWIRE TRAINING INSTALL AND TOOLS
#

if [ ! -d /usr/src/swt.git ]; then
    git clone https://github.com/joshebosh/swt.git /usr/src/swt.git 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    bash /usr/src/swt.git/symlinks.sh
fi

pushd /var/www/html 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO

# nodejs
if [ $(dpkg -l | grep -c nodejs) -eq 0 ]; then
    curl -sL https://deb.nodesource.com/setup_12.x | bash - 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    apt-get install nodejs
else
    printf "nodejs already installed\n"
fi

if [ $(dpkg -l | grep -c "ii  nodejs") -gt 0 ]; then
    npm install express -g 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    npm install -g express-generator 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    npm install express --save || sms_error
    npm install @signalwire/node 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    npm install -g firebase-tools 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
else
    sms_error $FUNCNAME $LINENO
fi

# PHP 7.3
if [ $(dpkg -l | grep -c libapache2-mod-php) -eq 0 ] || [ $(dpkg -l | ache2ctl -M | grep -c php7_module) -eq 0 ]; then
    apt-get install -y lsb-release apt-transport-https ca-certificates
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php7.3.list
    apt-get update 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    apt-get install -y -f -q php7.3 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    apt-get install -y -f -q php7.3-common 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    apt-get install -y -f -q php7.3-cli 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    apt-get install -y -f -q php7.3-curl 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    apt-get install -y -f -q php7.3-xml php7.3-json 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    apt-get install -y -f -q libapache2-mod-php7.3 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    php composer-setup.php 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    php -r "unlink('composer-setup.php');" 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    
    if [ $(ls -l | grep -c "composer.phar") -gt 0 ]; then
	a2enmod php7.3 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
	phpenmod curl xml 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
	systemctl restart apache2 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
	if [ $(composer show -i | grep signalwire) -eq 0 ]; then
	    php composer.phar require signalwire/signalwire 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
	else
	    printf "php signalwire/signalwire already exits\n"
	fi
    else
	printf "composer.phar not found\n"
	sms_error $FUNCNAME $LINENO
    fi
else
    printf "apache2 mod php7.3 not loaded\n"
    sms_error $FUNCNAME $LINENO
fi

# Python 2
apt-get install -y python-pip
if [ $(dpkg -l | grep -c "ii  python-pip") -gt 0 ]; then
    pip install signalwire 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
else
    sms_error $FUNCNAME $LINENO
fi

# Python 3
apt-get install -y python3-pip
if [ $(dpkg -l | grep -c "ii  python3-pip") -gt 0 ]; then
    pip3 install signalwire 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
else
    sms_error $FUNCNAME $LINENO
fi

# Ruby
ap-get install -y ruby-dev rubygems
if [ $(dpkg -l | grep -c "ii  rubygems") -gt 0 ]; then
    if [ ${RELEASE:-} == stretch ] || [ ${RELEASE:-} == buster ]; then
	gem install signalwire 2>&1 | tee -a $ELOG || sms_error $FUNCNAME $LINENO
    else
	sms_error $FUNCNAME $LINENO
    fi
else
    sms_error $FUNCNAME $LINENO
fi

#firebase
npm install -g firebase-tools
npm install -g firebase-admin

popd

#
# All done
#

if [[ $SW_SPACE_URL && $SW_PHONE && $CELL_PHONE && $SW_PROJ_KEY && $SW_TOKEN ]]; then
    signalwire_sms "installtion complete"
fi
