resource "aws_route53_record" "mysql" {
  name    = "mysql-${var.ENV}.${data.terraform_remote_state.vpc.outputs.INTERNAL_HOSTED_ZONE_NAME}"
  type    = "CNAME"
  zone_id = data.terraform_remote_state.vpc.outputs.INTERNAL_HOSTED_ZONEID
  ttl = "300"
  records = [aws_db_instance.default.address]
}