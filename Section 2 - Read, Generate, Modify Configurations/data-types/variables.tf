variable "usernumber" {
  type = number
  default = "11111"
}

variable "elb_name" {
  type = string
  default = "derpyloadbalancer"
}

variable "az" {
  type = list
  default = ["ap-southeast-2a", "ap-southeast-2c"]
}

variable "timeout" {
  type = number
  default = "200"
}