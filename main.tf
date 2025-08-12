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

#Security group for public subnet
resource "aws_security_group" "group4-terraform-public-sg" {
  vpc_id = aws_vpc.group4-terraform-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "group4-terraform-public-sg"
  }
}

#SSM IAM
resource "aws_iam_role" "group4-ssm-role" {
  name = "group4-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "group4-ssm-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.group4-ssm-role.name
}

resource "aws_iam_instance_profile" "group4-ssm-instance-profile" {
  name = "group4-ssm-instance-profile"
  role = aws_iam_role.group4-ssm-role.name
}

#Amazon Linux EC2
resource "aws_instance" "group4-al23-ec2" {
  ami = var.linux_ami
  instance_type = var.linux_instance_type
  subnet_id = aws_subnet.group4-terraform-public-subnet.id
  security_groups = [aws_security_group.group4-terraform-public-sg.name]
  iam_instance_profile = aws_iam_instance_profile.group4-ssm-instance-profile.name
  tags = {
    Name = "group4-al23-ec2"
  }
}


#Windows 10 EC2
resource "aws_instance" "group4-windows-10-ec2" {
  ami = var.windows_ami
  instance_type = var.windows_instance_type
  subnet_id = aws_subnet.group4-terraform-public-subnet.id
  security_groups = [aws_security_group.group4-terraform-public-sg.name]
  iam_instance_profile = aws_iam_instance_profile.group4-ssm-instance-profile.name
  tags = {
    Name = "group4-windows-10-ec2"
  }
}
