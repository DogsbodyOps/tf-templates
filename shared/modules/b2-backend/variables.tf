variable "bucket" {
  type = string
  default = "backblaze-backend"
}

variable "key" {
  type = string
}

variable "region" {
  type = string
  default = "eu-central-003"
}

variable "endpoints" {
  type = map(string)
  default = {
    s3 = "s3.eu-central-003.backblazeb2.com"
  }
}