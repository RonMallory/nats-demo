variable "env" {
  description = "Deployment environment (dev, qa, prod)"
  type        = string
}

variable "stack" {
  description = "Logical infrastructure layer (e.g. core, shared, staticsite)"
  type        = string
}


variable "app" {
  description = "Application identifier"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "Additional tags to merge with the standard set"
  type        = map(string)
  default     = {}
}

variable "enable_argocd" {
  description = "Enable ArgoCD for GitOps continuous delivery"
  type        = bool
  default     = false
}

variable "enable_cert_manager" {
  description = "Enable cert-manager for managing TLS certificates"
  type        = bool
  default     = false
}

variable "enable_external_dns" {
  description = "Enable ExternalDNS for managing DNS records in AWS Route53"
  type        = bool
  default     = false
}

variable "enable_aws_argocd_ingress" {
  description = "Enable AWS-specific ArgoCD Ingress for managing ArgoCD access"
  type        = bool
  default     = false
}

variable "enable_aws_argo_workflows_ingress" {
  description = "Enable AWS-specific Argo Workflows Ingress for managing Argo Workflows access"
  type        = bool
  default     = false
}

variable "enable_aws_load_balancer_controller" {
  description = "Enable AWS Load Balancer Controller for managing AWS load balancers"
  type        = bool
  default     = false
}

variable "enable_metrics_server" {
  description = "Enable Kubernetes Metrics Server for resource metrics API"
  type        = bool
  default     = false
}

variable "enable_aws_secrets_store_csi_driver_provider" {
  description = "Enable AWS Secrets and Configuration Provider (ASCP) for managing secrets"
  type        = bool
  default     = false
}

variable "enable_ingress_nginx" {
  description = "Enable NGINX Ingress Controller for managing ingress resources"
  type        = bool
  default     = false
}

variable "root_domain_name" {
  description = "Root domain name for the EKS cluster"
  type        = string
}
