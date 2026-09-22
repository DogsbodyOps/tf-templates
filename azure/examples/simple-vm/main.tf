variable "project" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "public_key" {
  type      = string
  sensitive = true
}

variable "allowed_ssh_ips" {
  type = list(string)
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "this" {
  name     = "${var.project}-rg"
  location = "uksouth"
}

module "vm" {
  source = "git::https://github.com/DogsbodyOps/tf-templates.git//azure/modules/simple-vm?ref=main"

  project             = var.project
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  admin_username      = var.admin_username
  public_key          = var.public_key
  allowed_ssh_ips     = var.allowed_ssh_ips
}

output "ssh" {
  value = module.vm.ssh_command
}
