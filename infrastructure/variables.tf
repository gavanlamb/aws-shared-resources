variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "service" {
  type = string
  default = "shared resources"
}

variable "ami"{
  type = string
}

variable "instance_type"{
  type = string
}

variable "availability_zone" {
  type = string
}

variable "public_key" {
  type = string
}
