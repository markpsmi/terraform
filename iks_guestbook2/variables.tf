variable "apikey" {
  type =  string
}  
variable "secretkey" {
  type  = string
}
variable "endpoint" {
  default = "https://www.intersight.com"
}  
variable "redis_follower_host" {
  type =  string
}  
variable "redis_leader_host" {
  type =  string
}  
