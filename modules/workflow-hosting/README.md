# Workflow Hosting Module

S3 + CloudFront static website hosting module for React application deployment.

## Architecture

```
React App (build/)
      ↓
S3 Bucket (jokertrickster-workflow)
      ↓
CloudFront Distribution (CDN)
      ↓
User Browser
```

## Features

- **S3 Static Website Hosting**: Configured for SPA (Single Page Application) routing
- **CloudFront CDN**: Global content delivery with edge caching
- **IAM User for Deployment**: Least-privilege access for GitHub Actions
- **HTTPS Support**: CloudFront default SSL certificate
- **SPA Routing**: 404/403 errors redirect to index.html for client-side routing

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
| `cloudfront_url` | CloudFront distribution URL (with https://) |
| `cloudfront_distribution_id` | CloudFront distribution ID for cache invalidation |
| `cloudfront_domain_name` | CloudFront domain name (without https://) |
| `s3_bucket_name` | S3 bucket name for deployment |
| `s3_bucket_arn` | S3 bucket ARN |
| `s3_website_endpoint` | S3 website endpoint |
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
# Get IAM user name from Terraform outputs
IAM_USER=$(terraform output -raw workflow_iam_user_name)

# Create access keys
aws iam create-access-key --user-name $IAM_USER
```

**Important**: Store access keys in GitHub Secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `CLOUDFRONT_DISTRIBUTION_ID` (from Terraform output)

### Step 3: Deploy React Application

From your React application repository:

```bash
# Build React app
npm run build

# Sync to S3
aws s3 sync build/ s3://jokertrickster-workflow/ --delete

# Invalidate CloudFront cache
DISTRIBUTION_ID=$(terraform output -raw workflow_cloudfront_distribution_id)
aws cloudfront create-invalidation \
  --distribution-id $DISTRIBUTION_ID \
  --paths "/*"
```

## SPA Routing Configuration

CloudFront is configured to handle SPA routing by redirecting 404 and 403 errors to `index.html` with a 200 status code. This allows React Router (or other client-side routing) to handle all routes.

**Supported scenarios**:
- Direct access to routes (e.g., `/about`, `/dashboard`)
- Browser refresh on any route
- Bookmarked routes
- Deep linking

## Security

### Public Access
- S3 bucket allows public read access for website hosting
- CloudFront enforces HTTPS (redirects HTTP to HTTPS)

### IAM Policy
The GitHub Actions IAM user has the following permissions:
- `s3:PutObject`, `s3:GetObject`, `s3:DeleteObject` on workflow bucket
- `s3:ListBucket` on workflow bucket
- `cloudfront:CreateInvalidation` on workflow distribution

## Cost Estimation

**Monthly cost for personal/low-traffic use** (assuming within AWS Free Tier):

| Resource | Free Tier | Estimated Cost |
|----------|-----------|----------------|
| S3 Storage | First 5GB free | ~$0 (React app < 100MB) |
| CloudFront Data Transfer | First 1TB free | ~$0 (personal use) |
| CloudFront Requests | First 10M free | ~$0 |
| CloudFront Invalidations | First 1,000 paths free | ~$0 |

**Total**: $0/month (within Free Tier limits)

## Troubleshooting

### Issue 1: Bucket Name Already Exists

**Error**: `BucketAlreadyExists` or `BucketAlreadyOwnedByYou`

**Solution**: S3 bucket names must be globally unique. Update `bucket_name` variable:

```hcl
module "workflow_hosting" {
  source = "./modules/workflow-hosting"

  bucket_name = "jokertrickster-workflow-prod"  # Add suffix
}
```

### Issue 2: CloudFront Propagation Delay

**Symptom**: Changes not visible immediately after deployment

**Solution**: CloudFront propagation takes 5-15 minutes for new distributions. Wait for distribution status to change from "In Progress" to "Deployed".

Check status:
```bash
aws cloudfront get-distribution --id <DISTRIBUTION_ID> \
  --query 'Distribution.Status'
```

### Issue 3: 404 Errors on Refresh

**Symptom**: React routes work on navigation but show 404 on browser refresh

**Solution**: Ensure CloudFront custom error responses are configured (already included in module). Verify:

```bash
aws cloudfront get-distribution-config --id <DISTRIBUTION_ID> \
  --query 'DistributionConfig.CustomErrorResponses'
```

Should show 404 → 200 and 403 → 200 redirects to `/index.html`.

### Issue 4: IAM Permission Denied

**Error**: `Access Denied` when deploying to S3 or invalidating cache

**Solution**: Verify IAM policy is attached and access keys are correct:

```bash
# List user policies
aws iam list-attached-user-policies --user-name <IAM_USER_NAME>

# Test S3 access
aws s3 ls s3://jokertrickster-workflow/

# Test CloudFront access
aws cloudfront list-invalidations --distribution-id <DISTRIBUTION_ID>
```

### Issue 5: Stale Content After Deployment

**Symptom**: Updated files not visible on CloudFront URL

**Solution**: Create cache invalidation after S3 sync:

```bash
aws cloudfront create-invalidation \
  --distribution-id <DISTRIBUTION_ID> \
  --paths "/*"
```

Invalidation typically completes in 1-3 minutes.

## Resources Created

This module creates the following AWS resources:

- `aws_s3_bucket` - Static website hosting bucket
- `aws_s3_bucket_website_configuration` - Website configuration
- `aws_s3_bucket_public_access_block` - Public access settings
- `aws_s3_bucket_policy` - Public read policy
- `aws_cloudfront_origin_access_control` - OAC for S3 origin
- `aws_cloudfront_distribution` - CDN distribution
- `aws_iam_user` - GitHub Actions deployment user
- `aws_iam_policy` - Deployment policy
- `aws_iam_user_policy_attachment` - Policy attachment

## Cleanup

To destroy all resources:

```bash
# Empty S3 bucket first (CloudFront won't delete if bucket has objects)
aws s3 rm s3://jokertrickster-workflow/ --recursive

# Destroy infrastructure
terraform destroy
```

**Note**: CloudFront distribution deletion can take 15-20 minutes as AWS must disable the distribution first.

## References

- [AWS S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [AWS CloudFront Developer Guide](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
