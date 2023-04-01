# --- compute/main.tf ---

# --- bastion elastic IP ---

resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id
  vpc      = true
}

# --- ec2 instances ----

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion_eip.id
}

resource "aws_key_pair" "cf_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "bastion" {
  ami                    = var.bastion_ami
  instance_type          = var.bastion_instance_type
  subnet_id              = var.public_subnets[0]
  vpc_security_group_ids = [var.bastion_sg]
  key_name               = aws_key_pair.cf_auth.key_name

  tags = {
    Name = "bastion1"
  }
}

# resource "aws_instance" "wpservers" {
#   count                  = var.wpserver_count
#   ami                    = var.wpserver_ami
#   instance_type          = var.wpserver_instance_type
#   subnet_id              = var.wp_subnets[count.index]
#   vpc_security_group_ids = [var.wpserver_sg]

#   tags = {
#     Name = "wpserver${count.index + 1}"
#   }
# }

resource "aws_launch_configuration" "wp_lc" {
  name_prefix     = "wp_lc-"
  image_id        = var.wpserver_ami
  instance_type   = var.wpserver_instance_type
  security_groups = [var.wpserver_sg]
  key_name        = aws_key_pair.cf_auth.key_name

  root_block_device {
    volume_size = var.wpserver_vol_size
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "wp-asg" {
  name                 = "wpserver-asg"
  vpc_zone_identifier  = var.wp_subnets
  launch_configuration = aws_launch_configuration.wp_lc.name
  target_group_arns    = [var.target_group_arn]
  desired_capacity     = 2
  max_size             = 2
  min_size             = 2

  tag {
    key                 = "Name"
    value               = "wpserver"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}