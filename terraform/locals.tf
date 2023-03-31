locals {
  vpc_cidr = "10.1.0.0/16"
}

locals {
  public_cidrs = ["10.1.0.0/24", "10.1.1.0/24"]
  wp_sn_cidrs  = ["10.1.2.0/24", "10.1.3.0/24"]
  db_sn_cidrs  = ["10.1.4.0/24", "10.1.5.0/24"]
}

locals {
  security_groups = {
    bastion = {
      name        = "bastion sg"
      description = "allows access to the bastion"
      ingress = {
        rdp = {
          from        = 3389
          to          = 3389
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
    wpserver = {
      name        = "wpserver sg"
      description = "ssh access to app servers"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
    rds = {
      name        = "rds sg"
      description = "rds access"
      ingress = {
        mysql = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr]
        }
      }
    }
  }
}