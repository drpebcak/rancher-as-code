variable "rancher_password" {
  type = string
}

variable "github_client_id" {
  type = string
}

variable "github_client_secret" {
  type = string
}

variable "le_email" {
  type        = string
  default     = "none@none.com"
  description = "LetsEncrypt email address to use"
}

variable "domain" {
  type    = string
  default = "eng.rancher.space"
}

variable "instance_type" {
  type    = string
  default = "t3.large"
}

variable "master_node_count" {
  type    = number
  default = 3
}

variable "worker_node_count" {
  type    = number
  default = 3
}

variable "instance_ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "Username for sshing into instances"
}

variable "certmanager_version" {
  type        = string
  default     = "0.10.0"
  description = "Version of cert-manager to install"
}

variable "rancher_github_auth_enabled" {
  type        = bool
  default     = false
  description = "Whether to use GitHub authentication for Rancher"
}

variable "rancher_github_auth_user" {
  type    = string
  default = "3430214"
}

variable "rancher_github_auth_org" {
  type    = string
  default = "53273206"
}

variable "rancher_github_auth_team" {
  type    = string
  default = "3414845"
}

variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "aws_profile" {
  type    = string
  default = "rancher-eng"
}
