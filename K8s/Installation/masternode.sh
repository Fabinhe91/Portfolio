cd /
clear
apt update -y
apt upgrade -y
apt update -y
apt upgrade -y
reboot
cd /
clear
kubectl
history
apt update -y
apt upgrade -y
apt upgrade
nmtui
vi /etc/netplan/00-installer-config.yaml
netplan apply
ip a
ping google.pt
cat /etc/netplan/00-installer-config.yaml
apt install net-tools
arp -a
ping 192.168.253.101
arp -a
reboot
cd /
apt update -y && apt upgrade -y
apt install ssh -y
cd /
clear
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
free -h
sudo hostnamectl set-hostname k8s-master
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
systemctl status uf
systemctl status ufw
systemctl stop ufw
systemctl disable ufw
sudo kubeadm init   --pod-network-cidr=10.244.0.0/16   --apiserver-advertise-address=192.168.253.100   --control-plane-endpoint=192.168.253.100:6443   --upload-certs   --v=5
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl cluster-info
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
kubeadm token create --print-join-command
kubeadm token create --print-join-command > /tmp/join-command.sh
cat /tmp/join-command.sh
kubectl get nodes
scp $HOME/.kube/config user@k8s-worker:/tmp/kubeconfig
scp $HOME/.kube/config fabio@k8s-worker:/tmp/kubeconfig
kubectl get nodes
kubectl get pods --all-namespaces
kubectl cluster-info
kubectl get componentstatuses
kubectl create deployment nginx-test --image=nginx:alpine --replicas=2
kubectl expose deployment nginx-test --port=80 --type=NodePort
kubectl get deployments
kubectl get pods
kubectl get services
kubectl describe service nginx-test | grep NodePort
NODE_PORT=$(kubectl get svc nginx-test -o jsonpath='{.spec.ports[0].nodePort}')
curl http://k8s-master:$NODE_PORT
ku get all
k get all
kubectl get all
kubectl delete deploy nginx-test
kubectl delete svc nginx-test
kubectl get all
kubectl get all -A
mkdir projeto1
cd projeto1/
vi haproxy-all.yaml
kubectl apply -f .
kubectl get all
vi haproxy-all.yaml
cd ..
mkdir projeto2
cd projeto2
vi complete-haproxy.yaml
kubectl apply -f .
vi complete-haproxy.yaml
kubectl apply -f .
vi complete-haproxy.yaml
kubectl apply -f .
vi complete-haproxy.yaml
kubectl apply -f .
kubectl get all
vi complete-haproxy.yaml
kubectl get all
kubectl apply -f .
kubectl get svc haproxy-lb -w
vi complete-haproxy.yaml
kubectl apply -f .
kubectl delete service haproxy-lb 2>/dev/null || true
kubectl apply -f .
ls
vi complete-haproxy.yaml
kubectl get all
kubectl delete deployment haproxy-proxy
kubectl delete svc haproxy-service
kubectl get all
cd ..
mkdir projeto3
cd projeto 3
cd projeto3
vi haproxy-cm.yaml
vi haproxy-deploy.yaml
vi haproxy-svc.yaml
kubectl apply -f haproxy-cm.yaml
kubectl apply -f haproxy-deploy.yaml
kubectl apply -f haproxy-svc.yaml
grep -i "loadbalancerip" complete-haproxy.yaml
cat complete-haproxy.yaml | tail -20
kubectl get all
kubectl explain service.spec.loadBalancerIP
kubectl explain service.spec.LoadBalancerIP
kubectl delete service haproxy-lb
ls
vi haproxy-svc.yaml
kubectl apply -f .
kubectl get all
vi haproxy-svc.yaml
kubectl get all
kubectl delete svc haproxy-lb
kubectl delete deployment haproxy-proxy
kubectl get all
kubectl get configmap
kubectl delete configmap haproxy-config
kubectl get all
cd ..
mkdir projeto4
cd projeto4
vi 01-metallb-install.yaml
vi 02-metallb-config.yaml
vi 03-haproxy-configmap.yaml
vi 04-haproxy-deployment.yaml
vi 05-haproxy-service.yaml
vi apply-all.sh
chmod +x apply-all.sh
vi verify-setup.sh
ls
bash apply-all.sh
ls
vi 00-metallb-crds.yaml
ls
vi install-metallb.sh
vi complete-install.sh
kubectl delete svc haproxy-lb
kubectl delete deployment haproxy-proxy
kubectl delete configmap haproxy-config
kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml 2>/dev/null || true
kubectl delete namespace metallb-system 2>/dev/null || true
sleep 10
chmod +x complete-install.sh
./complete-install.sh
shutdown -h now
cd /
clear
history
kubectl get nodes -o wide
firewall-cmd
ufw
systemctl status ufw
kubectl get nodes -o wide
systemctl restart kubelet
systemctl status kubelet
systemctl start kubelet
systemctl status kubelet
sudo swapoff -a
free -h
sudo vi /etc/fstab
cat /etc/fstab | grep -i swap
sudo systemctl daemon-reload
sudo systemctl restart kubelet
sudo systemctl status kubelet
kubectl get nodes
kubectl get nodes -o wide
clear
ls
cd projeto4
ls
cat 00-metallb-crds.yaml
ls
cat 01-metallb-install.yaml
ls
cat 02-metallb-config.yaml
cat 03-haproxy-configmap.yaml
ls
cat 03-haproxy-configmap.yaml
cat 05-haproxy-service.yaml
ls
cat 05-haproxy-service.yaml
cat install-metallb.sh
ls
shutdown -h now
cd /
clear
history