# Terraform AWS

This is my simple project to test terraform with some AWS features, like create VPC, Bucket, Website with buckets, Fargate and autoscale.

- First of all, to run this experiment you need TerraForm.
- Create a file named terraform.tfvars with your AWS Credentials like that:

aws_access_key = "xxxxx"

aws_secret_key = "yyyyy"


(you don't need that if you already have a ~/.aws/credentials).

- Initialize your TerraForm

**$> terraform init**

- Create your infrastructure 

**$> terraform apply**

- After test it, you can destroy with

**$>terraform destroy**


