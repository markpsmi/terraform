variable "apikey" {
  type =  string
}  
variable "secretkey" {
  type  = string
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
