output "instance_public_ip" {
    value = aws_instance.tf-module.*.public_ip
  
}

output "sg-id" {
    value = aws_security_group.tf-sg.id
  
}

output "instance_id" {

    value = aws_instance.tf-module.*.id
  
}