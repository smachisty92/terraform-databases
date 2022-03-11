resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "dummy"
  username     = jsondecode(data.aws_secretsmanager_secret_version.latest.secret_string)["RDS_USER"]
  password = jsondecode(data.aws_secretsmanager_secret_version.latest.secret_string)["RDS_PASS"]
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.mysql.name
  vpc_security_group_ids = []
}

resource "aws_db_subnet_group" "mysql" {
  name = "mysql"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE-SUBNETS_ID

  tags = {
    Name = "My Subnet groups"
  }
}

output "mysql" {
  value = aws_db_instance.default
}