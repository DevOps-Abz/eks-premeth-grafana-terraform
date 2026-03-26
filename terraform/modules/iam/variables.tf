variable "cluster_name" {
  type = string
}

variable "is_eks_role_enabled" {
  type = bool
}

variable "is_eks_nodegroup_role_enabled" {
  type = bool
}

variable "is_alb_controller_enabled" {
  type = bool
}

variable "oidc_provider_url" {
  type = string
  default = ""
}

variable "oidc_provider_arn" {
  type = string
  default = ""
}

variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}





