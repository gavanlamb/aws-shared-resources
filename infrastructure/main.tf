locals {
  tags = {
    environment = var.environment
    service = var.service
    managedBy = "Terraform"
    region = var.region
  }
}

resource "aws_instance" "host" {
  ami = var.ami
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  disable_api_termination = true

  hibernation = false

  ebs_optimized = true

  monitoring = true

//  security_groups = [
//
//  ]

  tags = local.tags
}

resource "aws_volume_attachment" "host" {
  device_name = "/dev/sdh"
  instance_id = aws_instance.host.id
  volume_id = aws_ebs_volume.host_volume.id
}

resource "aws_ebs_volume" "host" {
  availability_zone = var.availability_zone
  size = 300
  iops = 6000
  type = "gp3"
  throughput = 300
  tags = local.tags
  encrypted = true
}

//KMS

//Public subnet

//Private subnet

//Security group

//IP Address
