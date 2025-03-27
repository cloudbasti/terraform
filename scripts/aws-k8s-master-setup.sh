#!/bin/bash

# Set the hostname
sudo hostnamectl set-hostname kube-master
# Update /etc/hosts
echo "127.0.0.1 kube-master" | sudo tee -a /etc/hosts