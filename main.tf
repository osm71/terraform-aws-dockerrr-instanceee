data "aws_ami" "amazon-linux-2023" {
  owners = ["amazon"]
  most_recent = true
  filter {
    
    name="root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name="architecture"
    values = ["x86_64"]
  }
  filter {
    name = "owner-alias"
    values = ["amazon"]

}
filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}
resource "aws_instance" "tf-module" {
    ami = data.aws_ami.amazon-linux-2023.id
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [ aws_security_group.tf-sg.id ]
    count = var.num_of_instance
    user_data = templatefile("${abspath(path.module)}/userdata.sh", {myserver= var.server-name})
    tags = {
      Name=var.tags
    }
}

resource "aws_security_group" "tf-sg" {

name = "${var.tags}-sg"
tags = {
    Name=var.tags
}

dynamic "ingress" {
    for_each = var.docker-instance-ports
    iterator = port
    content {
      from_port = port.value
      protocol = "tcp"
      to_port = port.value
      cidr_blocks = ["0.0.0.0/0"]
    }

  
}
egress {
    from_port = 0
    protocol = -1
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
}
  
}