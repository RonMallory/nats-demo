#!/usr/bin/env bash
set -euo pipefail

# === EDIT ME: list of cluster overlay names ===
CLUSTERS=(dev-us-west-2 dev-us-east-2)

# Resolve script location and root paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
K8S_DIR="$ROOT_DIR/k8s"
BASE_DIR="$K8S_DIR/base"
CLUSTERS_DIR="$K8S_DIR/clusters"
ARGOCD_DIR="$K8S_DIR/argocd"
ARGO_APPS_DIR="$ARGOCD_DIR/applications"

echo "Scaffolding k8s directory structure at $K8S_DIR …"

# 1. Create directories
mkdir -p "$BASE_DIR"
mkdir -p "$CLUSTERS_DIR"
mkdir -p "$ARGO_APPS_DIR"

# 2. Base stubs
cat > "$BASE_DIR/kustomization.yaml" <<EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: nats

resources:
  - nats-crds.yaml
  - nats-core.yaml

commonLabels:
  app: nats-supercluster
EOF

touch "$BASE_DIR/nats-crds.yaml"
touch "$BASE_DIR/nats-core.yaml"

# 3. Per-cluster overlays + ArgoCD Application CRs
for C in "${CLUSTERS[@]}"; do
  CL_DIR="$CLUSTERS_DIR/$C"
  mkdir -p "$CL_DIR"

  cat > "$CL_DIR/kustomization.yaml" <<EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

bases:
  - ../../base

resources:
  - eks-cluster.yaml

patchesStrategicMerge:
  - nats-patch.yaml
EOF

  cat > "$CL_DIR/eks-cluster.yaml" <<EOF
apiVersion: eks.aws/v1alpha1
kind: Cluster
metadata:
  name: $C
spec:
  name: $C
  roleARN: arn:aws:iam::<ACCOUNT_ID>:role/EKS-AutoCluster-Role
  version: "1.27"
  resourcesVpcConfig:
    subnetIds:
      - subnet-aaa
      - subnet-bbb
    endpointPublicAccess: true
EOF

  cat > "$CL_DIR/nats-patch.yaml" <<EOF
apiVersion: nats.io/v1alpha2
kind: NatsCluster
metadata:
  name: supercluster
spec:
  cluster:
    name: $C
  gateways:
    - name: gw-$C
      url: nats://gw-$C.nats.svc.cluster.local:6222
EOF

  # ArgoCD Application manifest
  cat > "$ARGO_APPS_DIR/app-$C.yaml" <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nats-supercluster-$C
  namespace: argocd
spec:
  project: default

  source:
    repoURL: https://git.example.com/your-org/nats-kustomize.git
    targetRevision: main
    path: clusters/$C

  destination:
    server: https://kubernetes.default.svc
    namespace: nats

  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF

done

# 4. ArgoCD top-level kustomization
cat > "$ARGOCD_DIR/kustomization.yaml" <<EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
EOF

for C in "${CLUSTERS[@]}"; do
  echo "  - applications/app-$C.yaml" >> "$ARGOCD_DIR/kustomization.yaml"
done

echo "✅ Done! Run: ls -R $K8S_DIR to verify."
