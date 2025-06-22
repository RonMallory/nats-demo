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

variable "env_hosted_zone_name" {
  description = "Root hosted zone name: i.e. <env>.<app>.example.com"
  type        = string
}

variable "subdomain_name" {
  description = "Subdomain name for the hosted zone, e.g. 'www' or 'api'"
  type        = string
}

variable "tags" {
  description = "Additional tags to merge with the standard set"
  type        = map(string)
  default     = {}
}
