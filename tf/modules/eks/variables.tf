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
  default     = "us-west-2"
}
variable "vpc_id" {
  description = "VPC ID to use for the EKS cluster"
  type        = string
}
variable "private_subnets" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.33"
}
variable "addons" {
  description = "Kubernetes addons"
  type        = any
  default = {
    enable_aws_load_balancer_controller = true
    enable_metrics_server               = true
  }
}
# Addons Git
variable "gitops_addons_org" {
  description = "Git repository org/user contains for addons"
  type        = string
  default     = "https://github.com/aws-samples"
}
variable "gitops_addons_repo" {
  description = "Git repository contains for addons"
  type        = string
  default     = "eks-blueprints-add-ons"
}
variable "gitops_addons_revision" {
  description = "Git repository revision/branch/ref for addons"
  type        = string
  default     = "main"
}
variable "gitops_addons_basepath" {
  description = "Git repository base path for addons"
  type        = string
  default     = "argocd/"
}
variable "gitops_addons_path" {
  description = "Git repository path for addons"
  type        = string
  default     = "bootstrap/control-plane/addons"
}

# Workloads Git
variable "gitops_workload_org" {
  description = "Git repository org/user contains for workload"
  type        = string
  default     = "https://github.com/aws-ia"
}
variable "gitops_workload_repo" {
  description = "Git repository contains for workload"
  type        = string
  default     = "terraform-aws-eks-blueprints"
}
variable "gitops_workload_revision" {
  description = "Git repository revision/branch/ref for workload"
  type        = string
  default     = "main"
}
variable "gitops_workload_basepath" {
  description = "Git repository base path for workload"
  type        = string
  default     = "patterns/gitops/"
}
variable "gitops_workload_path" {
  description = "Git repository path for workload"
  type        = string
  default     = "getting-started-argocd/k8s"
}
variable "domain_name" {
  description = "Domain name for the EKS cluster"
  type        = string
}
variable "tags" {
  description = "Additional tags to merge with the standard set"
  type        = map(string)
  default     = {}
}
