#!/bin/bash

 # Harden sshd
  cat > /etc/ssh/sshd_config.d/99-hardening.conf << 'EOL'
PasswordAuthentication no
PermitRootLogin no
ChallengeResponseAuthentication no
AllowUsers ubuntu
Protocol 2
X11Forwarding no
AllowTcpForwarding no
AllowAgentForwarding no
EOL
  systemctl restart sshd

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
sudo hostnamectl set-hostname kube-master
# Update /etc/hosts
echo "127.0.0.1 kube-master" | sudo tee -a /etc/hosts