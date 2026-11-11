locals {
  # ponytail: same hostname in two routes = last one wins silently; add a check block if that bites
  hostnames = { for r in var.routes : r.hostname => r }
}

data "cloudflare_zone" "this" {
  filter = { name = var.zone_name }
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "this" {
  account_id = var.account_id
  config_src = "cloudflare"
  name       = var.name
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "this" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.this.id

  config = {
    ingress = concat(
      [for r in var.routes : {
        hostname       = r.hostname
        path           = r.path
        service        = r.service
        origin_request = r.origin_request
      }],
      [{ hostname = null, path = null, service = "http_status:404", origin_request = null }],
    )
  }
}

resource "cloudflare_dns_record" "this" {
  for_each = local.hostnames
  zone_id  = data.cloudflare_zone.this.zone_id
  name     = each.key
  type     = "CNAME"
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.this.id}.cfargotunnel.com"
  proxied  = true
  ttl      = 1
}
