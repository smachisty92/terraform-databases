resource "aws_route53_record" "redis" {
  name    = "redis-${var.ENV}.${data.terraform_remote_state.vpc.outputs.INTERNAL_HOSTED_ZONE_NAME}"
  type    = "A"
  zone_id = data.terraform_remote_state.vpc.outputs.INTERNAL_HOSTED_ZONEID
  ttl = "300"
  records = [aws_spot_instance_request.spot-instance.private_ip]
}