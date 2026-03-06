# Workflow Hosting Module

S3 static website hosting module for React application deployment.

## Architecture

```
React App (build/)
      ↓
S3 Bucket (jokertrickster-workflow)
      ↓
User Browser
```

## Features

- **S3 Static Website Hosting**: Configured for SPA (Single Page Application) routing
- **IAM User for Deployment**: Least-privilege access for GitHub Actions

## Usage

### Basic Configuration

```hcl
module "workflow_hosting" {
  source = "./modules/workflow-hosting"

  bucket_name  = "jokertrickster-workflow"
  environment  = "prod"
  project_name = "workflow"
}
```

### Variables

| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| `bucket_name` | S3 bucket name (must be globally unique) | string | `jokertrickster-workflow` |
| `environment` | Environment (dev/staging/prod) | string | `prod` |
| `project_name` | Project name for tagging | string | `workflow` |

### Outputs

| Output | Description |
|--------|-------------|
| `s3_bucket_name` | S3 bucket name for deployment |
| `s3_bucket_arn` | S3 bucket ARN |
| `s3_website_endpoint` | S3 website endpoint |
| `s3_website_url` | Full website URL (with http://) |
| `iam_user_name` | IAM user name for GitHub Actions |
| `iam_user_arn` | IAM user ARN |

## Deployment

### Step 1: Apply Infrastructure

```bash
terraform init
terraform plan
terraform apply
```

### Step 2: Create IAM Access Keys

After infrastructure is provisioned, create access keys for the IAM user:

```bash
IAM_USER=$(terraform output -raw workflow_iam_user_name)
aws iam create-access-key --user-name $IAM_USER
```

**Important**: Store access keys in GitHub Secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### Step 3: Deploy React Application

```bash
npm run build
aws s3 sync build/ s3://jokertrickster-workflow/ --delete
```

## Security

### Public Access
- S3 bucket allows public read access for website hosting

### IAM Policy
The GitHub Actions IAM user has the following permissions:
- `s3:PutObject`, `s3:GetObject`, `s3:DeleteObject` on workflow bucket
- `s3:ListBucket`, `s3:GetBucketLocation` on workflow bucket

## Resources Created

- `aws_s3_bucket` - Static website hosting bucket
- `aws_s3_bucket_website_configuration` - Website configuration
- `aws_s3_bucket_public_access_block` - Public access settings
- `aws_s3_bucket_policy` - Public read policy
- `aws_iam_user` - GitHub Actions deployment user
- `aws_iam_policy` - Deployment policy
- `aws_iam_user_policy_attachment` - Policy attachment

## Cleanup

```bash
aws s3 rm s3://jokertrickster-workflow/ --recursive
terraform destroy
```

## References

- [AWS S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
