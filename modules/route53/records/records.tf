#DNS Records
resource "aws_route53_record" "record" {
  #zone_id = var.zone_type == "public" ? aws_route53_zone.public.zone_id : aws_route53_zone.private.zone_id  
  zone_id = var.zone_id
  name    = "${var.subdomain}.${var.domain}"
  type    = var.record_type
  ttl     = var.ttl
  records = var.records
}