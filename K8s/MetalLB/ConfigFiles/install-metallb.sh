#!/bin/bash

echo "=== Installing MetalLB ==="
echo ""

echo "Step 1: Creating namespace..."
kubectl create namespace metallb-system

echo "Step 2: Installing MetalLB CRDs..."
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml

echo "Step 3: Waiting for MetalLB to be ready..."
sleep 30

echo "Checking MetalLB pods..."
kubectl get pods -n metallb-system

echo ""
echo "MetalLB installation complete!"
echo ""
