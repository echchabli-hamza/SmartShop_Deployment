#!/bin/bash
set -e

echo "=== SmartShop Deployment ==="

# Namespaces
echo "[1/5] Creating namespaces..."
kubectl apply -f k8s/namespaces/

# Database
echo "[2/5] Deploying database..."
kubectl apply -f k8s/database/

# Backend
echo "[3/5] Deploying backend..."
kubectl apply -f k8s/backend/

# Frontend
echo "[4/5] Deploying frontend..."
kubectl apply -f k8s/frontend/

# Ingress
echo "[5/5] Configuring ingress..."
kubectl apply -f k8s/ingress/

echo "=== Deployment Complete ==="
