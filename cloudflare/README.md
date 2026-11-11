# tf-templates-cloudflare

Reusable Terraform modules for Cloudflare infrastructure.

## Modules

### `modules/zero-trust-tunnel`

Provisions a Cloudflare Zero Trust tunnel (cloudflared) with ingress rules and proxied CNAME DNS records.

**Resources created:**
- `cloudflare_zero_trust_tunnel_cloudflared` — the tunnel
- `cloudflare_zero_trust_tunnel_cloudflared_config` — ingress rules (managed via Cloudflare, not local config file)
- `cloudflare_dns_record` — one proxied CNAME per route hostname

#### Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `account_id` | `string` | — | Cloudflare account ID |
| `name` | `string` | — | Human-readable tunnel name |
| `zone_name` | `string` | — | Zone to create DNS records in (e.g. `example.com`) |
| `routes` | `list(object)` | `[]` | Ingress routes — see object shape below |

**Route object shape:**

```hcl
{
  hostname       = string           # Public hostname (must be in zone_name)
  path           = optional(string) # URL path prefix
  service        = string           # Backend (e.g. "http://localhost:8080", "https://10.0.0.5:443")
  origin_request = optional(object) # cloudflared origin request options
}
```

#### Outputs

| Name | Description |
|------|-------------|
| `tunnel_id` | Tunnel ID — use as the token source for cloudflared |
| `cname_target` | CNAME target all DNS records point at (`<id>.cfargotunnel.com`) |

#### Usage (from another repo)

```hcl
module "tunnel" {
  source = "git::https://github.com/DogsbodyOps/tf-templates.git//cloudflare/modules/zero-trust-tunnel?ref=v1.0.0"

  account_id = var.account_id
  name       = "My Team - Production"
  zone_name  = "example.com"

  routes = [
    {
      hostname = "app.example.com"
      service  = "http://localhost:8080"
    },
    {
      hostname = "api.example.com"
      service  = "https://10.0.0.5:443"
      origin_request = {
        origin_server_name = "api.example.com"
      }
    },
  ]
}
```

See [`examples/zero-trust-tunnel/`](examples/zero-trust-tunnel/) for a complete working example.

## Requirements

| Tool | Version |
|------|---------|
| OpenTofu / Terraform | >= 1.0 |
| cloudflare provider | ~> 5.28 |
