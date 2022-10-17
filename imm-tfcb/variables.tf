# https://intersight.com/an/settings/api-keys/
## Generate API key to obtain the API key and secret key

variable "api_key" {
    description = "API key for Intersight account"
    type = string
}

variable "secretkey" {
    description = "Filename that provides secret key for Intersight API"
    type = string
}

variable "endpoint" {
    description = "Intersight API endpoint"
    type = string
    default = "https://intersight.com"
}

variable "organization" {
    type = string
    default = "default"
}

