module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  name = var.environment
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true

  enable_dns_support   = true
  enable_dns_hostnames = true
}

data "aws_iam_policy_document" "allow_all_endpoint_policy" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_security_group" "vpc_endpoints_all" {
  name        = "vpc_endpoints_all_${var.environment}"
  description = "Allow access to VPC endpoints"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "vpc_endpoints_all_egress_all" {
  type      = "egress"
  to_port   = 0
  from_port = 0
  protocol  = "-1"
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  security_group_id = aws_security_group.vpc_endpoints_all.id
}

resource "aws_security_group_rule" "vpc_endpoints_all_ingress_all" {
  type      = "ingress"
  to_port   = 0
  from_port = 0
  protocol  = "-1"
  cidr_blocks = [
    module.vpc.vpc_cidr_block,
  ]
  security_group_id = aws_security_group.vpc_endpoints_all.id
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "3.7.0"

  vpc_id = module.vpc.vpc_id
  security_group_ids = [
    aws_security_group.vpc_endpoints_all.id,
  ]

  endpoints = {
    s3 = {
      service = "s3"
      tags = {
        Name = "s3-vpc-endpoint-${var.environment}"
      }
    },

    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      policy              = data.aws_iam_policy_document.allow_all_endpoint_policy.json
    },

    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      policy              = data.aws_iam_policy_document.allow_all_endpoint_policy.json
    },
  }
}