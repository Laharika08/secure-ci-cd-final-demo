terraform {
  backend "s3" {
    bucket         = "bimodal-prehire35327-tf-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking-bimodal"
    encrypt        = true
  }
}

module "infra-jenkins" {
  source = "./modules/infra-jenkins"
  
  security_group_name = module.security.jenkins_sg_name
  key_pair_name       = module.security.bimodal_key_pair_name
}

module "infra-nexus" {
  source = "./modules/infra-nexus"
  
  security_group_name = module.security.nexus_sg_name
  key_pair_name       = module.security.bimodal_key_pair_name
}

module "infra-sonar" {
  source = "./modules/infra-sonar"
  
  security_group_name = module.security.sonarqube_sg_name
  key_pair_name       = module.security.bimodal_key_pair_name
}

module "state_resources" {
  source = "./modules/state_resources"
}

module "security" {
  source = "./modules/security"
}
