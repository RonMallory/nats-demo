output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = module.eks.configure_kubectl
}

output "configure_argocd" {
  description = "Terminal Setup"
  value       = module.eks.configure_argocd
}

output "access_argocd" {
  description = "ArgoCD Access"
  value       = module.eks.access_argocd
}
