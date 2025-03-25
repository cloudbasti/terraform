#!/bin/bash 

# Set the hostname
sudo hostnamectl set-hostname commander
# Update /etc/hosts
echo "127.0.0.1 commander" | sudo tee -a /etc/hosts

#install ansible
sudo apt update
sudo apt -y upgrade
sudo apt install -y software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt -y install ansible


# ansible must be installed before
ansible-galaxy collection install kubernetes.core
ansible-galaxy collection install community.kubernetes
ansible-galaxy collection install cloud.common

# install python pip and venv
sudo apt install -y python3-pip 
sudo apt install -y python3-venv

#create a virtual environment
python3 -m venv .ansiblevirtual
source .ansiblevirtual/bin/activate

#install kubernetes (now this will install kubernetes in that virtual environment)
pip install kubernetes

# set up ansible folders
mkdir -pv ~/ansible/playbook ~/ansible/inventory



