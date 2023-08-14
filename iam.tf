#######
# IAM #
#######

# EC2
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


# ECS
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

resource "aws_iam_role_policy_attachment" "ecs_iam_policy" {
  role       = aws_iam_role.ecs_iam_role.name
  # policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECSLimited"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

# resource "aws_iam_role_policy_attachment" "ecs_iam_policy_lb" {
#   role       = aws_iam_role.ecs_iam_role.name
#   policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingReadOnly"
# }