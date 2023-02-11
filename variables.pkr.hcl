variable "username" {
  type = string
}

variable "ipv4_gateway" {
  type = string
}

variable "ipv4_dns_server" {
  type = string
}

variable "images" {
  type = map(map(string))
}
