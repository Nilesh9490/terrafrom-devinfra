module "vpc" {
  source = "./Modules/vpc"
}

module "rds" {
  source          = "./Modules/RDS"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  count           = 0
}

module "IAM_Role" {
  source = "./Modules/IAM_Role"
  count  = 0

}

module "Security_Group" {
  source     = "./Modules/Security_Group"
  count      = 1
  vpc_id     = module.vpc.vpc_id
  depends_on = [module.vpc]

}

module "Instance" {
  source            = "./Modules/Instance"
  count             = 0
  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.vpc.public_subnets
  security_group_id = module.Security_Group[0].security_group_id
  depends_on = [
    module.IAM_Role, module.Security_Group, module.vpc
  ]
}

module "elasticsearch" {
  source         = "./Modules/ElasticSearch"
  count          = 0
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  depends_on     = [module.vpc]

}

module "docdb" {
  source          = "./Modules/DocDB"
  count           = 0
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  depends_on      = [module.vpc]

}

module "eks" {
  source          = "./Modules/EKS"
  count           = 1
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  depends_on      = [module.vpc]

}
module "s3" {
  source                  = "./Modules/s3"
  count                   = 0
}

module "cloudfront" {
  source                                   = "./Modules/cloudfront"
  count                                    = 0
  aws_s3_bucket_name = module.s3[0].aws_s3_bucket_name
#   origin_path                              = var.origin_path
#   default_root_object                      = var.default_root_object
#   cloudfront_description                   = var.cloudfront_description
  aws_cloudfront_origin_access_identity_id = module.s3[0].aws_cloudfront_origin_access_identity_id
  aws_s3_bucket_regional_domain_name       = module.s3[0].aws_s3_bucket_regional_domain_name

  depends_on = [module.s3]
}


# terraform {
#   backend "s3" {
#     bucket         = "terrafromstatefilepoc"
#     key            = "terraform.tfstate"
#     region         = "eu-west-2"
#     encrypt        = true
#   }
# }

