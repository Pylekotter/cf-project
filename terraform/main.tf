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
  db_subnet_group = "true"
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
  public_key_path        = "/home/kpotter/.ssh/cfkey.pub"
  key_name               = "cfkey"
  public_subnets         = module.networking.public_subnet
  wp_subnets             = module.networking.wp_subnet
  bastion_sg             = module.networking.bastion_sg
  wpserver_sg            = module.networking.wpserver_sg
  target_group_arn       = module.loadbalancer.target_group_arn
}

module "loadbalancer" {
  source                  = "./loadbalancer"
  loadbalancer_sg         = module.networking.loadbalancer_sg
  public_subnet           = module.networking.public_subnet
  tg_port                 = 8000
  tg_protocol             = "HTTP"
  vpc_id                  = module.networking.vpc_id
  elb_healthy_threshold   = 2
  elb_unhealthy_threshold = 2
  elb_timeout             = 3
  elb_interval            = 30
  listener_port           = 8000
  listener_protocol       = "HTTP"
}

module "database" {
  source               = "./database"
  db_engine_version    = "14.6"
  db_instance_class    = "db.t3.micro"
  dbname               = var.dbname
  dbuser               = var.dbuser
  dbpassword           = var.dbpassword
  db_identifier        = "rds1"
  skip_db_snapshot     = true
  db_subnet_group_name = module.networking.db_subnet_group_name[0]
  rds_sg               = [module.networking.rds_sg]
}

module "route53" {
  source      = "./route53"
  record_name = "clientapp.com"
  alias_name  = module.loadbalancer.alias_name
  lb_zone_id  = module.loadbalancer.lb_zone_id
}

module "cloudwatch" {
  source          = "./cloudwatch"
  cw_target_group = module.loadbalancer.target_group_arn
  cw_loadbalancer = module.loadbalancer.wp_lb
}