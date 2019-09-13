# Rancher as Code

This repository contains:

1. An example on how to set up rancher server in an HA configuration using terraform.
2. How to provision a cluster for workloads and attach that to rancher using terraform
3. How to manage a provisioned cluster using rancher and terraform
4. How to deploy applications into the cluster using terraform

## Usage
This example uses the terraform RKE provider - https://github.com/yamamoto-febc/terraform-provider-rke. To use this, you need to follow the [installation instructions](https://github.com/yamamoto-febc/terraform-provider-rke#installation).

1. Go into the `rancher-server` directory
* This directory contains terraform that uses RKE to set up a kubernetes cluster, configures helm, installs cert-manager, and then installs rancher.
2. Run terraform
```
terraform init
terraform apply
```
* You will probably want to modify some of the locals for your environment

3. Go into the `user-cluster` directory
* This directory contains terraform that uses the rancher2 provider to create a custom cluster that is managed by rancher.
4. Run terraform
```
terraform init
terraform apply
```
* You will probably want to modify some of the locals for your environment

5. Go to the `install-app` directory
* This directory contains terraform that uses the rancher2 provider to add a custom catalog and install a helm chart.
4. Run terraform
```
terraform init
terraform apply
```
