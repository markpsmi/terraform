variable "api_key_id" {
  type =  string
 
}  
variable "api_private_key" {
  type  = string
}
variable "endpoint" {
  default = "https://www.intersight.com"
}
variable "IKSCluster" {
  type = string
}
variable "namespace" {
  type = string
  description = "Namespace to install application"
}
