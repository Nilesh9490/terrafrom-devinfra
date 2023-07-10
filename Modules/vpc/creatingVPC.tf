module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${terraform.workspace}-vpc"
  cidr = var.cidr_value

  azs              = var.az_names
  public_subnets   = var.public_subnet_values
  private_subnets  = var.private_subnet_values
  database_subnets = var.database_subnet_values

  # Setup NAT gateway in each AZ.
  enable_nat_gateway     = false  
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false

  tags = {
    Projectname   = "${terraform.workspace}-vpc"
    Terraform     = "true"
    Environment   = terraform.workspace
    ProvisionedBy = "Systango DevOps"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}
