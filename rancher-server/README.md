# Rancher server Terraform module

Terraform module which creates servers to host Rancher and installs Rancher on them

## Terraform versions

Terraform 0.12

## Usage

```hcl
module "rancher_server" {
  rancher_password           = var.rancher_password
  use_default_vpc            = false
  vpc_id                     = "vpc-foobar"
  aws_region                 = "us-east-1"
  aws_profile                = null
  aws_elb_subnet_ids         = ["subnet-1", "subnet-2"]
  domain                     = "foo.domain"
  r53_domain                 = "rancher.foo.domain"
  rancher2_master_subnet_ids = ["subnet-1", "subnet-2"]
  rancher2_worker_subnet_ids = ["subnet-1", "subnet-2"]

  providers = {
    aws     = "aws"
    aws.r53 = "aws.r53"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_elb\_subnet\_ids | List of subnet ids in which to place the AWS ELB | list | `[]` | no |
| aws\_profile |  | string | `"rancher-eng"` | no |
| aws\_region |  | string | `"us-west-2"` | no |
| certmanager\_chart | Helm chart to use for cert-manager install | string | `"jetstack/cert-manager"` | no |
| certmanager\_version | Version of cert-manager to install | string | `"0.10.0"` | no |
| creds\_output\_path | Where to save the id_rsa config file. Should end in a forward slash `/` . | string | `"./"` | no |
| domain |  | string | `"eng.rancher.space"` | no |
| extra\_ssh\_keys | Extra ssh keys to inject into Rancher instances | list | `[ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC06Qvs+Y9JiyOTeYNGAN/Ukq7SmeCTr7EreD1K8Lwu5VuOmo+SBZh685tNTEGV044HgFvGEOBVreDlO2ArYuwHjUBGnpQGV8/abjoeLrmZBdREAUzBQ1h2GFE/WssKUfum81cnigRK1J3tWP7emq/Y2h/Zw5F09yiCIlXMBX2auKWUCXqwG3xKTi1NVSF9N6BGyFolrAR0LZJ6k7UBXPRc/QDTclI427gSJNbnmn8LVym6YxacV/V9Y7s23iR5zYbhLPe9VJWYNk1brVvfUVb3mILVVYz76KGEq8SHdWlPQPCOp+fSJ+PezDRklnex/MmvhNrBOmMSNcpj7wSLA3hD wmaxwell@wmaxwell-laptop", "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5O7k6gRYCU7YPkCH6dyXVW10izMAkDAQtQxNxdRE22 drpebcak" ]` | no |
| github\_client\_id | GitHub client ID for Rancher to use, if using GH auth | string | `""` | no |
| github\_client\_secret | GitHub client secret for Rancher to use, if using GH auth | string | `""` | no |
| instance\_ssh\_user | Username for sshing into instances | string | `"ubuntu"` | no |
| instance\_type |  | string | `"t3.large"` | no |
| le\_email | LetsEncrypt email address to use | string | `"none@none.com"` | no |
| master\_node\_count |  | number | `"3"` | no |
| name | Name for deployment | string | `"rancher-demo"` | no |
| r53\_domain | DNS domain for Route53 zone (defaults to domain if unset) | string | `""` | no |
| rancher2\_extra\_allowed\_gh\_principals | List of principals in form github_user://IDNUM to be given Rancher access | list | `[]` | no |
| rancher2\_github\_auth\_enabled | Whether to use GitHub authentication for Rancher | bool | `"false"` | no |
| rancher2\_github\_auth\_org | GitHub numerical ID of organization to grant Rancher access to | string | `"53273206"` | no |
| rancher2\_github\_auth\_team | GitHub numerical ID of team to grant Rancher access to | string | `"3414845"` | no |
| rancher2\_github\_auth\_user | GitHub numerical ID of user to grant Rancher access to | string | `"3430214"` | no |
| rancher2\_master\_subnet\_ids | List of subnet ids for Rancher master nodes | list | `[]` | no |
| rancher2\_worker\_subnet\_ids | List of subnet ids for Rancher worker nodes | list | `[]` | no |
| rancher\_chart | Helm chart to use for Rancher install | string | `"rancher-stable/rancher"` | no |
| rancher\_password |  | string | n/a | yes |
| rancher\_version | Version of Rancher to install | string | `"2.2.8"` | no |
| rke\_backups\_region | Region to perform backups to S3 in. Defaults to aws_region | string | `""` | no |
| rke\_backups\_s3\_endpoint | Override for S3 endpoint to use for backups | string | `""` | no |
| use\_default\_vpc | Should the default VPC for the region selected be used for Rancher | bool | `"true"` | no |
| vpc\_id | If use_default_vpc is false, the vpc id that Rancher should use | string | `"null"` | no |
| worker\_node\_count |  | number | `"3"` | no |

## Outputs

| Name | Description |
|------|-------------|
| etcd\_backup\_s3\_bucket\_id | S3 bucket ID for etcd backups |
| etcd\_backup\_user\_key | AWS IAM access key id for etcd backup user |
| etcd\_backup\_user\_secret | AWS IAM secret access key for etcd backup user |
| master\_addresses | IP addresses of Rancher master nodes |
| rancher\_admin\_password | Password set for Rancher local admin user |
| rancher\_token | Admin token for Rancher cluster use |
| rancher\_url | URL at which to reach Rancher |
| worker\_addresses | IP addresses of Rancher worker nodes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->