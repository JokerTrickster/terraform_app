# Workflow Hosting Testing Guide

This document provides step-by-step testing procedures for the workflow-hosting infrastructure.

## Prerequisites

Before testing, ensure you have:
- AWS CLI configured with credentials
- Terraform >= 1.0 installed
- Access to AWS Console (optional, for visual verification)

## Test 1: Terraform Infrastructure Provisioning

### Objective
Verify that Terraform can successfully create all infrastructure resources from scratch.

### Steps

1. **Initialize Terraform**
   ```bash
   cd /Users/luxrobo/project/terraform_app
   terraform init
   ```

   **Expected Result**:
   - ✅ Modules downloaded successfully
   - ✅ Backend initialized (S3)
   - ✅ No errors

2. **Validate Configuration**
   ```bash
   terraform validate
   ```

   **Expected Result**:
   - ✅ `Success! The configuration is valid.`

3. **Format Check**
   ```bash
   terraform fmt -check -recursive
   ```

   **Expected Result**:
   - ✅ No formatting issues

4. **Plan Infrastructure**
   ```bash
   terraform plan
   ```

   **Expected Result**:
   - ✅ Shows resources to be created:
     - `aws_s3_bucket.workflow_hosting`
     - `aws_s3_bucket_website_configuration.workflow_hosting`
     - `aws_s3_bucket_public_access_block.workflow_hosting`
     - `aws_s3_bucket_policy.workflow_hosting`
     - `aws_cloudfront_origin_access_control.workflow_hosting`
     - `aws_cloudfront_distribution.workflow_hosting`
     - `aws_iam_user.github_actions_deploy`
     - `aws_iam_policy.github_actions_deploy`
     - `aws_iam_user_policy_attachment.github_actions_deploy`
   - ✅ No errors or warnings
   - ✅ Existing infrastructure (VPC, EC2, etc.) shows no changes

5. **Apply Infrastructure**
   ```bash
   terraform apply
   ```

   **Expected Result**:
   - ✅ All resources created successfully
   - ✅ No errors
   - ✅ Outputs displayed:
     - `workflow_cloudfront_url`
     - `workflow_cloudfront_distribution_id`
     - `workflow_s3_bucket_name`
     - `workflow_iam_user_name`

6. **Verify Outputs**
   ```bash
   terraform output workflow_cloudfront_url
   terraform output workflow_cloudfront_distribution_id
   terraform output workflow_s3_bucket_name
   terraform output workflow_iam_user_name
   ```

   **Expected Result**:
   - ✅ All outputs have valid values
   - ✅ CloudFront URL format: `https://d1234567890abc.cloudfront.net`
   - ✅ S3 bucket name: `jokertrickster-workflow`
   - ✅ IAM user name: `workflow-github-actions-deploy`

### Verification via AWS Console

1. **S3 Bucket**
   - Navigate to S3 Console
   - Find bucket `jokertrickster-workflow`
   - Verify website hosting is enabled
   - Check bucket policy allows public read

2. **CloudFront Distribution**
   - Navigate to CloudFront Console
   - Find distribution with status "Deployed" (may take 5-15 minutes)
   - Verify origin is S3 bucket
   - Check custom error responses (404 → 200, 403 → 200)

3. **IAM User**
   - Navigate to IAM Console → Users
   - Find user `workflow-github-actions-deploy`
   - Verify policy is attached

### Pass Criteria
- [ ] `terraform init` succeeds
- [ ] `terraform validate` passes
- [ ] `terraform plan` shows correct resources
- [ ] `terraform apply` completes without errors
- [ ] All outputs are correct
- [ ] Resources visible in AWS Console

---

## Test 2: Manual S3 Deployment

### Objective
Verify S3 bucket can serve static content and CloudFront distribution works.

### Steps

1. **Create Sample HTML File**
   ```bash
   cat > /tmp/index.html <<'EOF'
   <!DOCTYPE html>
   <html>
   <head>
       <title>Workflow Test</title>
   </head>
   <body>
       <h1>Workflow Hosting Test - Version 1</h1>
       <p>This is a test deployment to S3 + CloudFront.</p>
       <p>Current time: <script>document.write(new Date().toISOString())</script></p>
   </body>
   </html>
   EOF
   ```

