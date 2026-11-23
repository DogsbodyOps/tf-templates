variable "name" {
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

variable "nsg_security_rules" {
  description = <<-EOT
    Additional NSG rules, keyed by rule name, separate from the SSH rules.
    Priorities must be unique and in 200-4096 (100-199 is reserved for SSH).
    Example:
      {
        https = {
          priority                = 200
          destination_port_ranges = ["443"]
          source_address_prefixes = ["0.0.0.0/0"]
        }
      }
  EOT
  type = map(object({
    priority                   = number
    direction                  = optional(string, "Inbound")
    access                     = optional(string, "Allow")
    protocol                   = optional(string, "Tcp")
    destination_port_ranges    = list(string)
    source_address_prefixes    = list(string)
    destination_address_prefix = optional(string, "*")
  }))
  default = {}

  validation {
    condition     = alltrue([for r in values(var.nsg_security_rules) : r.priority >= 200 && r.priority <= 4096])
    error_message = "Rule priorities must be between 200 and 4096 (100-199 is reserved for SSH rules)."
  }

  validation {
    condition     = length(distinct([for r in values(var.nsg_security_rules) : r.priority])) == length(var.nsg_security_rules)
    error_message = "Rule priorities must be unique."
  }
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
