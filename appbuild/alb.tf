module "alb" {
    depends_on = [ module.s3 ]
    source = "../modules/alb"
    alb_name = var.alb.alb_name
    internal = var.alb.internal
    subnets_id = var.alb.subnets_id
    alb_sg_ingress = var.alb.alb_sg_ingress
    id_vpc = var.alb.vpc_id
}

module "target_group" {
    depends_on = [ module.alb ]
    source = "../modules/target-group"
    application_name = var.tg.application_name
    application_port = var.tg.application_port
    application_health_check_target = var.tg.application_health_check_target
    vpc_id = var.tg.vpc_id
    #instance_id = var.tg.instance_id
}

module "listener_rule" {
    source = "../modules/listener-rule"
    listener_arn = module.alb.alb_http_listener_arn
    target_group_arn = module.target_group.target_group_arn
    listener_type = var.listener_rule.listener_type
    path_pattern = var.listener_rule.path_pattern
    host_header = var.listener_rule.host_header
}
