# --- root/main.tf ---

module "networking" {
  source          = "./networking"
  vpc_cidr        = local.vpc_cidr
  public_sn_count = 2
  wp_sn_count     = 2
  db_sn_count     = 2
  public_cidrs    = local.public_cidrs
  wp_sn_cidrs     = local.wp_sn_cidrs
  db_sn_cidrs     = local.db_sn_cidrs
  security_groups = local.security_groups
}

module "compute" {
  source                 = "./compute"
  bastion_count          = 1
  wpserver_count         = 2
  bastion_ami            = "ami-00719b15124c74012" # windows 2019
  wpserver_ami           = "ami-0dda7e535b65b6469" # redhat linux
  bastion_instance_type  = "t3a.medium"
  wpserver_instance_type = "t3a.micro"
  bastion_vol_size       = "50"
  wpserver_vol_size      = "20"
  public_subnets         = module.networking.public_subnet
  wp_subnets             = module.networking.wp_subnet
  bastion_sg             = module.networking.bastion_sg
  wpserver_sg            = module.networking.wpserver_sg

}