variable "vpccidr" {
  type    = string
  default = "192.168.0.0/16"
}
variable "pub-subnet-cidr" {
  type    = string
  default = "192.168.0.0/24"
}
variable "pvt-subnet-cidr" {
  type    = string
  default = "192.168.1.0/24"
}
variable "ami-id" {
  type    = string
  default = "ami-00f7e5c52c0f43726"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "instance_count" {
  type    = number
  default = 1
}
