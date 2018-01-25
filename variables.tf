variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.30.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.30.0.0/24"
}
variable "public_subnet2_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.30.10.0/24"
}
variable "bucket_name" {
    default = "dvriesman.website.bucket"
}
