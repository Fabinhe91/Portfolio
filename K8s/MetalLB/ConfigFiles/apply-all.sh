#!/bin/bash

echo "Step 1: Installing MetalLB..."
kubectl apply -f 01-metallb-install.yaml

echo "Waiting for MetalLB pods to be ready..."
sleep 10
kubectl wait --namespace metallb-system \
  --for=condition=ready pod \
  --selector=app=metallb \
  --timeout=120s

echo "Step 2: Applying MetalLB configuration..."
kubectl apply -f 02-metallb-config.yaml

echo "Step 3: Creating HAProxy ConfigMap..."
kubectl apply -f 03-haproxy-configmap.yaml

echo "Step 4: Deploying HAProxy..."
kubectl apply -f 04-haproxy-deployment.yaml

echo "Step 5: Creating LoadBalancer Service..."
kubectl apply -f 05-haproxy-service.yaml

echo ""
echo "Installation complete! Checking status..."

echo ""
echo "1. Checking MetalLB pods:"
kubectl get pods -n metallb-system

echo ""
echo "2. Checking HAProxy pods:"
kubectl get pods -l app=haproxy-proxy

echo ""
echo "3. Checking Service (wait for EXTERNAL-IP):"
kubectl get svc haproxy-lb -w

echo ""
echo "Once EXTERNAL-IP is assigned, test with:"
echo "curl http://192.168.253.110"
