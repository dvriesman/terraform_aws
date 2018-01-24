

1) First of all, to run this experiment you need TerraForm.
2) Create a file named terraform.tfvars with your AWS Credentials like that:

aws_access_key = "xxxxx"
aws_secret_key = "yyyyy"

(you don't need that if you already have a ~/.aws/credentials).

3) Initialize your TerraForm

#> terraform init

4) Create your infrastructure 

#> terraform apply

5) After test it, you can destroy with

#> terraform destroy


