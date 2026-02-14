#!/bin/bash

set -e  # Exit on error

echo "=== Complete HAProxy + MetalLB Installation ==="
echo ""

# 1. Install MetalLB
echo "Step 1: Installing MetalLB..."
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml

echo "Waiting for MetalLB pods to start..."
sleep 20

echo "Checking MetalLB pods status:"
kubectl get pods -n metallb-system

# Wait for pods to be ready
echo "Waiting for pods to be ready..."
for i in {1..30}; do
  READY=$(kubectl get pods -n metallb-system -l app=metallb -o jsonpath='{.items[*].status.containerStatuses[?(@.ready==true)].ready}' | wc -w)
  if [ "$READY" -ge 2 ]; then
    echo "MetalLB pods are ready!"
    break
  fi
  echo "Waiting for MetalLB pods... ($i/30)"
  sleep 10
done

# 2. Configure MetalLB
echo ""
echo "Step 2: Configuring MetalLB..."
kubectl apply -f - <<EOF
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: default-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.253.100-192.168.253.150
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: default-advertisement
  namespace: metallb-system
spec:
  ipAddressPools:
  - default-pool
EOF

# 3. Create HAProxy ConfigMap
echo ""
echo "Step 3: Creating HAProxy ConfigMap..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: haproxy-config
data:
  haproxy.cfg: |
    global
      log stdout format raw local0 info
    
    defaults
      mode http
      timeout connect 5s
      timeout client 50s
      timeout server 50s
    
    frontend http_in
      bind *:8080
      default_backend google_backend
    
    backend google_backend
      server google_server www.google.com:443 ssl verify none
      http-request set-header Host www.google.com
EOF

# 4. Deploy HAProxy
echo ""
echo "Step 4: Deploying HAProxy..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: haproxy-proxy
spec:
  replicas: 2
  selector:
    matchLabels:
      app: haproxy-proxy
  template:
    metadata:
      labels:
        app: haproxy-proxy
    spec:
      containers:
      - name: haproxy
        image: haproxy:2.8-alpine
        ports:
        - containerPort: 8080
        volumeMounts:
        - name: config
          mountPath: /usr/local/etc/haproxy/haproxy.cfg
          subPath: haproxy.cfg
          readOnly: true
      volumes:
      - name: config
        configMap:
          name: haproxy-config
EOF

# 5. Create LoadBalancer Service
echo ""
echo "Step 5: Creating LoadBalancer Service..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: haproxy-lb
spec:
  selector:
    app: haproxy-proxy
  ports:
  - port: 80
    targetPort: 8080
  type: LoadBalancer
  loadBalancerIP: "192.168.253.110"
EOF

echo ""
echo "=== Installation Complete! ==="
echo ""
echo "Checking status:"
echo ""

# Show status
kubectl get pods -n metallb-system
echo ""
kubectl get pods -l app=haproxy-proxy
echo ""
echo "Service (wait for EXTERNAL-IP):"
kubectl get svc haproxy-lb

echo ""
echo "To monitor progress:"
echo "  watch kubectl get svc haproxy-lb"
echo ""
echo "Once EXTERNAL-IP is assigned, test with:"
echo "  curl -v http://192.168.253.110"
echo ""
echo "For troubleshooting:"
echo "  kubectl logs -n metallb-system -l app=metallb"
echo "  kubectl describe svc haproxy-lb"
