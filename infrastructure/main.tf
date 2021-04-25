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

  hibernation = false

  ebs_optimized = true

  monitoring = true

  key_name = aws_key_pair.gavanlamb.key_name

  associate_public_ip_address = true
  root_block_device {
    volume_size = "20"
    volume_type = "standard"
  }
  ephemeral_block_device {
    device_name = "/dev/sdb"
    virtual_name = "ephemeral0"
  }
//  ebs_block_device {
//    device_name = "/dev/sdh"
//    delete_on_termination = false
//    iops = 6000
//    encrypted = true
//    kms_key_id = aws_key_pair.gavanlamb.arn
//    volume_size = 300
//    volume_type = "gp3"
//  }
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
  kms_key_id = aws_key_pair.gavanlamb.arn
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_ebs_snapshot" "host" {
  volume_id = aws_volume_attachment.host.volume_id
  tags = local.tags
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
