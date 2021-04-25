locals {
  tags = {
    environment = var.environment
    service = var.service
    managedBy = "Terraform"
    region = var.region
  }
}

resource "aws_key_pair" "gavanlamb" {
  key_name   = "gavanlamb"
  public_key = var.public_key
  tags = local.tags
}

resource "aws_instance" "host" {
  ami = var.ami

  instance_type = var.instance_type
  availability_zone = var.availability_zone
  disable_api_termination = true

  hibernation = falsePEDPE

  ebs_optimized = true

  monitoring = true

  key_name = aws_key_pair.gavanlamb.key_name

  associate_public_ip_address = true

  ephemeral_block_device {
    device_name = "/dev/nvme0n1"
    virtual_name = "ephemeral0"
    no_device = false
  }

  tags = local.tags
}

resource "aws_volume_attachment" "host" {
  device_name = "/dev/sdh"
  instance_id = aws_instance.host.id
  volume_id = aws_ebs_volume.host.id
}
resource "aws_ebs_volume" "host" {
  availability_zone = var.availability_zone
  size = 300
  iops = 6000
  type = "gp3"
  throughput = 300
  tags = local.tags
  encrypted = true
  kms_key_id = aws_key_pair.gavanlamb.id
  lifecycle {
    prevent_destroy = true
  }
}

//resource "aws_eip" "host" {
//  vpc = ""
//  instance = aws_instance.host.id
//}
//resource "aws_eip_association" "host" {
//  
//}
//
//resource "aws_ep" "h" {
//  
//}
//
////
//resource "aws_vpc" "host" {
//  cidr_block = ""
//}
//resource "aws_subnet" "host" {
//  cidr_block = ""
//  vpc_id = aws_vpc.host.id
//}


//Public subnet

//Private subnet

//Security group

//IP Address
