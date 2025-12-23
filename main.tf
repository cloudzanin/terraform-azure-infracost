##
# Terraform Configuration
##

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
    azapi = {
      source  = "Azure/azapi"
      version = ">= 2.2.0, < 3.0.0"
    }
  }
}

provider "azapi" {
  # Configuration options
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id

  # IMPORTANT: use Entra ID for storage data-plane calls when keys are disabled
  storage_use_azuread = true

}


##
# Data Sources
##

data "azurerm_client_config" "current" {
}

##
# Local Variables
##

locals {
  resource_prefix = "${var.environment}-vm"
  common_tags = merge(
    var.tags,
    {
      deployed_at = timestamp()
    }
  )
}

##
# Resource Group
##

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

##
# Virtual Network & Networking
##

resource "azurerm_virtual_network" "main" {
  name                = "${local.resource_prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}

resource "azurerm_subnet" "main" {
  name                 = "${local.resource_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "main" {
  name                = "${local.resource_prefix}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags

  // All ingress rules moved to dedicated azurerm_network_security_rule resources
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_public_ip" "main" {
  count               = var.enable_public_ip ? 1 : 0
  name                = "${local.resource_prefix}-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

resource "azurerm_network_interface" "main" {
  name                           = "${local.resource_prefix}-nic"
  location                       = azurerm_resource_group.main.location
  resource_group_name            = azurerm_resource_group.main.name
  accelerated_networking_enabled = var.enable_accelerated_networking
  tags                           = local.common_tags

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.enable_public_ip ? azurerm_public_ip.main[0].id : null
  }
}

##
# Virtual Machine
##

resource "azurerm_linux_virtual_machine" "main" {
  name                = var.vm_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = var.vm_size
  tags                = local.common_tags

  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.example.public_key_openssh
  }

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}

##
# Data Disk (Optional)
##

resource "azurerm_managed_disk" "data" {
  name                 = "${local.resource_prefix}-data-disk"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 128
  tags                 = local.common_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  managed_disk_id    = azurerm_managed_disk.data.id
  virtual_machine_id = azurerm_linux_virtual_machine.main.id
  lun                = 0
  caching            = "ReadWrite"
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

##
# Outputs
##

output "resource_group_id" {
  description = "ID of the created resource group"
  value       = azurerm_resource_group.main.id
}

output "vm_id" {
  description = "ID of the created virtual machine"
  value       = azurerm_linux_virtual_machine.main.id
}

output "vm_name" {
  description = "Name of the created virtual machine"
  value       = azurerm_linux_virtual_machine.main.name
}

output "private_ip_address" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.main.private_ip_address
}

output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = var.enable_public_ip ? azurerm_public_ip.main[0].ip_address : "N/A"
  sensitive   = false
}

output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "network_security_group_id" {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.main.id
}