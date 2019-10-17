variable "rancher_password" {
  type = string
}

variable "rancher_version" {
  type        = string
  default     = "2.2.9"
  description = "Version of Rancher to install"
}

variable "extra_ssh_keys" {
  type        = list
  default     = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC06Qvs+Y9JiyOTeYNGAN/Ukq7SmeCTr7EreD1K8Lwu5VuOmo+SBZh685tNTEGV044HgFvGEOBVreDlO2ArYuwHjUBGnpQGV8/abjoeLrmZBdREAUzBQ1h2GFE/WssKUfum81cnigRK1J3tWP7emq/Y2h/Zw5F09yiCIlXMBX2auKWUCXqwG3xKTi1NVSF9N6BGyFolrAR0LZJ6k7UBXPRc/QDTclI427gSJNbnmn8LVym6YxacV/V9Y7s23iR5zYbhLPe9VJWYNk1brVvfUVb3mILVVYz76KGEq8SHdWlPQPCOp+fSJ+PezDRklnex/MmvhNrBOmMSNcpj7wSLA3hD wmaxwell@wmaxwell-laptop", "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5O7k6gRYCU7YPkCH6dyXVW10izMAkDAQtQxNxdRE22 drpebcak"]
  description = "Extra ssh keys to inject into Rancher instances"
}

variable "rancher_chart" {
  type        = string
  default     = "rancher-stable/rancher"
  description = "Helm chart to use for Rancher install"
}

variable "certmanager_chart" {
  type        = string
  default     = "jetstack/cert-manager"
  description = "Helm chart to use for cert-manager install"
}

variable "name" {
  type        = string
  default     = "rancher-demo"
  description = "Name for deployment"
}

variable "github_client_id" {
  type        = string
  default     = ""
  description = "GitHub client ID for Rancher to use, if using GH auth"
}

variable "github_client_secret" {
  type        = string
  default     = ""
  description = "GitHub client secret for Rancher to use, if using GH auth"
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

variable "r53_domain" {
  type        = string
  default     = ""
  description = "DNS domain for Route53 zone (defaults to domain if unset)"
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

variable "rancher2_github_auth_enabled" {
  type        = bool
  default     = false
  description = "Whether to use GitHub authentication for Rancher"
}

variable "rancher2_github_auth_user" {
  type        = string
  default     = "3430214"
  description = "GitHub numerical ID of user to grant Rancher access to"
}

variable "rancher2_github_auth_org" {
  type        = string
  default     = "53273206"
  description = "GitHub numerical ID of organization to grant Rancher access to"
}

variable "rancher2_github_auth_team" {
  type        = string
  default     = "3414845"
  description = "GitHub numerical ID of team to grant Rancher access to"
}

variable "rancher2_extra_allowed_gh_principals" {
  type        = list
  default     = []
  description = "List of principals in form github_user://IDNUM to be given Rancher access"
}

variable "rancher2_master_subnet_ids" {
  type        = list
  default     = []
  description = "List of subnet ids for Rancher master nodes"
}

variable "rancher2_worker_subnet_ids" {
  type        = list
  default     = []
  description = "List of subnet ids for Rancher worker nodes"
}

variable "use_default_vpc" {
  type        = bool
  default     = true
  description = "Should the default VPC for the region selected be used for Rancher"
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "If use_default_vpc is false, the vpc id that Rancher should use"
}

variable "aws_elb_subnet_ids" {
  type        = list
  default     = []
  description = "List of subnet ids in which to place the AWS ELB"
}

variable "rke_backups_region" {
  type        = string
  default     = ""
  description = "Region to perform backups to S3 in. Defaults to aws_region"
}

variable "rke_backups_s3_endpoint" {
  type        = string
  default     = ""
  description = "Override for S3 endpoint to use for backups"
}

variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "aws_profile" {
  type    = string
  default = "rancher-eng"
}

variable "creds_output_path" {
  description = "Where to save the id_rsa config file. Should end in a forward slash `/` ."
  type        = string
  default     = "./"
}
