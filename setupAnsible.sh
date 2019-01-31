#!/bin/bash

# INSTALL https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#latest-releases-via-apt-ubuntu
sudo apt install -y software-properties-common openssh-server
sudo apt-add-repository --yes  ppa:ansible/ansible
sudo apt update -y && sudo apt install -y ansible

# SETUP https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html
echo "[master]" | sudo tee /etc/ansible/hosts
echo "127.0.0.1" | sudo tee -a /etc/ansible/hosts
echo "[nodes]" | sudo tee -a /etc/ansible/hosts
echo "127.0.0.1" | sudo tee -a /etc/ansible/hosts

if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen -f ~/.ssh/id_rsa -q -N ''
  ssh-copy-id -i ~/.ssh/id_rsa.pub $USER@127.0.0.1
fi

ssh-agent bash
ssh-add ~/.ssh/id_rsa

ansible all -m ping
