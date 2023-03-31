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

resource "aws_instance" "bastion" {
  ami           = var.bastion_ami
  instance_type = var.bastion_instance_type
  subnet_id     = var.public_subnets[0]
  vpc_security_group_ids =  [var.bastion_sg]

  tags = {
    Name = "bastion1"
  }
}

resource "aws_instance" "wpservers" {
  count         = var.wpserver_count
  ami           = var.wpserver_ami
  instance_type = var.wpserver_instance_type
  subnet_id     = var.wp_subnets[count.index]
  vpc_security_group_ids = [var.wpserver_sg]

  tags = {
    Name = "wpserver${count.index + 1}"
  }
}