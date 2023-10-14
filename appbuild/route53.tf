module "route_53" {
  source = "../modules/route53/zones"
  public_zone_name = var.route53.public_zone_name
  private_zone_name = var.route53.private_zone_name
  vpc_id = var.route53.vpc_id
}

module "r53_record" {
    depends_on = [ module.route_53 ]
  source = "../modules/route53/records"
  zone_id = var.r53_record.zone_type == "public" ? module.route_53.public_zone_id : module.route_53.private_zone_id 
  subdomain = var.r53_record.subdomain
  domain = var.r53_record.domain
  record_type = var.r53_record.record_type
  ttl = var.r53_record.ttl
  records = var.r53_record.records #Value of the record that is to be created
}