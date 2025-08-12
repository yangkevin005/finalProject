variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/24"
}

variable "public_subnet_cidr" {
  default = "10.0.0.0/28"
}

variable "private_subnet_cidr" {
  default = "10.0.0.128/28"
}

variable "availability_zone" {
  default = "us-east-1a"
}

variable "linux_instance_type" {
  default = "t2.micro"
}

variable "windows_instance_type" {
  default = "t2.micro"
}

variable "linux_ami" {
  default = "ami-084a7d336e816906b"  
}

variable "windows_ami" {
  default = "ami-0c9fb5d338f1eec43"   
}