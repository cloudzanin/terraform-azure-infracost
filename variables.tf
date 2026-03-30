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
  default     = "Sweden Central"
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
  default     = "Standard_B1s"
}

variable "image_publisher" {
  description = "Publisher of the VM image"
  type        = string
  default     = "MicrosoftWindowsServer"
}

variable "image_offer" {
  description = "Offer of the VM image"
  type        = string
  default     = "WindowsServer"
}

variable "image_sku" {
  description = "SKU of the VM image"
  type        = string
  default     = "2019-datacenter-gensecond"
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
  description = "Size of the OS disk in GB. Windows Server images used here require at least 127 GB."
  type        = number
  default     = 127
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

variable "allowed_rdp_cidrs" {
  description = "CIDR blocks permitted to access RDP (port 3389). Leave empty to disable public RDP."
  type        = list(string)
  default     = []
}

variable "allowed_web_cidrs" {
  description = "CIDR blocks permitted to access HTTP/HTTPS (80/443). Use LB/App Gateway IPs or corporate ranges."
  type        = list(string)
  default     = []
}