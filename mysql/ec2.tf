resource "aws_spot_instance_request" "spot-instance" {
  instance_type = var.MONGODB_INSTANCE_TYPE
  ami           = data.aws_ami.ami.id
  subnet_id =  data.terraform_remote_state.vpc.outputs.PRIVATE-SUBNETS_ID[0]
  vpc_security_group_ids = [aws_security_group.allow-mongodb.id]
}

resource "aws_ec2_tag" "tag" {
  resource_id = aws_spot_instance_request.spot-instance.id
  key         = "Name"
  value       = "mongobb-${var.ENV}"
}


resource "null_resource" "ansible-apply" {
  provisioner "remote-exec" {
    connection {
      host     = aws_spot_instance_request.spot-instance.private_ip
      user     = jsondecode(data.aws_secretsmanager_secret_version.latest.secret_string)["SSH_USER"]
      password = jsondecode(data.aws_secretsmanager_secret_version.latest.secret_string)["SSH_PASS"]
    }

    inline = [
      "ansible-pull -U https://github.com/smachisty92/ansible roboshop-pull.yml -e COMPONENT=mongodb -e ENV=${var.ENV}"
    ]
  }
}