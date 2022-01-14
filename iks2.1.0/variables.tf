variable "apikey" {
  type        = string
  description = "API Key"
}
variable "secretkey" {
  type        = string
  description = "Secret Key or file location"
}
variable "endpoint" {
  type        = string
  description = "API Endpoint URL"
  default     = "https://www.intersight.com"
}
variable "organization" {
  type        = string
  description = "Organization Name"
  default     = "default"
}
variable "ssh_user" {
  type        = string
  description = "SSH Username for node login."
}
variable "ssh_key" {
  type        = string
  description = "ssh key for login"
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPo0G8IcvGmR5xLEiRAbvXctAFcRQ1HB6JRW+F4a8JRP root@localhost.localdomain"
}    
variable "vcPassword" {
  type        = string
  description = "vCenter Password"
}  
variable "tags" {
  type    = list(map(string))
  default = []
}
