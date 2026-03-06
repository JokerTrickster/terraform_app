# IAM 역할 생성
resource "aws_iam_role" "ec2_role" {
  count = var.enabled ? 1 : 0

  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-ec2-role"
  }
}

# EC2 정책 생성
resource "aws_iam_policy" "ec2_policy" {
  count = var.enabled ? 1 : 0

  name        = "${var.project_name}-ec2-policy"
  description = "Policy for EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeTags",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchDeleteImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [
          "arn:aws:s3:::board-game-app/*",
          "arn:aws:s3:::board-game-app"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObjectVersion",
          "s3:PutObjectTagging",
          "s3:GetObjectTagging",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetBucketCORS",
          "s3:PutBucketCORS"
        ]
        Resource = [
          "arn:aws:s3:::joker-cloud-repository-dev/*",
          "arn:aws:s3:::joker-cloud-repository-dev"
        ]
      }
    ]
  })
}

# 정책을 역할에 연결
resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  count = var.enabled ? 1 : 0

  role       = aws_iam_role.ec2_role[0].name
  policy_arn = aws_iam_policy.ec2_policy[0].arn
}

# 인스턴스 프로필 생성
resource "aws_iam_instance_profile" "ec2_profile" {
  count = var.enabled ? 1 : 0

  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role[0].name
}
