variable "api_key_id" {
  type =  string
 // default = "6116d77a7564612d33dc6596/6116d77a7564612d33dc659a/620bce187564612d33b4429a"
}  
variable "api_private_key" {
  type  = string
  //default = "/home/ben/keys/KNX-INTERSIGHT-API-SECRET.txt"
 // default = "C:\\Users\\Ben\\iCloudDrive\\Cisco\\Keys\\KNX-INTERSIGHT-API-SECRET.txt"

}
variable "endpoint" {
  default = "https://www.intersight.com"
}
variable "IKSCluster" {
  type = string
 // default = "KXV-CL1"
}
variable "namespace" {
  type = string
  description = "Namespace to install application"
 // default = "socks"
}
