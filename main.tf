#This terraform code is to fetch the right organization
data "aws_caller_identity" "current_identity" {}

locals {
  aws_account_id  = data.aws_caller_identity.current_identity.account_id
#  resource_prefix = "${var.project}-${var.env_prefix}"
}

#This Terraform Code Deploys Basic VPC Infra.
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}


terraform {
  required_version = ">= 0.14.10" #Forcing which version of Terraform needs to be used
  required_providers{
    aws = {
      version = ">= 3.0.0" #Forcing which version of plugin needs to be used.
      source = "hashicorp/aws"
    }
  }
}



#resource "aws_s3_bucket" "mercury-prod" {
#  bucket = "mercury-prod"
#  acl = "private"
#
#versioning {
#enabled = true
#}
#
#tags ={
#name = "mercury-prod-bucket"
#environment = "prod"
# }
#}



#terraform {
#   backend "s3" {
#   bucket = "mercury-prod"
#   key = "mercury-s3.tfstate"
#   region = "us-east-1"
#
#
#   dynamodb_table = "mercury-lock-state"
#   encrypt = true
#    
# }
#}

resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags = {
        Name = "${var.vpc_name}"
	Owner = "Aravind"
	environment = "${var.environment}"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
	tags = {
        Name = "${var.IGW_name}"
    }
}

resource "aws_subnet" "subnet-private" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "us-east-1a"

    tags = {
        Name = "${var.private_subnet_name}"
    }
}

resource "aws_route_table" "terraform-private" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags = {
        Name = "${var.Main_Routing_Table}"
    }
}

resource "aws_route_table_association" "terraform-private" {
    subnet_id = "${aws_subnet.subnet-private.id}"
    route_table_id = "${aws_route_table.terraform-private.id}"
}

resource "aws_security_group" "allow_all" {
  name        = "Mercury-allow-custom-ports"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 3389 
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["172.30.110.0/24"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }
}



# data "aws_ami" "my_ami" {
#      most_recent      = true
#      #name_regex       = "^mavrick"
#      owners           = ["721834156908"]
# }


# resource "aws_instance" "web-1" {
#     ami = var.imagename
#     #ami = "ami-0d857ff0f5fc4e03b"
#     #ami = "${data.aws_ami.my_ami.id}"
#     availability_zone = "us-east-1a"
#     instance_type = "t2.micro"
#     key_name = "LaptopKey"
#     subnet_id = "${aws_subnet.subnet1-public.id}"
#     vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
#     associate_public_ip_address = true	
#     tags = {
#         Name = "Server-1"
#         Env = "Prod"
#         Owner = "Sree"
# 	CostCenter = "ABCD"
#     }
# }

##output "ami_id" {
#  value = "${data.aws_ami.my_ami.id}"
#}
#!/bin/bash
# echo "Listing the files in the repo."
# ls -al
# echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
# echo "Running Packer Now...!!"
# packer build -var=aws_access_key=AAAAAAAAAAAAAAAAAA -var=aws_secret_key=BBBBBBBBBBBBB packer.json
#packer validate --var-file creds.json packer.json
#packer build --var-file creds.json packer.json
#packer.exe build --var-file creds.json -var=aws_access_key=AAAAAAAAAAAAAAAAAA -var=aws_secret_key=BBBBBBBBBBBBB packer.json
# echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
# echo "Running Terraform Now...!!"
# terraform init
# terraform apply --var-file terraform.tfvars -var="aws_access_key=AAAAAAAAAAAAAAAAAA" -var="aws_secret_key=BBBBBBBBBBBBB" --auto-approve
#https://discuss.devopscube.com/t/how-to-get-the-ami-id-after-a-packer-build/36
