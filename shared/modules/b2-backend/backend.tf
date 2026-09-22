terraform {
  backend "s3" {
    bucket                      = "backblaze-backend"
    region                      = "eu-central-003"
    endpoints = {
      s3 = "s3.eu-central-003.backblazeb2.com"
    }
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
