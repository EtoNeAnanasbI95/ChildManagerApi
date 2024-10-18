#!/bin/bash

if [[ -z "$1" ]]; then
	echo -e '\$1 must be a name new client'
fi

IP=$(echo "$(ip a | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)" | awk 'NR==2')

bash ./new_client_docker_side.sh $IP | awk '/\[Interface\]/,/^$/' > "$1.conf"
