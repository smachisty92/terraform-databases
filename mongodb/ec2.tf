resource "aws_spot_instance_request" "spot-instance" {
  instance_type = var.MONGODB_INSTANCE_TYPE
  ami           = data.aws_ami.ami.id
  subnet_id = element(data.terraform_remote_state.vpc.outputs.PRIVATE-SUBNETS_ID,count.index)
  vpc_security_group_ids = [aws_security_group.allow-mongodb.id]
}

resource "aws_ec2_tag" "tag" {
  resource_id = aws_spot_instance_request.spot-instance.id
  key         = "Name"
  value       = "mongobb-${var.ENV}"
}