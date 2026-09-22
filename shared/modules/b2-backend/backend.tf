terraform {
  backend "s3" {
    bucket                      = var.bucket
    key                         = var.key
    region                      = var.region
    endpoints = {
      s3 = var.endpoints["s3"]
    }
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}