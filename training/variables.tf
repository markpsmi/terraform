variable "api_key_id" {
  type = string
  description = "API Key Id from Intersight"
}
variable "api_private_key" {
  type = string
  description = "The path to your secretkey for Intersight OR the your secret key as a string"
}
variable "api_endpoint" {
  default = "intersight.com"
}

variable "organization" {
  type = string
  description = "Organization Name"
  default = "default"
}
