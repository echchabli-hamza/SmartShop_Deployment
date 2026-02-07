# SmartShop Kubernetes Deployment

Kubernetes deployment configuration for the SmartShop application using Kind (Kubernetes in Docker).

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    NGINX Ingress Controller                 │
│                     (ingress-nginx namespace)               │
├─────────────────────────────────────────────────────────────┤
│  /api/*  ──────────►  backend-service:7001                  │
│  /*      ──────────►  frontend-service:80                   │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        ▼                     ▼                     ▼
   ┌─────────┐          ┌─────────┐          ┌──────────┐
   │ Frontend│          │ Backend │          │ Postgres │
   │ (nginx) │          │ (x2 LB) │          │(Stateful)│
   │  :80    │          │  :7001  │          │  :5432   │
   └─────────┘          └─────────┘          └──────────┘
                                                   │
                                            ┌──────┴──────┐
                                            │HostPath PV  │
                                            │/tmp/k8s-    │
                                            │  postgres   │
                                            └─────────────┘
```

## Project Structure

```
k8s/
├── namespaces/          # Namespace definitions
│   ├── production.yaml  # Main application namespace
│   ├── testing.yaml     # Testing environment
│   └── readonly.yaml    # Read-only access namespace
├── database/            # PostgreSQL configuration
│   ├── secret.yaml      # DB credentials
│   ├── pvc.yaml         # PersistentVolume (hostPath)
│   ├── statefulset.yaml # PostgreSQL StatefulSet
│   └── service.yaml     # ClusterIP service :5432
├── backend/             # Spring Boot backend
│   ├── secret.yaml      # DB connection secrets
│   ├── configmap.yaml   # Application config
│   ├── deployment.yaml  # 2 replicas, port 7001
│   ├── service.yaml     # ClusterIP with session affinity
│   └── hpa.yaml         # Horizontal Pod Autoscaler
├── frontend/            # Nginx frontend
│   ├── configmap.yaml   # Custom HTML content
│   ├── deployment.yaml  # 1 replica, port 80
│   └── service.yaml     # ClusterIP service :80
├── ingress/             # Ingress configuration
│   ├── ingress-controller.yaml  # Controller setup notes
│   └── ingress.yaml     # Path-based routing rules
└── kind-config.yaml     # Kind cluster configuration
```

## Components

### Database (PostgreSQL)
- **Type**: StatefulSet with 1 replica
- **Storage**: 20Gi PersistentVolume mounted from host (`/tmp/k8s-postgres`)
- **Service**: ClusterIP on port 5432
- **Security**: Runs as user 999 (postgres)

### Backend
- **Replicas**: 2 (load balanced)
- **Port**: 7001
- **Service**: ClusterIP with session affinity (3-hour timeout)
- **Image**: `echchablihamza/smartimage:latest`

### Frontend
- **Replicas**: 1 (placeholder)
- **Port**: 80
- **Image**: nginx:alpine with custom HTML via ConfigMap

### Ingress (NGINX Controller)
- **Path Routing**:
  - `/api/*` → backend-service:7001 (with URL rewrite)
  - `/*` → frontend-service:80
- **Host Ports**: 8088 (HTTP), 8443 (HTTPS)

## Quick Start

```bash
# 1. Create Kind cluster
kind create cluster --config k8s/kind-config.yaml --name smartshop

# 2. Install NGINX Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# 3. Wait for controller
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

# 4. Deploy application
./scripts/deploy.sh
```

## Access

- **Frontend**: http://localhost:8088/
- **Backend API**: http://localhost:8088/api/...

## Scripts

| Script | Description |
|--------|-------------|
| `scripts/deploy.sh` | Deploy all resources (ns → db → backend → frontend → ingress) |
| `scripts/delete.sh` | Remove all resources (reverse order) |

## Cleanup

```bash
./scripts/delete.sh
kind delete cluster --name smartshop
```