2. **Upload to S3**
   ```bash
   aws s3 cp /tmp/index.html s3://jokertrickster-workflow/ \
     --content-type "text/html"
   ```

   **Expected Result**:
   - ✅ Upload successful

3. **Test S3 Website Endpoint**
   ```bash
   S3_ENDPOINT=$(terraform output -raw workflow_s3_bucket_name).s3-website.ap-south-1.amazonaws.com
   curl -I http://$S3_ENDPOINT
   ```

   **Expected Result**:
   - ✅ Status code: 200
   - ✅ Content-Type: text/html

4. **Test CloudFront URL**
   ```bash
   CLOUDFRONT_URL=$(terraform output -raw workflow_cloudfront_url)
   curl -I $CLOUDFRONT_URL
   ```

   **Note**: CloudFront propagation may take 5-15 minutes for new distributions.

   **Expected Result** (after propagation):
   - ✅ Status code: 200
   - ✅ Content served from CloudFront

5. **Verify Content in Browser**
   ```bash
   echo "Open this URL in browser:"
   terraform output workflow_cloudfront_url
   ```

   **Expected Result**:
   - ✅ Page loads with "Workflow Hosting Test - Version 1"
   - ✅ HTTPS works (no certificate warnings)

### Pass Criteria
- [ ] File uploads to S3 successfully
- [ ] S3 website endpoint returns 200 status
- [ ] CloudFront URL serves content (after propagation)
- [ ] Browser displays content correctly
- [ ] HTTPS works without warnings

---

## Test 3: SPA Routing Behavior

### Objective
Verify CloudFront handles SPA routing correctly (404/403 → index.html).

### Steps

1. **Create Multi-Route Test Application**
   ```bash
   mkdir -p /tmp/spa-test

   cat > /tmp/spa-test/index.html <<'EOF'
   <!DOCTYPE html>
   <html>
   <head>
       <title>SPA Routing Test</title>
   </head>
   <body>
       <h1>SPA Routing Test</h1>
       <nav>
           <a href="/">Home</a> |
           <a href="/about">About</a> |
           <a href="/dashboard">Dashboard</a>
       </nav>
       <div id="content">
           <p>Current path: <span id="path"></span></p>
       </div>
       <script>
           document.getElementById('path').textContent = window.location.pathname;

           // Simple client-side routing
           window.addEventListener('click', function(e) {
               if (e.target.tagName === 'A' && e.target.host === window.location.host) {
                   e.preventDefault();
                   history.pushState({}, '', e.target.href);
                   document.getElementById('path').textContent = window.location.pathname;
               }
           });
       </script>
   </body>
   </html>
   EOF
   ```

2. **Deploy to S3**
   ```bash
   aws s3 sync /tmp/spa-test/ s3://jokertrickster-workflow/ --delete
   ```

3. **Invalidate CloudFront Cache**
   ```bash
   DISTRIBUTION_ID=$(terraform output -raw workflow_cloudfront_distribution_id)
   aws cloudfront create-invalidation \
     --distribution-id $DISTRIBUTION_ID \
     --paths "/*"
   ```

   **Expected Result**:
   - ✅ Invalidation created successfully
   - ✅ Returns invalidation ID

4. **Wait for Invalidation**
   ```bash
   aws cloudfront get-invalidation \
     --distribution-id $DISTRIBUTION_ID \
     --id <INVALIDATION_ID> \
     --query 'Invalidation.Status'
   ```

   Wait until status is "Completed" (1-3 minutes).

5. **Test Direct Route Access**
   ```bash
   CLOUDFRONT_URL=$(terraform output -raw workflow_cloudfront_url)

   # Test root route
   curl -s $CLOUDFRONT_URL/ | grep "Current path"

   # Test /about route (should return 200, not 404)
   curl -I $CLOUDFRONT_URL/about

   # Test /dashboard route (should return 200, not 404)
   curl -I $CLOUDFRONT_URL/dashboard
   ```

   **Expected Result**:
   - ✅ Root route returns 200
   - ✅ `/about` returns 200 (not 404)
   - ✅ `/dashboard` returns 200 (not 404)
   - ✅ All routes serve index.html

6. **Browser Testing**
   - Open CloudFront URL in browser
   - Click "About" link (client-side navigation works)
   - Refresh browser (should not show 404)
   - Directly access `/dashboard` in URL bar (should work)
   - Bookmark a route and reopen (should work)

