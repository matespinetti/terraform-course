module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.17.0"

  load_balancer_type = "application"
  name = local.alb_name
  #Network configuration
  vpc_id = module.vpc.vpc_id
  subnets = local.alb_subnets

  #Security configuration
  security_groups = [module.alb_sg.security_group_id]


  #Listeners
  listeners = {
    #Listener-1: HTTP Listener
    my-http-listener = {
        port = 80
        protocol = "HTTP"
        forward = {
            target_group_key = "app1_tg"
        }
    } # End of my-http-listener

  } # End of listeners

  #Target Groups
  target_groups = {
    #Target Group-1: App1 Target Group
    app1_tg = {
        name_prefix = "app1-"
        protocol = "HTTP"
        port = 80
        target_type = "instance"
        deregistration_delay = "30"
        load_balancing_algorithm_type = "round_robin"
        health_check = {
            enabled = true
            interval = 30
            timeout = 10
            healthy_threshold = 2
            unhealthy_threshold = 2
            path = "/app1/index.html"
            port = "traffic-port"
            protocol = "HTTP"
        }
        protocol_version = "HTTP1"
        create_attachment = false

    } # End of app1_tg

  }


  tags = local.common_tags
  enable_deletion_protection = false
}

resource "aws_lb_target_group_attachment" "app1_tg_attachment" {
    for_each = {for key, instance in module.ec2_private_app_server : key => instance}
    target_group_arn = module.alb.target_groups["app1_tg"].arn
    target_id = each.value.id
    port = 80

}