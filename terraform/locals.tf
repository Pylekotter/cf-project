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
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
    loadbalancer = {
      name        = "loadbalancer sg"
      description = "public access to ALB"
      ingress = {
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        https = {
          from        = 443
          to          = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        tg = {
          from        = 8000
          to          = 8000
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
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
          cidr_blocks = [local.vpc_cidr]
        }
        tg = {
          from        = 8000
          to          = 8000
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
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