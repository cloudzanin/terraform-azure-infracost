##
# Variables
##

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-vm-deployment"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "Switzerland North"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "vm-main"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_DS5_v2"
}

variable "image_publisher" {
  description = "Publisher of the VM image"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Offer of the VM image"
  type        = string
  default     = "0001-com-ubuntu-server-focal"
}

variable "image_sku" {
  description = "SKU of the VM image"
  type        = string
  default     = "20_04-lts-gen2"
}

variable "image_version" {
  description = "Version of the VM image"
  type        = string
  default     = "Latest"
}

variable "admin_username" {
  description = "Administrator username for the VM"
  type        = string
  default     = "azureuser"
  sensitive   = true
}

variable "os_disk_size_gb" {
  description = "Size of the OS disk in GB"
  type        = number
  default     = 30
}

variable "enable_accelerated_networking" {
  description = "Enable accelerated networking on NIC"
  type        = bool
  default     = false
}

variable "enable_public_ip" {
  description = "Whether to create a public IP address"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks permitted to access SSH (port 22). Leave empty to disable public SSH."
  type        = list(string)
  default     = []
}

variable "allowed_web_cidrs" {
  description = "CIDR blocks permitted to access HTTP/HTTPS (80/443). Use LB/App Gateway IPs or corporate ranges."
  type        = list(string)
  default     = []
}