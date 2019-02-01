#!/bin/bash
if ! grep master /etc/hosts
then
  sed -i -e 's/127.0.0.1.*localhost/127.0.0.1\tlocalhost master node1 node2/' /etc/hosts
  iptables -t nat -A OUTPUT -d 192.168.0.10 -j DNAT --to-destination 127.0.0.1
  iptables -t nat -A OUTPUT -d 192.168.0.100 -j DNAT --to-destination 127.0.0.1
  iptables -t nat -A OUTPUT -d 192.168.0.101 -j DNAT --to-destination 127.0.0.1

  cat >> /etc/hosts << EOM

# K8S master IP address
192.168.0.10    master
192.168.0.100   node1
192.168.0.101   node2
EOM
fi

if ! grep 192.168.0.10 /etc/network/interfaces
then
  cat >> /etc/network/interfaces << EOM

auto enp0s3
iface enp0s3 inet static
 address 192.168.0.1/24
 address 192.168.0.10/24
 address 192.168.0.100/24
 address 192.168.0.101/24
EOM
fi
