locals {
  eks_userdata_main = <<EOT
[settings.kubernetes.node-labels]
nodepool = "main"
"bottlerocket.aws/updater-interface-version" = "2.0.0"
EOT
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_ami" "bottlerocket_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["bottlerocket-aws-k8s-${var.k8s_version}-x86_64-*"]
  }
}

data "aws_iam_policy" "ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.18.0"

  cluster_name    = var.environment
  cluster_version = var.k8s_version
  subnets         = slice(module.vpc.private_subnets, 0, 2)
  vpc_id          = module.vpc.vpc_id

  worker_groups_launch_template = [
    {
      name                    = "${var.environment}_main"
      instance_type           = "t3.small"
      override_instance_types = ["t3.small", "t3a.small"]
      ami_id                  = data.aws_ami.bottlerocket_ami.id

      asg_max_size         = 3
      asg_min_size         = 1
      asg_desired_capacity = 2

      userdata_template_file = "${path.module}/assets/userdata.toml"
      userdata_template_extra_args = {
        enable_admin_container   = true
        enable_control_container = true
        aws_region               = var.region
      }
      additional_userdata = local.eks_userdata_main

      target_group_arns = module.alb.target_group_arns
    }
  ]
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = module.eks.worker_iam_role_name
  policy_arn = data.aws_iam_policy.ssm.arn
}

resource "aws_security_group_rule" "eks_allow_alb_ingress" {
  type                     = "ingress"
  to_port                  = 32080
  from_port                = 32080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = module.eks.worker_security_group_id
}