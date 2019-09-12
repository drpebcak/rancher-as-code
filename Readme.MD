# Rancher as Code

This repository contains:

1. An example on how to set up rancher server in an HA configuration using terraform.
2. How to provision a cluster for workloads and attach that to rancher using terraform
3. How to manage a provisioned cluster using rancher and terraform
4. How to deploy applications into the cluster using terraform

## Usage
This example uses the terraform RKE provider - https://github.com/yamamoto-febc/terraform-provider-rke. To use this, you need to follow the [installation instructions](https://github.com/yamamoto-febc/terraform-provider-rke#installation).

1. Go into the `rancher-server` directory
2. Run terraform
```
terraform init
terraform apply
```
* You will probably want to modify some of the locals for your environment

3. Go into the `user-cluster` directory
4. Run terraform
```
terraform init
terraform apply
```
* You will probably want to modify some of the locals for your environment
