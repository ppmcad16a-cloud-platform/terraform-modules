variable "azure_location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "multi-cloud"
}

variable "resource_group_name" {
  description = "Azure Resource Group name"
  type        = string
  default     = "multi-cloud-rg"
}

variable "vnet_cidr" {
  description = "Azure VNet CIDR"
  type        = string
  default     = "10.10.0.0/16"
}

variable "subnet_cidr" {
  description = "Azure subnet CIDR"
  type        = string
  default     = "10.10.1.0/24"
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  description = "Linux VM administrator username"
  type        = string
  default     = "azureadmin"
}
