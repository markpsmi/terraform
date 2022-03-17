variable "apikey" {
  type =  string
  default = "6116d77a7564612d33dc6596/6116d77a7564612d33dc659a/620bce187564612d33b4429a"
}  
variable "secretkey" {
  type  = string
  default = "/home/ben/keys/KNX-INTERSIGHT-API-SECRET.txt"

}
variable "endpoint" {
  default = "https://www.intersight.com"
}
variable "EKSClusterName" {
  type = string
  description = "EKS Cluster Name"
}
variable "AWSRegion" {
  type = string
  description = "AWS Region of EKS cluster"
}
