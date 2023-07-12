module "vpc" {
  source = "./Modules/vpc"
}

module "rds" {
  source          = "./Modules/RDS"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  count           = 1
}

module "IAM_Role" {
  source = "./Modules/IAM_Role"
  count  = 1

}

module "Security_Group" {
  source     = "./Modules/Security_Group"
  count      = 1
  vpc_id     = module.vpc.vpc_id
  depends_on = [module.vpc]

}
module "NLB" {
  source          = "./Modules/NLB"
  count           = 0
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  # public_subnets    = module.vpc.public_subnets
  depends_on = [module.vpc]
}

module "apigateway" {
  source     = "./Modules/Api-Gateway"
  count      = 0
  lb_arn     = module.NLB[0].lb_arn
  depends_on = [module.NLB]

}

module "Instance" {
  source            = "./Modules/Instance"
  count             = 1
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  public_subnets    = module.vpc.public_subnets
  security_group_id = module.Security_Group[0].security_group_id
  depends_on = [
    module.IAM_Role, module.Security_Group, module.vpc
  ]
}

module "frontend" {
  source = "./Modules/frontend"
  count  = 1
}

module "elasticsearch" {
  source = "./Modules/ElasticSearch"
  count  = 1
  vpc_id = module.vpc.vpc_id
  # public_subnets = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  depends_on      = [module.vpc]

}

module "docdb" {
  source = "./Modules/DocDB"
  count  = 0
  vpc_id = module.vpc.vpc_id
  # public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  depends_on      = [module.vpc]

}

module "ECS" {
  source = "./Modules/ecs"
  count  = 0
  # vpc_id = module.vpc.vpc_id
  # public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  depends_on      = [module.vpc]

}

module "eks" {
  source = "./Modules/EKS"
  count  = 0
  vpc_id = module.vpc.vpc_id
  # public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  depends_on      = [module.vpc]

}


# terraform {
#   backend "s3" {
#     bucket         = "onchain-terraformbackend"
#     key            = "terraform.tfstate"
#     region         = "eu-west-2"
#     encrypt        = true
#   }
# }

