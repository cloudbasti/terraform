#!/bin/bash

# Set the hostname
sudo hostnamectl set-hostname kube-worker
# Update /etc/hosts
echo "127.0.0.1 kube-worker" | sudo tee -a /etc/hosts