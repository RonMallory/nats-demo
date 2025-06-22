# state.tf
terraform {
  backend "s3" {
    bucket       = "nats-demo"
    key          = "tf/states"
    region       = "us-west-2"
    profile      = ""
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.env
      Stack       = var.stack
      Application = var.app
      Region      = var.region
    }
  }
}
