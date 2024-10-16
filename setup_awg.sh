mkdir -p /opt/amnezia/awg

cd /opt/amnezia/awg

umask 077

wg genkey | tee privatekey | wg pubkey > publickey
wg genkey | tee wireguard_psk.key

WG_PRIVATEKEY=$(cat privatekey) 

echo "[Interface]
PrivateKey = $WG_PRIVATEKEY
Address = 10.8.1.0/24
ListenPort = 47509
Jc = 2
Jmin = 10
Jmax = 50
S1 = 47
S2 = 18
H1 = 591113283
H2 = 637897270
H3 = 262571412
H4 = 215727400" > wg0.conf

cd ..

echo -e "#!/bin/bash

# This scripts copied from Amnezia client to Docker container to /opt/amnezia and launched every time container starts

echo \"Container startup\"
#ifconfig eth0:0 194.28.225.246 netmask 255.255.255.255 up

# kill daemons in case of restart
wg-quick down /opt/amnezia/awg/wg0.conf

# start daemons if configured
if [ -f /opt/amnezia/awg/wg0.conf ]; then (wg-quick up /opt/amnezia/awg/wg0.conf); fi

# Allow traffic on the TUN interface.
iptables -A INPUT -i wg0 -j ACCEPT
iptables -A FORWARD -i wg0 -j ACCEPT
iptables -A OUTPUT -o wg0 -j ACCEPT

# Allow forwarding traffic only from the VPN.
iptables -A FORWARD -i wg0 -o eth0 -s 10.8.1.0/24 -j ACCEPT
iptables -A FORWARD -i wg0 -o eth1 -s 10.8.1.0/24 -j ACCEPT

iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -t nat -A POSTROUTING -s 10.8.1.0/24 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.8.1.0/24 -o eth1 -j MASQUERADE

tail -f /dev/null
" > start.sh

chmod a+x start.sh

./start.sh
