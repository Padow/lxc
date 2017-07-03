#!/bin/bash

ARRAY=()
for (( i = 0; i < $MAX; i++ )); do
    lxc-create -n ubuntu_$i -t /usr/share/lxc/templates/lxc-ubuntu
    lxc-start -n ubuntu_$i -d
done

ADD_IP_TABLE(){
  iptables -t nat -A PREROUTING -i eth0 -p tcp --dport $2 -j DNAT --to-destination $1:22
}

ADD_TO_HOSTPOOL(){
  curl -v -X POST -H "Content-Type: application/json" -d '{"default": {"os": "linux", "endpoint": {"port": '$1', "protocol": "ssh"}}, "hosts":[{"name": "ubuntu_'$4'", "endpoint":{"ip": "'$2'"},"credentials":{"username":"ubuntu","key":"ubuntu"}}]}' $3
}

RETRY(){
    TRIES=0
    IP=""
    MAP_PORT=$2
    while [ "$TRIES" -lt  "20" ];   do
    TRIES=$((TRIES+1))
    IP=`sudo lxc-info -n ubuntu_$1 -iH`
    if [ "$IP" == "" ]; then
        echo "No IP sets rety "$TRIES
    else
        MAPPING=$HOST_PRIVATE_IP:$2
        ARRAY+=($MAPPING)
        ADD_IP_TABLE $IP $MAP_PORT
        ADD_TO_HOSTPOOL $MAP_PORT $HOST_PRIVATE_IP $HOSTPOOL_ENDPOINT $i
        TRIES=20
    fi
    sleep 2
    done
}

BASE_PORT=8022
for (( i = 0; i < $MAX; i++ )); do
  PORT=$(($BASE_PORT + $i))
  RETRY $i $PORT
done

for i in "${ARRAY[@]}"; do
	STR=$i", "$STR
done
IP_LIST=${STR::-2}
