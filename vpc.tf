

resource "aws_vpc" "VPC_Terraform" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "VPC_Terraform"
    }
}

resource "aws_default_security_group" "default" {
    vpc_id = "${aws_vpc.VPC_Terraform.id}"

    ingress {
        protocol  = "-1"
        self = "true"
        from_port = 0
        to_port   = 0
    }

    egress {
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 0
        to_port = 0
     }
}


resource "aws_internet_gateway" "VPC_Terraform" {
    vpc_id = "${aws_vpc.VPC_Terraform.id}"
}

resource "aws_subnet" "mypublicsub" {
    vpc_id = "${aws_vpc.VPC_Terraform.id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "us-east-1a"

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_subnet" "mypublicsub2" {
    vpc_id = "${aws_vpc.VPC_Terraform.id}"

    cidr_block = "${var.public_subnet2_cidr}"
    availability_zone = "us-east-1b"

    tags {
        Name = "Public Subnet 2"
    }
}

resource "aws_route_table" "mypublicsub" {
    vpc_id = "${aws_vpc.VPC_Terraform.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.VPC_Terraform.id}"
    }

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "mypublicsub" {
    subnet_id = "${aws_subnet.mypublicsub.id}"
    route_table_id = "${aws_route_table.mypublicsub.id}"
}
