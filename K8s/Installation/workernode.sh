apt update -y
apt upgrade -y
apt install net-tools -y
apt install ssh -y
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
free -h
sudo hostnamectl set-hostname k8s-worker
echo "192.168.253.100 k8s-master" | sudo tee -a /etc/hosts
echo "192.168.253.101 k8s-worker" | sudo tee -a /etc/hosts

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
 net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system
sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo systemctl enable --now kubelet
sudo apt-mark hold kubelet kubeadm kubectl
systemctl stop ufw
systemctl disable ufw
kubeadm join 192.168.253.100:6443 --token yw9l7x.7czempey4gyqlnv5 --discovery-token-ca-cert-hash sha256:aada45d2da4d93d8f530e2b34d71be533af8c141fafb3fd5324cc588e06e82fe
kubectl get nodes
mkdir -p $HOME/.kube
sudo cp /tmp/kubeconfig $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl get nodes
shutdown -h now
cd /
clear
history
kubectl get nodes
systemctl status ufw
systemctl status kubelet
sudo journalctl -u kubelet -n 50 --no-pager
sudo swapoff -a
free -h
sudo vim /etc/fstab
cat /etc/fstab | grep -i swap
sudo systemctl daemon-reload
sudo systemctl restart kubelet
sudo systemctl status kubelet
kubectl get nodes -o wide
kubectl get all -A
clear
kubectl get all -A
shutdown -h now
cd /
clear
history



