variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "account_id" {
  type = string
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

module "tunnel" {
  source = "git::https://github.com/DogsbodyOps/tf-templates.git//cloudflare/modules/zero-trust-tunnel?ref=main"

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

output "tunnel_id" {
  value = module.tunnel.tunnel_id
}
