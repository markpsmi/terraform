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
variable "encryption_key" {
  type = string
  description = "key"
}  
variable "auth_password" {
  type = string
  description = "key"
}  
variable "base_properties_password_1" {
  type = string
  description = "key"
}  
variable "privacy_password" {
  type = string
  description = "key"
}  