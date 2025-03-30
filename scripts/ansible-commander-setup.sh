#!/bin/bash 

# Harden sshd
  cat > /etc/ssh/sshd_config.d/99-hardening.conf << 'EOL'
PasswordAuthentication no
PermitRootLogin no
Port 2369
ChallengeResponseAuthentication no
AllowUsers ubuntu
Protocol 2
X11Forwarding no
AllowTcpForwarding no
AllowAgentForwarding no
EOL
  systemctl restart sshd

#Firewall configuration (only needs ssh at the moment)
ufw default deny incoming
ufw default allow outgoing
ufw allow 2369/tcp
ufw --force enable

# Install and configure fail2ban
apt-get install -y fail2ban
cat > /etc/fail2ban/jail.d/ssh-custom.conf << 'EOL'
[sshd]
enabled = true
bantime = 3600
maxretry = 3
findtime = 600
EOL
systemctl enable fail2ban
systemctl restart fail2ban

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
#python3 -m venv .ansiblevirtual
#source .ansiblevirtual/bin/activate

#install kubernetes (now this will install kubernetes in that virtual environment)
pip install kubernetes

# set up ansible folders
mkdir -pv ~/ansible/playbook ~/ansible/inventory



