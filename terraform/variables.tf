variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "k8s_version" {
  type = string
}

variable "dns_zone_suffix" {
  type        = string
  description = "DNS zone suffix to use with public DNS domains"
  default     = "acme.org"
}
