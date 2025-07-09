# Devops-Assignment

# 🚀 DevOps Project: AWS EKS + ArgoCD + Ingress

This project covers complete end-to-end DevOps setup using:

- Terraform to provision AWS infrastructure
- Kubernetes to deploy workloads
- ArgoCD to manage GitOps
- Ingress + Domain to expose services

---

## 🧱 Task 1: Provision AWS EKS Cluster Using Terraform

### ✅ Performed

- Created VPC, subnets, EKS cluster, and node groups
- Used `terraform-aws-modules/eks/aws` official module
- IAM roles and security groups handled by the module
- Kubeconfig auto-generated for cluster access

### ▶️ Commands

```bash
cd terraform/
terraform init
terraform apply
```

### 🔗 Access the Cluster

```bash
aws eks update-kubeconfig --name Devops-Assignment-Cluster --region us-east-1
kubectl get nodes
```

---

## 📦 Task 2: Deploy NGINX via Kubernetes Manifests

### ✅ Performed

- Created `Deployment` and `Service` YAML files in `/manifests`
- Verified pod and service creation

### ▶️ Commands

```bash
kubectl apply -f manifests/nginx-deployment.yaml
kubectl apply -f manifests/nginx-service.yaml
kubectl get pods
kubectl get svc
```

---

## 🔁 Task 3: Install & Configure ArgoCD

### ✅ Performed

- Installed ArgoCD in `argocd` namespace
- Port-forwarded ArgoCD UI locally
- Created Application YAML for GitOps sync

### ▶️ Commands

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### 🔐 Login

```bash
Username: admin
Password: (base64 decode)
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
```

### ▶️ GitOps Application

```bash
kubectl apply -f ArgoCD/nginx-app.yaml
```

---

## 🌍 Task 4: Access NGINX via NodePort

This was already completed in Task 2 and 3:

- Used NodePort Service
- ArgoCD deployed NGINX
- Verified pod and service accessibility

---

## 🌐 Task 5: Ingress + Custom Domain

### ✅ Performed

- Installed Ingress Controller using Helm
- Created Ingress resource for NGINX
- Mapped custom domain in GoDaddy
- Domain: `nginx.productivitypro.xyz`

### ▶️ Helm Install

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.service.type=LoadBalancer
```

### ▶️ Ingress YAML (Excerpt)

```yaml
rules:
- host: nginx.productivitypro.xyz
  http:
    paths:
    - path: /
      pathType: Prefix
      backend:
        service:
          name: nginx-service
          port:
            number: 80
```

### ▶️ DNS (GoDaddy)

CNAME:
```
nginx → ad1120f25...elb.amazonaws.com
```

### ✅ Final Access

```
http://nginx.productivitypro.xyz
```

---

## 📁 Project Structure

```
Devops-Assignment/
├── terraform/                 # Terraform infra setup
├── manifests/                 # Deployment, Service, Ingress YAMLs
├── ArgoCD/                    # ArgoCD application manifest
├── task-1.md to task-5.md     # Step-by-step breakdowns
└── README.md                  # Full summary
```

---

## ✅ Conclusion

All infrastructure, CI/CD, and app deployments are handled using:

- 🧱 Infrastructure as Code (Terraform)
- ☸️ Kubernetes deployment
- 🔁 GitOps (ArgoCD)
- 🌐 Domain + Ingress + DNS

Project completed and verified successfully ✔️
