#!/bin/bash

sudo yum install -y epel-release
sudo yum install -y debootstrap perl libvirt
sudo yum install -y lxc lxc-templates
sudo yum install -y /usr/bin/lxc-ls

sudo systemctl start lxc.service
sudo systemctl enable lxc.service
sudo systemctl start libvirtd 
sudo systemctl enable libvirtd 
sudo systemctl status lxc.service

