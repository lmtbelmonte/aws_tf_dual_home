variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "us-east-1"
}

variable "region-worker" {
  type    = string
  default = "us-west-2"
}

variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "workers-count" {
  type    = number
  default = 1
}

variable "instance-type" {
  type    = string
  default = "t3.micro"
}

variable "webserver-port" {
  type    = number
  default = 8080
}

variable "dns-name" {
  type    = string
  default = "cloud-architecture.es."
}

variable "cluster_id" {
  type    = string
  default = "dualhome"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_az1" {
  type    = list
  default = ["10.0.0.0/21", "10.0.8.0/21"]
}

variable "subnet_az2" {
  type    = list
  default = ["10.0.64.0/21", "10.0.72.0/21", "10.0.80.0/21"]
}
