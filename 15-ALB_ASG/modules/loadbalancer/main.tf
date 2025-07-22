module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.17.0"

  load_balancer_type = "application"
  name = var.alb_name
  
  # Network configuration
  vpc_id = var.vpc_id
  subnets = var.alb_subnets

  # Security configuration
  security_groups = [var.alb_sg_id]

  # Listeners
  listeners = {
    # Listener-1: HTTP Listener
    my-http-https-redirect-listener = {
      port = 80
      protocol = "HTTP"
      redirect = {
        port = 443
        protocol = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    
    # Listener-2: HTTPS Listener
    my-https-listener = {
      port = 443
      protocol = "HTTPS"
      ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
      certificate_arn = var.certificate_arn

      # Fixed Response for Root URL
      fixed_response = {
        content_type = "text/plain"
        message_body = "Fixed Static Response"
        status_code = "200"
      }

      # Rules
      rules = {
       
        

        # Rule-1: Forward to Spring Boot App
        my-spring-boot-app-rule = {
          priority = 10
          actions = [
            {
              type = "forward"
              target_group_key = "spring_boot_app_tg"
            }
          ]
          conditions = [
            {
              path_pattern = {
                values = ["/*"]
              }
            }
          ]
        } # End of Spring Boot App Rule
      } # End of Rules
    } # End of HTTPS Listener
  } # End of Listeners

  # Target Groups
  target_groups = {
    spring_boot_app_tg = {
      name_prefix = "sbtg-"
      protocol = "HTTP"
      port = 8080
      target_type = "instance"
      deregistration_delay = "30"
      load_balancing_algorithm_type = "round_robin"
      
      health_check = {
        enabled = true
        interval = 30
        timeout = 10
        healthy_threshold = 2
        unhealthy_threshold = 2
        path = "/login"
        port = "traffic-port"
      }
      protocol_version = "HTTP1"
      create_attachment = false
    } # End of Spring Boot App Target Group
  }

  tags = var.common_tags
  enable_deletion_protection = false
}





