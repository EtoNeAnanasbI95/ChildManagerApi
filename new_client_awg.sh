#!/bin/bash

WG_CONFIG="/opt/amnezia/awg/wg0.conf"

CLIENT_IP=$(echo "$(cat $WG_CONFIG | tail -n 3 | grep AllowedIPs | awk '{print $3}')" | awk -F'[/.]' '{print $1"."$2"."$3"."$4+1"/"$5}')
if [[ -n "$1" ]]; then
	SERVER_IP=$(echo "$1")
else
    echo "first argument must be an IP"
    exit
fi
SERVER_PORT=$(cat $WG_CONFIG | grep ListenPort | awk '{print $3}')

WIREGUARD_CLIENT_PRIVATE_KEY=$(wg genkey)
WIREGUARD_CLIENT_PUBLIC_KEY=$(echo $WIREGUARD_CLIENT_PRIVATE_KEY | wg pubkey)
WIREGUARD_PSK=$(cat /opt/amnezia/awg/wireguard_psk.key)
WIREGUARD_SERVER_PUBLIC_KEY=$(cat /opt/amnezia/awg/wireguard_server_public_key.key)

echo "
[Peer]
PublicKey = $WIREGUARD_CLIENT_PUBLIC_KEY
PresharedKey = $WIREGUARD_PSK
AllowedIPs = $CLIENT_IP" >> $WG_CONFIG

wg-quick down $WG_CONFIG
wg-quick up $WG_CONFIG

echo "
[Interface]
PrivateKey = $WIREGUARD_CLIENT_PRIVATE_KEY
Address = $CLIENT_IP
DNS = 1.1.1.1, 8.8.8.8

[Peer]
PublicKey = $WIREGUARD_SERVER_PUBLIC_KEY
PresharedKey = $WIREGUARD_PSK
Endpoint = $SERVER_IP:$SERVER_PORT
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25

Jc = $(cat $WG_CONFIG | grep Jc | awk '{print $3}')
Jmin = $(cat $WG_CONFIG | grep Jmin | awk '{print $3}')
Jmax = $(cat $WG_CONFIG | grep Jmax | awk '{print $3}')
S1 = $(cat $WG_CONFIG | grep S1 | awk '{print $3}')
S2 = $(cat $WG_CONFIG | grep S2 | awk '{print $3}')
H1 = $(cat $WG_CONFIG | grep H1 | awk '{print $3}')
H2 = $(cat $WG_CONFIG | grep H2 | awk '{print $3}')
H3 = $(cat $WG_CONFIG | grep H3 | awk '{print $3}')
H4 = $(cat $WG_CONFIG | grep H4 | awk '{print $3}')
"