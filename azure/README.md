# tf-templates-azure

Reusable Terraform modules for Azure personal projects.

## Modules

### `modules/simple-vm`

Provisions a Standard_B1s Ubuntu 22.04 VM with a public IP and an NSG that restricts SSH to a defined list of IPv4/IPv6 CIDRs.

**Resources created:**
- Virtual network + subnet (`10.0.0.0/24`)
- Network security group with per-IP SSH rules
- Public IP (static, Standard SKU)
- Network interface
- Linux virtual machine

#### Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `project` | `string` | — | Project name — prefix for all resources and resource group |
| `resource_group_name` | `string` | — | Resource group to deploy into |
| `admin_username` | `string` | — | VM admin username |
| `public_key` | `string` | — | SSH public key content |
| `allowed_ssh_ips` | `list(string)` | — | IPv4/IPv6 CIDRs allowed to SSH |
| `location` | `string` | `"uksouth"` | Azure region |
| `vm_size` | `string` | `"Standard_B1s"` | VM SKU |
| `tags` | `map(string)` | `{}` | Tags applied to all resources |

#### Outputs

| Name | Description |
|------|-------------|
| `public_ip` | Public IP address of the VM |
| `vm_id` | Azure resource ID of the VM |
| `ssh_command` | Ready-to-use SSH connection string |

#### Usage (from another repo)

```hcl
module "vm" {
  source = "git::https://github.com/DogsbodyOps/tf-templates.git//azure/modules/simple-vm?ref=main"

  project             = "my-project"
  location            = "uksouth"
  resource_group_name = azurerm_resource_group.this.name
  admin_username      = var.admin_username
  public_key          = var.public_key
  allowed_ssh_ips     = ["203.0.113.1/32", "2001:db8::/128"]
}
```

See [`examples/simple-vm/`](examples/simple-vm/) for a complete working example.

## Requirements

| Tool | Version |
|------|---------|
| Terraform | >= 5.0 |
| azurerm provider | ~> 5.0 |
