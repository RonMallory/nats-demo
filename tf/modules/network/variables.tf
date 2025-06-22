variable "env" {
  description = "Deployment environment (dev, qa, prod)"
  type        = string
}

variable "stack" {
  description = "Logical infrastructure layer (e.g. core, shared, staticsite)"
  type        = string
}

variable "az_count" {
  description = "Number of availability zones to use"
  type        = number
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