### Pass Criteria
- [ ] Root route loads correctly
- [ ] Direct access to `/about` returns 200
- [ ] Direct access to `/dashboard` returns 200
- [ ] Browser refresh on any route works (no 404)
- [ ] Client-side routing works without page reload
- [ ] All routes serve index.html with 200 status

---

## Test 4: Cache Invalidation and Content Updates

### Objective
Verify cache invalidation successfully updates CloudFront content.

### Steps

1. **Deploy Version 1**
   ```bash
   cat > /tmp/index.html <<'EOF'
   <!DOCTYPE html>
   <html>
   <head><title>Version 1</title></head>
   <body>
       <h1>Version 1.0.0</h1>
       <p>Initial deployment</p>
   </body>
   </html>
   EOF

   aws s3 cp /tmp/index.html s3://jokertrickster-workflow/
   ```

2. **Verify Version 1 on CloudFront**
   ```bash
   CLOUDFRONT_URL=$(terraform output -raw workflow_cloudfront_url)
   curl -s $CLOUDFRONT_URL | grep "Version 1"
   ```

   **Expected Result**:
   - ✅ Shows "Version 1.0.0"

3. **Deploy Version 2**
   ```bash
   cat > /tmp/index.html <<'EOF'
   <!DOCTYPE html>
   <html>
   <head><title>Version 2</title></head>
   <body>
       <h1>Version 2.0.0</h1>
       <p>Updated deployment</p>
   </body>
   </html>
   EOF

   aws s3 cp /tmp/index.html s3://jokertrickster-workflow/
   ```

4. **Test Without Invalidation**
   ```bash
   curl -s $CLOUDFRONT_URL | grep "Version"
   ```

   **Expected Result**:
   - ✅ Still shows "Version 1.0.0" (cached)

5. **Create Invalidation**
   ```bash
   DISTRIBUTION_ID=$(terraform output -raw workflow_cloudfront_distribution_id)
   INVALIDATION_ID=$(aws cloudfront create-invalidation \
     --distribution-id $DISTRIBUTION_ID \
     --paths "/*" \
     --query 'Invalidation.Id' \
     --output text)

   echo "Invalidation ID: $INVALIDATION_ID"
   ```

6. **Wait for Invalidation to Complete**
   ```bash
   # Check status every 10 seconds
   while true; do
     STATUS=$(aws cloudfront get-invalidation \
       --distribution-id $DISTRIBUTION_ID \
       --id $INVALIDATION_ID \
       --query 'Invalidation.Status' \
       --output text)
     echo "Status: $STATUS"
     [[ "$STATUS" == "Completed" ]] && break
     sleep 10
   done
   ```

7. **Verify Version 2**
   ```bash
   curl -s $CLOUDFRONT_URL | grep "Version"
   ```

   **Expected Result**:
   - ✅ Now shows "Version 2.0.0"

8. **Browser Hard Refresh Test**
   - Open CloudFront URL in browser
   - Verify "Version 2.0.0" is displayed
   - Hard refresh (Ctrl+F5 or Cmd+Shift+R)
   - Version should still be 2.0.0

### Pass Criteria
- [ ] Initial deployment shows Version 1
- [ ] Update without invalidation still shows Version 1 (cached)
- [ ] Invalidation completes successfully
- [ ] After invalidation, shows Version 2
- [ ] Browser displays updated content

---

## Test 5: Infrastructure Teardown and Recreation

### Objective
Verify infrastructure can be destroyed and recreated without issues.

### Steps

1. **Save Current State**
   ```bash
   terraform output > /tmp/terraform_outputs_before.txt
   ```

2. **Empty S3 Bucket**
   ```bash
   aws s3 rm s3://jokertrickster-workflow/ --recursive
   ```

   **Note**: CloudFront distribution must be empty to delete.

3. **Destroy Infrastructure**
   ```bash
   terraform destroy -target=module.workflow_hosting
   ```

   Type `yes` to confirm.

   **Expected Result**:
   - ✅ All workflow_hosting resources destroyed
   - ✅ No errors
   - ✅ Other infrastructure (VPC, EC2, etc.) unchanged

