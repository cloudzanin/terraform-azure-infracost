# Terraform Backend Bootstrap

This stack creates the Azure Storage backend resources used by the main Terraform configuration.

## Resources created

1. Resource group
2. Storage account
3. Private blob container

## Usage

```bash
terraform init
terraform apply \
  -var="azure_subscription_id=<subscription-id>" \
  -var="backend_storage_account_name=<globally-unique-storage-account-name>"
```

Optional overrides:

```bash
terraform apply \
  -var="azure_subscription_id=<subscription-id>" \
  -var="location=Sweden Central" \
  -var="backend_resource_group_name=rg-terraform-state" \
  -var="backend_storage_account_name=tfstateyouruniquename" \
  -var="backend_container_name=tfstate"
```

After apply, set these GitHub repository secrets for the main workflows:

1. `TF_BACKEND_RESOURCE_GROUP`
2. `TF_BACKEND_STORAGE_ACCOUNT`
3. `TF_BACKEND_CONTAINER`
4. `TF_BACKEND_KEY`