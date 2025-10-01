# IAM User for GitHub Actions Deployment
resource "aws_iam_user" "github_actions_deploy" {
  name = "${var.project_name}-github-actions-deploy"

  tags = {
    Name        = "${var.project_name}-github-actions-deploy"
    Environment = var.environment
    Project     = var.project_name
    Purpose     = "GitHub Actions deployment automation"
  }
}

# IAM Policy for GitHub Actions
resource "aws_iam_policy" "github_actions_deploy" {
  name        = "${var.project_name}-github-actions-deploy-policy"
  description = "Policy for GitHub Actions to deploy to S3 and invalidate CloudFront"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3BucketAccess"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = aws_s3_bucket.workflow_hosting.arn
      },
      {
        Sid    = "S3ObjectAccess"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.workflow_hosting.arn}/*"
      },
      {
        Sid    = "CloudFrontInvalidation"
        Effect = "Allow"
        Action = [
          "cloudfront:CreateInvalidation",
          "cloudfront:GetInvalidation",
          "cloudfront:ListInvalidations"
        ]
        Resource = aws_cloudfront_distribution.workflow_hosting.arn
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-github-actions-policy"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Attach Policy to User
resource "aws_iam_user_policy_attachment" "github_actions_deploy" {
  user       = aws_iam_user.github_actions_deploy.name
  policy_arn = aws_iam_policy.github_actions_deploy.arn
}

# IAM Access Key for GitHub Actions (create manually or via separate process)
# Note: Access keys should be created manually and stored in GitHub Secrets
# Uncomment below if you want Terraform to create access keys (not recommended for production)
# resource "aws_iam_access_key" "github_actions_deploy" {
#   user = aws_iam_user.github_actions_deploy.name
# }
