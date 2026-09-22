variable "project" {
  description = "Project name — used as prefix for all resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "uksouth"
}

variable "resource_group_name" {
  description = "Resource group to deploy into"
  type        = string
}

variable "admin_username" {
  description = "VM admin username"
  type        = string
}

variable "public_key" {
  description = "SSH public key content"
  type        = string
}

variable "allowed_ssh_ips" {
  description = "List of IPv4/IPv6 CIDRs allowed to SSH (e.g. 203.0.113.1/32, 2001:db8::/32)"
  type        = list(string)
}

variable "vm_size" {
  description = "VM SKU"
  type        = string
  default     = "Standard_B1s"
}

variable "tags" {
  type    = map(string)
  default = {}
}
