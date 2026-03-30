variable "azure_subscription_id" {
  description = "Azure subscription ID used to create the Terraform backend resources"
  type        = string
}

variable "location" {
  description = "Azure region for the Terraform backend resources"
  type        = string
  default     = "Sweden Central"
}

variable "backend_resource_group_name" {
  description = "Resource group name for the Terraform backend resources"
  type        = string
  default     = "rg-terraform-state"
}

variable "backend_storage_account_name" {
  description = "Globally unique storage account name for the Terraform backend"
  type        = string
}

variable "backend_container_name" {
  description = "Blob container name for Terraform state"
  type        = string
  default     = "tfstate"
}

variable "tags" {
  description = "Tags to apply to the Terraform backend resources"
  type        = map(string)
  default = {
    managed_by = "terraform"
    purpose    = "terraform-state"
  }
}