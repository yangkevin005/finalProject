#Provider block
provider "aws" {
  region = var.region
}

#VPC resource block
resource "aws_vpc" "group4-terraform-vpc"{
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "group4-terraform-vpc"
  }
}

#Public subnet resource block
resource "aws_subnet" "group4-terraform-public-subnet" {
  vpc_id = aws_vpc.group4-terraform-vpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "group4-terraform-public-subnet"
  }
}

#Private subnet resource block
resource "aws_subnet" "group4-terraform-private-subnet" {
  vpc_id = aws_vpc.group4-terraform-vpc.id
  cidr_block = var.private_subnet_cidr
  availability_zone = var.availability_zone
  tags = {
    Name = "group4-terraform-private-subnet"
  }
}

#Internet Gateway resource block for public subnet
resource "aws_internet_gateway" "group4-terraform-igw" {
  vpc_id = aws_vpc.group4-terraform-vpc.id
  tags = {
    Name = "group4-terraform-igw"
  }
}

#Route table for public subnet
resource "aws_route_table" "group4-terraform-public-route-table" {
  vpc_id = aws_vpc.group4-terraform-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.group4-terraform-igw.id
  }
  tags = {
    Name = "group4-terraform-public-route-table"
  }
}

#Route table association for public subnet
resource "aws_route_table_association" "group4-terraform-public-subnet-association" {
  subnet_id = aws_subnet.group4-terraform-public-subnet.id
  route_table_id = aws_route_table.group4-terraform-public-route-table.id
}

#route table for private subnet
resource "aws_route_table" "group4-terraform-private-route-table" {
  vpc_id = aws_vpc.group4-terraform-vpc.id
  tags = {
    Name = "group4-terraform-private-route-table"
  }
}

#Route table association for private subnet
resource "aws_route_table_association" "group4-terraform-private-subnet-association" {
  subnet_id = aws_subnet.group4-terraform-private-subnet.id
  route_table_id = aws_route_table.group4-terraform-private-route-table.id
}