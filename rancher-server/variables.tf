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
