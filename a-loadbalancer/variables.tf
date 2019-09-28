variable "pub-subnet" {
  type = list
}

variable "ip_type" {
  default = "ipv4"
  type = "string"
}

variable "alb-sg" {
}

variable "target-id" {
  type = list
}
variable "vpc-id" {}
