#######
# IAM #
#######

data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      #identifiers = ["ecs-tasks.amazonaws.com"]
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "ecs_iam_role" {
  name               = "ecs_iam_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_iam_policy" {
  role       = aws_iam_role.ecs_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_instance_profile" "ecs_iam_agent" {
  name = "ecs_iam_agent"
  role = aws_iam_role.ecs_iam_role.name
}
