variable "account_id" {
  type        = string
  description = "Cloudflare account ID."
}

variable "name" {
  type        = string
  description = "Human-readable tunnel name (e.g. 'Node 4 - Production')."
}

variable "zone_name" {
  type        = string
  description = "Cloudflare zone to create DNS records in (e.g. 'example.com')."
}

variable "routes" {
  type = list(object({
    hostname = string
    path     = optional(string)
    service  = string
    origin_request = optional(object({
      bastion_mode             = optional(bool)
      ca_pool                  = optional(string)
      connect_timeout          = optional(number)
      disable_chunked_encoding = optional(bool)
      http2_origin             = optional(bool)
      http_host_header         = optional(string)
      keep_alive_connections   = optional(number)
      keep_alive_timeout       = optional(number)
      no_happy_eyeballs        = optional(bool)
      no_tls_verify            = optional(bool)
      origin_server_name       = optional(string)
      proxy_address            = optional(string)
      proxy_port               = optional(number)
      proxy_type               = optional(string)
      tcp_keep_alive           = optional(number)
      tls_timeout              = optional(number)
      access = optional(object({
        aud_tag   = optional(list(string))
        required  = optional(bool)
        team_name = optional(string)
      }))
    }))
  }))
  default     = []
  description = "Ingress routes. Each entry creates a proxied CNAME DNS record and a tunnel ingress rule."
}
