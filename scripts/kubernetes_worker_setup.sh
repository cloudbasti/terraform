#!/bin/bash
# Update packages
apt-get update
apt-get upgrade -y

# Install container runtime prerequisites
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Setup required sysctl params
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Install containerd
apt-get install -y containerd

# Configure containerd
mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

# Update containerd configuration for Kubernetes
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

# Restart containerd
systemctl restart containerd
systemctl enable containerd

# Install Kubernetes components
apt-get install -y apt-transport-https ca-certificates curl

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# Configure kubelet
echo "KUBELET_EXTRA_ARGS=--node-ip=$(hostname -I | awk '{print $1}')" | sudo tee /etc/default/kubelet
systemctl restart kubelet

# The worker node is now ready to join the cluster with 'kubeadm join'
# You'll need to run the join command manually with the token from the master
# or automate this with Ansible