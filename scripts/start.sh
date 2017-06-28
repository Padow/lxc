#!/bin/bash

export IP_LIST=""
for (( i = 0; i < $MAX; i++ )); do
	sudo lxc-create -n centos_$i -t /usr/share/lxc/templates/lxc-centos
	echo "root"| sudo chroot /var/lib/lxc/centos_$i/rootfs passwd root --stdin
	sudo lxc-start -n centos_$i -d
done

RETRY(){
	TRIES=0
	IP=""
	while [ "$TRIES" -lt  "20" ];   do
    TRIES=$((TRIES+1))
    IP=`sudo lxc-info -n centos_$1 -iH`
    if [ "$IP" == "" ]; then
      echo "IP is empty"
    else
	    export IP_LIST=$IP_LIST" "$IP
	    TRIES=20
    fi
    sleep 2
	done
}

for (( i = 0; i < $MAX; i++ )); do
  RETRY $i
done
