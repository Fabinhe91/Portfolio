#!/bin/bash

echo "=== Verification Script ==="
echo ""

echo "1. Checking MetalLB:"
kubectl get pods -n metallb-system
echo ""

echo "2. Checking IPAddressPool:"
kubectl get ipaddresspools.metallb.io -n metallb-system
echo ""

echo "3. Checking L2Advertisement:"
kubectl get l2advertisements.metallb.io -n metallb-system
echo ""

echo "4. Checking HAProxy Deployment:"
kubectl get deployment haproxy-proxy
echo ""

echo "5. Checking HAProxy Pods:"
kubectl get pods -l app=haproxy-proxy -o wide
echo ""

echo "6. Checking Service:"
kubectl get svc haproxy-lb
echo ""

echo "7. Checking Service Details:"
kubectl describe svc haproxy-lb
echo ""

echo "8. Testing Internal Connection:"
kubectl run test-$RANDOM --image=curlimages/curl --rm -it --restart=Never -- \
  curl -s -o /dev/null -w "HTTP Code: %{http_code}\n" \
  http://haproxy-lb.default.svc.cluster.local

echo ""
echo "9. Getting External IP:"
EXTERNAL_IP=$(kubectl get svc haproxy-lb -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "External IP: $EXTERNAL_IP"
echo ""

if [ -n "$EXTERNAL_IP" ]; then
    echo "10. Testing External Connection (if reachable):"
    echo "Run manually: curl -v http://$EXTERNAL_IP"
fi
