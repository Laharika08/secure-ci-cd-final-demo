provider "aws" {
  region = "eu-west-2" 
}


# terraform {
#   backend "s3" {
#     bucket  = "coderview-dev-s3-bucket"
#     key     = "terraform.tfstate"
#     region  = "eu-west-2"
#     encrypt = true
#     # assume_role = {
#       role_arn = "arn:aws:iam::438096352377:role/shared-dev_tfsate_CrossAccount_Role"
#     # }
#   }
# }