#!/bin/bash

#This scrip only for study purposed. Create by SyedMokhtar
#Iptables update to block the direct torrent
#https://www.facebook.com/syed.mokhtardahari

clear

echo " "
echo "*****************************************************"
echo "WELCOME TO DROPBEAR INSTALLATION SCRIPT, OS = Ubuntu/debian"
echo "-----------------------------------------------------"
echo "*****************************************************"
echo " "
echo " "
echo "Please enter a user name for dropbear@SSH"
read u
echo " "
echo "Please enter a password (will be shown in plain text while typing):"
read p
echo " "
echo "Please enter a gropName (will be shown in plain text while typing):"
read g
echo " "
echo "Please enter a PortNumber (will be shown in plain text while typing):"
read t
echo " "

clear

a="`netstat -i | cut -d' ' -f1 | grep eth0`";
b="`netstat -i | cut -d' ' -f1 | grep venet0:0`";

if [ "$a" == "eth0" ]; then
  ip="`/sbin/ifconfig eth0 | awk -F':| +' '/inet addr/{print $4}'`";
elif [ "$b" == "venet0:0" ]; then
  ip="`/sbin/ifconfig venet0:0 | awk -F':| +' '/inet addr/{print $4}'`";
fi

# install Required
cd
apt-get update
apt-get --yes --force-yes install apt-utils
apt-get --yes --force-yes install sudo
sudo apt-get --yes --force-yes install wget curl
sudo apt-get --yes --force-yes install nano
sudo apt-get --yes --force-yes install --reinstall software-properties-common

# update apt-file
cd
sudo apt-file --yes --force-yes update

#Install dropbear@SSH
cd
apt-get --yes --force-yes install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=222/DROPBEAR_PORT=$t/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS=""/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service dropbear restart

#Add User
cd /home
groupadd $g
adduser --quiet --disabled-password -shell /bin/bash --home /home/newuser --gecos "User" $u
echo "$u:$p" | chpasswd

###### Found on web  iptables -L -nv --line-numbers
sudo iptables -N LOGDROP > /dev/null 2> /dev/null 
sudo iptables -F LOGDROP 
sudo iptables -A LOGDROP -j DROP
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $t -j ACCEPT

#Torrent 
sudo iptables -D FORWARD -m string --algo bm --string "BitTorrent" -j LOGDROP  
sudo iptables -D FORWARD -m string --algo bm --string "BitTorrent protocol" -j LOGDROP
sudo iptables -D FORWARD -m string --algo bm --string "thepiratebay" -j LOGDROP
sudo iptables -D FORWARD -m string --algo bm --string "peer_id=" -j LOGDROP
sudo iptables -D FORWARD -m string --algo bm --string ".torrent" -j LOGDROP
sudo iptables -D FORWARD -m string --algo bm --string "announce.php?passkey=" -j LOGDROP
sudo iptables -D FORWARD -m string --algo bm --string "torrent" -j LOGDROP
sudo iptables -D FORWARD -m string --algo bm --string "announce" -j LOGDROP
sudo iptables -D FORWARD -m string --algo bm --string "info_hash" -j LOGDROP

# DHT keyword iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
sudo iptables -A FORWARD -m string --string "announce_peer" --algo bm -j LOGDROP
sudo iptables -A FORWARD -m string --string "find_node" --algo bm -j LOGDROP

