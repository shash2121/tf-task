resource "aws_iam_role" "iam_access_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_policy" "policy" {
  name        = "iam_policy"
  description = "An IAM policy"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "*","eks:*"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })

policy = var.ec2_policy

}

resource "aws_iam_policy_attachment" "iam-attach" {
  name       = "policy-attachment"
  roles      = [aws_iam_role.iam_access_role.name]
  policy_arn = aws_iam_policy.policy.arn
}
# resource "aws_iam_role_policy_attachment" "ec2SSM" {
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
#  role    = aws_iam_role.iam_access_role.name
# }

resource "aws_iam_role_policy_attachment" "SSMInstanceCore" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
 role    = aws_iam_role.iam_access_role.name
}

resource "aws_iam_instance_profile" "iam-profile" {
  name = "instance-profile"
  role = aws_iam_role.iam_access_role.name
}