4. **Verify Destruction**
   ```bash
   # Check S3 bucket is deleted
   aws s3 ls s3://jokertrickster-workflow/ 2>&1 | grep "NoSuchBucket"

   # Check CloudFront distribution is deleted
   DIST_ID=$(cat /tmp/terraform_outputs_before.txt | grep workflow_cloudfront_distribution_id | awk '{print $2}')
   aws cloudfront get-distribution --id $DIST_ID 2>&1 | grep "NoSuchDistribution"
   ```

   **Expected Result**:
   - ✅ S3 bucket not found
   - ✅ CloudFront distribution not found

5. **Recreate Infrastructure**
   ```bash
   terraform apply
   ```

   Type `yes` to confirm.

   **Expected Result**:
   - ✅ Infrastructure recreated successfully
   - ✅ New resources created with potentially different IDs

6. **Verify Outputs Match**
   ```bash
   terraform output > /tmp/terraform_outputs_after.txt

   # Compare bucket names (should be same)
   diff <(grep workflow_s3_bucket_name /tmp/terraform_outputs_before.txt) \
        <(grep workflow_s3_bucket_name /tmp/terraform_outputs_after.txt)
   ```

   **Expected Result**:
   - ✅ Bucket name is identical
   - ✅ Distribution ID is different (new distribution)
   - ✅ IAM user name is identical

### Pass Criteria
- [ ] `terraform destroy` completes without errors
- [ ] All resources deleted (verified via AWS CLI)
- [ ] Other infrastructure unchanged
- [ ] `terraform apply` recreates resources successfully
- [ ] New infrastructure is functional

---

## Test Summary Checklist

Before marking Issue #3 as complete, verify all tests pass:

- [ ] **Test 1**: Terraform infrastructure provisioning ✅
- [ ] **Test 2**: Manual S3 deployment ✅
- [ ] **Test 3**: SPA routing behavior ✅
- [ ] **Test 4**: Cache invalidation and content updates ✅
- [ ] **Test 5**: Infrastructure teardown and recreation ✅

## Expected Terraform Plan Output

When you run `terraform plan`, you should see:

```
Terraform will perform the following actions:

  # module.workflow_hosting.aws_cloudfront_distribution.workflow_hosting will be created
  # module.workflow_hosting.aws_cloudfront_origin_access_control.workflow_hosting will be created
  # module.workflow_hosting.aws_iam_policy.github_actions_deploy will be created
  # module.workflow_hosting.aws_iam_user.github_actions_deploy will be created
  # module.workflow_hosting.aws_iam_user_policy_attachment.github_actions_deploy will be created
  # module.workflow_hosting.aws_s3_bucket.workflow_hosting will be created
  # module.workflow_hosting.aws_s3_bucket_policy.workflow_hosting will be created
  # module.workflow_hosting.aws_s3_bucket_public_access_block.workflow_hosting will be created
  # module.workflow_hosting.aws_s3_bucket_website_configuration.workflow_hosting will be created

Plan: 9 to add, 0 to change, 0 to destroy.
```

**Important**: Should show `0 to change` for existing infrastructure (VPC, EC2, S3 board-game-app, etc.)

## Notes for Tomorrow's Testing

1. **CloudFront Propagation**: New distributions take 5-15 minutes to propagate. Be patient!
2. **Cache Invalidation**: Takes 1-3 minutes to complete
3. **S3 Bucket Name**: If `jokertrickster-workflow` is taken, update `bucket_name` in `main.tf`
4. **IAM Access Keys**: Create manually after `terraform apply` using AWS Console or CLI
5. **Cleanup**: Run `terraform destroy -target=module.workflow_hosting` to remove all resources

## Quick Test Commands

```bash
# Full test workflow
terraform init
terraform validate
terraform plan
terraform apply

# Get outputs
terraform output workflow_cloudfront_url
terraform output workflow_cloudfront_distribution_id
terraform output workflow_s3_bucket_name

# Deploy test file
echo "<!DOCTYPE html><html><body><h1>Test</h1></body></html>" > /tmp/test.html
aws s3 cp /tmp/test.html s3://jokertrickster-workflow/index.html

# Invalidate cache
DIST_ID=$(terraform output -raw workflow_cloudfront_distribution_id)
aws cloudfront create-invalidation --distribution-id $DIST_ID --paths "/*"

# Test URL
curl $(terraform output -raw workflow_cloudfront_url)
```
