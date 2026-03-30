# Terraform Azure Example

This repository contains Terraform configurations that provision an Azure resource group, networking (VNet, subnet, NSG), and a Windows virtual machine with an optional public IP. It includes GitHub Actions workflows for validation, deployment, and manual destroy, using GitHub Actions secrets-driven tfvars.

## Remote State Backend

This repo uses an Azure Storage remote backend for the main Terraform stack so GitHub Actions deploy and destroy runs share the same state.

Backend resources are created by a separate bootstrap Terraform stack in [.bootstrap/terraform-backend](.bootstrap/terraform-backend).

### Bootstrap the backend once

Run the bootstrap stack once before using the main deploy or destroy workflows.

Required inputs for the bootstrap stack:

1. `azure_subscription_id`
2. `location`
3. `backend_resource_group_name`
4. `backend_storage_account_name`
5. `backend_container_name`

Example:

```bash
cd .bootstrap/terraform-backend
terraform init
terraform apply \
	-var="azure_subscription_id=<subscription-id>" \
	-var="location=Sweden Central" \
	-var="backend_resource_group_name=rg-terraform-state" \
	-var="backend_storage_account_name=tfstateyouruniquename" \
	-var="backend_container_name=tfstate"
```

### Required GitHub repository secrets

1. `AZURE_CLIENT_ID`
2. `AZURE_TENANT_ID`
3. `AZURE_SUBSCRIPTION_ID`
4. `TF_BACKEND_RESOURCE_GROUP`
5. `TF_BACKEND_STORAGE_ACCOUNT`
6. `TF_BACKEND_CONTAINER`
7. `TF_BACKEND_KEY`

Example backend secret values:

```text
TF_BACKEND_RESOURCE_GROUP=rg-terraform-state
TF_BACKEND_STORAGE_ACCOUNT=tfstateyouruniquename
TF_BACKEND_CONTAINER=tfstate
TF_BACKEND_KEY=terraform-azure-infracost.tfstate
```

The GitHub Actions identity needs both:

1. Permission to manage the VM resources, such as `Contributor`
2. Storage data-plane access on the backend storage account, such as `Storage Blob Data Contributor`

The validate workflow still uses `terraform init -backend=false`, so pull request checks do not depend on the remote backend.

<a href="https://www.buymeacoffee.com/techielass"> <img align="left" src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="50" width="210" alt="techielass" /></a></p>

<br><br>

---

## Credits

Written by: Sarah Lean

[![YouTube Channel Subscribers](https://img.shields.io/youtube/channel/subscribers/UCQ8U53KvEX2JuCe48MxmV3Q?label=People%20subscribed%20to%20my%20YouTube%20channel&style=social)](https://www.youtube.com/techielass?sub_confirmation=1) [![Twitter Follow](https://img.shields.io/twitter/follow/techielass?label=Twitter%20Followers&style=social)](https://twitter.com/intent/follow?screen_name=techielass)

Find me on:

* My Blog: <https://www.techielass.com>
* Twitter: <https://twitter.com/techielass>
* LinkedIn: <http://uk.linkedin.com/in/sazlean>