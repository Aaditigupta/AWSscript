terraform {
  backend "local" {
    path = "/tmp/terraform/workspace/terraform.tfstate"
  }

}

provider "aws" {
  region = "${var.aws-region}"
  access_key = "AKIA4QCSZ4BXFTTEWNZY"
  secret_key = "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"

}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "myVPC" {
    cidr_block              = "${var.myVPC-cidr}"
    enable_dns_hostnames    = true

}

resource "aws_subnet" "public_subnet-a" {
    cidr_block              = "${var.public_subnet-a-cidr}"
    vpc_id                  = "${aws_vpc.myVPC.id}"
    availability_zone       = "us-east-1b"

}
resource "aws_subnet" "public_subnet-b" {
    cidr_block              = "${var.public_subnet-b-cidr}"
    vpc_id                  = "${aws_vpc.myVPC.id}"
    availability_zone       = "us-east-1a"

}
resource "aws_subnet" "private_subnet-a" {
    cidr_block              = "${var.private_subnet-a-cidr}"
    vpc_id                  = "${aws_vpc.myVPC.id}"
    availability_zone       = "us-east-1b"

}
resource "aws_subnet" "private_subnet-b" {
    cidr_block              = "${var.private_subnet-b-cidr}"
    vpc_id                  = "${aws_vpc.myVPC.id}"
    availability_zone       = "us-east-1a"

}
resource "aws_subnet" "private_subnet-c" {
    cidr_block              = "${var.private_subnet-c-cidr}"
    vpc_id                  = "${aws_vpc.myVPC.id}"
    availability_zone       = "us-east-1b"

}
resource "aws_subnet" "private_subnet-d" {
    cidr_block              = "${var.private_subnet-d-cidr}"
    vpc_id                  = "${aws_vpc.myVPC.id}"
    availability_zone       = "us-east-1a"

}

resource "aws_internet_gateway" "my_igw" {
    vpc_id      = "${aws_vpc.myVPC.id}"


}

resource "aws_route_table" "public_RT" {
    vpc_id = "${aws_vpc.myVPC.id}"

    route {
        cidr_block  = "0.0.0.0/0"
        gateway_id  = "${aws_internet_gateway.my_igw.id}"
    }


}
resource "aws_route_table" "private_RT" {
    vpc_id = "${aws_vpc.myVPC.id}"

}
resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public_subnet-a.id}"
  route_table_id = "${aws_route_table.public_RT.id}"
}

resource "aws_route_table_association" "private" {
  subnet_id      = "${aws_subnet.private_subnet-a.id}"
  route_table_id = "${aws_route_table.private_RT.id}"
}

resource "aws_security_group" "my_sg" {
    name            = "my_sg"
    description     = "created from terraform"
    vpc_id          = "${aws_vpc.myVPC.id}"
    ingress{
        cidr_blocks = ["0.0.0.0/0"]
        protocol    = "-1"
        from_port   = "0"
        to_port     = "0"
    }
    egress{
        cidr_blocks = ["0.0.0.0/0"]
        protocol    = "-1"
        from_port   = "0"
        to_port     = "0"
    }

}
