output "tunnel_id" {
  value       = cloudflare_zero_trust_tunnel_cloudflared.this.id
  description = "Tunnel ID — use as the token source for cloudflared."
}

output "cname_target" {
  value       = "${cloudflare_zero_trust_tunnel_cloudflared.this.id}.cfargotunnel.com"
  description = "CNAME target all DNS records for this tunnel point at."
}
