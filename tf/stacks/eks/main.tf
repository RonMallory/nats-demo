

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "nats-demo"
    key    = "env:/${var.env}-network-us-west-2/tf/states"
    region = "us-west-2"
  }
}


module "eks" {
  source = "../../modules/eks"

  env             = var.env
  stack           = var.stack
  app             = var.app
  region          = var.region
  vpc_id          = data.terraform_remote_state.network.outputs.vpc_id
  private_subnets = data.terraform_remote_state.network.outputs.private_subnets
  addons = {
    enable_cert_manager                          = var.enable_cert_manager
    enable_external_dns                          = var.enable_external_dns
    enable_argocd                                = var.enable_argocd
    enable_aws_load_balancer_controller          = var.enable_aws_load_balancer_controller
    enable_metrics_server                        = var.enable_metrics_server
    enable_aws_secrets_store_csi_driver_provider = var.enable_aws_secrets_store_csi_driver_provider
    enable_ingress_nginx                         = var.enable_ingress_nginx
    enable_aws_argocd_ingress                    = var.enable_aws_argocd_ingress
    enable_aws_argo_workflows_ingress            = var.enable_aws_argo_workflows_ingress
  }
  domain_name = "${var.env}.${var.root_domain_name}"
}
