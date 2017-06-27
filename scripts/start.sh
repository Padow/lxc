#!/bin/bash

export IP_LIST=""
for (( i = 0; i < $MAX; i++ )); do
	sudo lxc-create -n centos_$i -t /usr/share/lxc/templates/lxc-centos
	echo "root"| sudo chroot /var/lib/lxc/centos_$i/rootfs passwd root --stdin
	sudo lxc-start -n centos_$i -d
	IP=`sudo lxc-info -n centos_$i|grep IP: | cut -d':' -f2 |sed -e 's/^[ \t]*//'`
  export IP_LIST=$IP_LIST" "$IP
	echo $IP >> ~/output.log
done
