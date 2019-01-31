#!/bin/bash

# ref: https://askubuntu.com/a/30157/8698
if ! [ $(id -u) = 0 ]; then
   echo "The script needs to be run as root." >&2
   exit 1
fi

echo "Running next commands as "$(whoami)
# INSTALL https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#latest-releases-via-apt-ubuntu
apt install -y software-properties-common openssh-server
apt-add-repository --yes  ppa:ansible/ansible
apt update -y && sudo apt install -y ansible

# Define IP addresses if needed...
./add-k8s-ip.sh

# SETUP https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html
touch /etc/ansible/hosts
if ! grep master /etc/ansible/hosts
then
cat >> /etc/ansible/hosts << EOM
[master]
192.168.0.10

[nodes]
192.168.0.100
192.168.0.101
EOM
fi

echo "Running next commands as "$SUDO_USER
sudo -u $SUDO_USER bash << EOF
if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen -f ~/.ssh/id_rsa -q -N ''
fi

ssh-copy-id -i ~/.ssh/id_rsa.pub $SUDO_USER@master
ssh-copy-id -i ~/.ssh/id_rsa.pub $SUDO_USER@node1
ssh-copy-id -i ~/.ssh/id_rsa.pub $SUDO_USER@node2

ssh-agent bash
ssh-add ~/.ssh/id_rsa

ansible all -m ping
echo "Finished running commands as "$SUDO_USER
EOF

echo "DONE"
