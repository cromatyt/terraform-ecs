#######
# IAM #
#######

# Policy EC2
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ecs.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "ec2_iam_role" {
  name               = "ec2_iam_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ec2_iam_policy" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ec2_iam_agent" {
  name = "ec2_iam_agent"
  role = aws_iam_role.ec2_iam_role.name
}

resource "aws_iam_role_policy" "ec2_service_role_policy" {
  name   = "EC2_ServiceRolePolicy"
  policy = data.aws_iam_policy_document.ec2_iam_for_stoptak_script.json
  role   = aws_iam_role.ec2_iam_role.id
}

data "aws_iam_policy_document" "ec2_iam_for_stoptak_script" {
  statement {
    effect  = "Allow"
    actions = [
      "ecs:ListServices",
      "ecs:UpdateService",
      "ecs:ListTasks",
      "ecs:DescribeServices",
      "ecs:StopTask",
			"ecs:DeleteService"
    ]
    resources = ["*"]
  }
}

# Policy ECS
data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ecs.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "ecs_iam_role" {
  name               = "ecs_iam_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

# data "aws_iam_policy_document" "ecs_service_role_policy" {
#   statement {
#     effect  = "Allow"
#     actions = [
#       "ec2:AuthorizeSecurityGroupIngress",
#       "ec2:Describe*",
#       "ec2:DescribeTags",
#       "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
#       "elasticloadbalancing:DeregisterTargets",
#       "elasticloadbalancing:Describe*",
#       "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
#       "elasticloadbalancing:RegisterTargets",
#       "logs:CreateLogGroup",
#       "logs:CreateLogStream",
#       "logs:DescribeLogStreams",
#       "logs:PutSubscriptionFilter",
#       "logs:PutLogEvents"
#     ]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_role_policy" "ecs_iam_role_policy" {
#   name   = "ecs_iam_policy"
#   policy = data.aws_iam_policy_document.ecs_service_role_policy.json
#   role   = aws_iam_role.ecs_iam_role.id
# }

resource "aws_iam_role_policy_attachment" "ecs_iam_policy_attach" {
  role       = aws_iam_role.ecs_iam_role.name
  # policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECSLimited"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

# resource "aws_iam_role_policy_attachment" "ecs_iam_policy_lb" {
#   role       = aws_iam_role.ecs_iam_role.name
#   policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingReadOnly"
# }