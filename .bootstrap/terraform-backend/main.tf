terraform {
  required_version = ">= 1.10.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71, < 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1, < 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

resource "azurerm_resource_group" "backend" {
  name     = var.backend_resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "backend" {
  name                            = var.backend_storage_account_name
  resource_group_name             = azurerm_resource_group.backend.name
  location                        = azurerm_resource_group.backend.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true
  tags                            = var.tags

  blob_properties {
    versioning_enabled = true
  }
}

resource "azurerm_storage_container" "backend" {
  name                  = var.backend_container_name
  storage_account_id    = azurerm_storage_account.backend.id
  container_access_type = "private"
}

output "backend_resource_group_name" {
  description = "Resource group name for the Terraform backend"
  value       = azurerm_resource_group.backend.name
}

output "backend_storage_account_name" {
  description = "Storage account name for the Terraform backend"
  value       = azurerm_storage_account.backend.name
}

output "backend_container_name" {
  description = "Blob container name for the Terraform backend"
  value       = azurerm_storage_container.backend.name
}