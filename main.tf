module "vpc" {
  source = "./Modules/vpc"
}

 module "rds" {
   source = "./Modules/RDS"
   vpc_id = module.vpc.vpc_id
   private_subnets = module.vpc.private_subnets
   count  = 0
 }

module "IAM_Role" {
  source = "./Modules/IAM_Role"
  count  = 1
  
}

module "Security_Group" {
  source = "./Modules/Security_Group"
  count  = 1
  vpc_id = module.vpc.vpc_id
  depends_on = [ module.vpc ]

}

module "Instance" {
  source = "./Modules/Instance"
  count  = 1
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  security_group_id = module.Security_Group[0].security_group_id  
  depends_on = [
    module.IAM_Role, module.Security_Group, module.vpc
  ]
}

module "elasticsearch" {
  source = "./Modules/ElasticSearch"
  count  = 0
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  depends_on = [ module.vpc ]

}

terraform {
  backend "s3" {
    bucket         = "terrafromstatefilepoc"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
  }
}

