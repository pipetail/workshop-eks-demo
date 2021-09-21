resource "aws_security_group" "alb" {
  name        = "alb_${var.environment}"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "alb_egress_all" {
  type      = "egress"
  to_port   = 0
  from_port = 0
  protocol  = "-1"
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_ingress_all" {
  type      = "ingress"
  to_port   = 0
  from_port = 0
  protocol  = "-1"
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  security_group_id = aws_security_group.alb.id
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.5.0"

  name = var.environment

  load_balancer_type = "application"

  vpc_id  = module.vpc.vpc_id
  subnets = slice(module.vpc.public_subnets, 0, 2)
  security_groups = [
    aws_security_group.alb.id,
  ]

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 32080
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval            = 10
        path                = "/healthz"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 5
      }
    },
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = aws_acm_certificate.wildcard.arn
      target_group_index = 0
    }
  ]
}