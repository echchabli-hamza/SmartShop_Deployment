#!/bin/bash
set -e

echo "=== SmartShop Cleanup ==="

# Ingress
echo "[1/5] Removing ingress..."
kubectl delete -f ../k8s/ingress/ --ignore-not-found

# Frontend
echo "[2/5] Removing frontend..."
kubectl delete -f ../k8s/frontend/ --ignore-not-found

# Backend
echo "[3/5] Removing backend..."
kubectl delete -f ../k8s/backend/ --ignore-not-found

# Database
echo "[4/5] Removing database..."
kubectl delete -f ../k8s/database/ --ignore-not-found

# Namespaces
echo "[5/5] Removing namespaces..."
kubectl delete -f ../k8s/namespaces/ --ignore-not-found

echo "=== Cleanup Complete ==="
