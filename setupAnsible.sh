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

#Define IP addresses if needed...
# Not worth doing this. Setting several IP on the same server, with only one network card is probably not useful. Deploying deveral physical nodes seems smarter to test killing nodes. Can start playing with deploying pods on master like in mini-kube.
#./add-k8s-ip.sh

# SETUP https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html
touch /etc/ansible/hosts
if ! grep master /etc/ansible/hosts
then
cat >> /etc/ansible/hosts << EOM
[master]
$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -n1)

[nodes]
$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | tail -n1)
EOM
fi

echo "Running next commands as "$SUDO_USER
sudo -u $SUDO_USER bash << EOF
if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen -f ~/.ssh/id_rsa -q -N ''
fi

ssh-copy-id -i ~/.ssh/id_rsa.pub $SUDO_USER@$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -n1)
ssh-copy-id -i ~/.ssh/id_rsa.pub $SUDO_USER@$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | tail -n1)

ssh-agent bash
ssh-add ~/.ssh/id_rsa

ansible all -m ping
echo "Finished running commands as "$SUDO_USER
EOF

echo "DONE"