## Modified debia commands 
sudo iptables -A FORWARD -p udp -m string --algo bm --string "thepiratebay" -j DROP
sudo iptables -A FORWARD -p udp -m string --algo bm --string "BitTorrent" -j DROP
sudo iptables -A FORWARD -p udp -m string --algo bm --string "BitTorrent protocol" -j DROP
sudo iptables -A FORWARD -p udp -m string --algo bm --string "peer_id=" -j DROP
sudo iptables -A FORWARD -p udp -m string --algo bm --string ".torrent" -j DROP
sudo iptables -A FORWARD -p udp -m string --algo bm --string "announce.php?passkey=" -j DROP
sudo iptables -A FORWARD -p udp -m string --algo bm --string "torrent" -j DROP
sudo iptables -A FORWARD -p udp -m string --algo bm --string "announce" -j DROP
sudo iptables -A FORWARD -p udp -m string --algo bm --string "info_hash" -j DROP
sudo iptables -A FORWARD -p udp -m string --algo bm --string "tracker" -j DROP 
sudo iptables -A INPUT -p udp -m string --algo bm --string "BitTorrent" -j DROP
sudo iptables -A INPUT -p udp -m string --algo bm --string "BitTorrent protocol" -j DROP
sudo iptables -A INPUT -p udp -m string --algo bm --string "peer_id=" -j DROP
sudo iptables -A INPUT -p udp -m string --algo bm --string ".torrent" -j DROP
sudo iptables -A INPUT -p udp -m string --algo bm --string "announce.php?passkey=" -j DROP
sudo iptables -A INPUT -p udp -m string --algo bm --string "torrent" -j DROP
sudo iptables -A INPUT -p udp -m string --algo bm --string "announce" -j DROP
sudo iptables -A INPUT -p udp -m string --algo bm --string "info_hash" -j DROP
sudo iptables -A INPUT -p udp -m string --algo bm --string "tracker" -j DROP
sudo iptables -I INPUT -p udp -m string --algo bm --string "BitTorrent" -j DROP
sudo iptables -I INPUT -p udp -m string --algo bm --string "BitTorrent protocol" -j DROP
sudo iptables -I INPUT -p udp -m string --algo bm --string "peer_id=" -j DROP
sudo iptables -I INPUT -p udp -m string --algo bm --string ".torrent" -j DROP
sudo iptables -I INPUT -p udp -m string --algo bm --string "announce.php?passkey=" -j DROP
sudo iptables -I INPUT -p udp -m string --algo bm --string "torrent" -j DROP
sudo iptables -I INPUT -p udp -m string --algo bm --string "announce" -j DROP
sudo iptables -I INPUT -p udp -m string --algo bm --string "info_hash" -j DROP
sudo iptables -I INPUT -p udp -m string --algo bm --string "tracker" -j DROP
sudo iptables -D INPUT -p udp -m string --algo bm --string "BitTorrent" -j DROP
sudo iptables -D INPUT -p udp -m string --algo bm --string "BitTorrent protocol" -j DROP
sudo iptables -D INPUT -p udp -m string --algo bm --string "peer_id=" -j DROP
sudo iptables -D INPUT -p udp -m string --algo bm --string ".torrent" -j DROP
sudo iptables -D INPUT -p udp -m string --algo bm --string "announce.php?passkey=" -j DROP
sudo iptables -D INPUT -p udp -m string --algo bm --string "torrent" -j DROP
sudo iptables -D INPUT -p udp -m string --algo bm --string "announce" -j DROP
sudo iptables -D INPUT -p udp -m string --algo bm --string "info_hash" -j DROP
sudo iptables -D INPUT -p udp -m string --algo bm --string "tracker" -j DROP
sudo iptables -I OUTPUT -p udp -m string --algo bm --string "BitTorrent" -j DROP
sudo iptables -I OUTPUT -p udp -m string --algo bm --string "BitTorrent protocol" -j DROP
sudo iptables -I OUTPUT -p udp -m string --algo bm --string "peer_id=" -j DROP
sudo iptables -I OUTPUT -p udp -m string --algo bm --string ".torrent" -j DROP
sudo iptables -I OUTPUT -p udp -m string --algo bm --string "announce.php?passkey=" -j DROP
sudo iptables -I OUTPUT -p udp -m string --algo bm --string "torrent" -j DROP
sudo iptables -I OUTPUT -p udp -m string --algo bm --string "announce" -j DROP
sudo iptables -I OUTPUT -p udp -m string --algo bm --string "info_hash" -j DROP
sudo iptables -I OUTPUT -p udp -m string --algo bm --string "tracker" -j DROP 
sudo iptables-save

service dropbear restart
cd
rm ./Ubuntu_dropbear.sh
history -c && history -w
clear

echo " "
echo "***************************************************"
echo "Your VPS dropbear is completed and ready. You may add-the user."
echo " "
echo "You may try to test running using below account"
echo "Host: $ip $t"
cat /etc/default/dropbear |grep ^DROPBEAR_PORT=
echo "Acount name : $u "
echo "Password : $p "
echo " "
echo "***************************************************"
echo " "
echo " "
echo " "
echo "For long term support for other OS and assistance, you may donate to My Paypal"
echo "Paypal link to freuende@yahoo.com.my"
history -c && history -w

