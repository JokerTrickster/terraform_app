---
name: workflow-web-hosting
description: S3 + CloudFront infrastructure for React-based workflow web application with GitHub Actions deployment
status: backlog
created: 2025-10-01T08:10:53Z
---

# PRD: workflow-web-hosting

## Executive Summary

This PRD outlines the infrastructure requirements for hosting the workflow React web application using AWS S3 and CloudFront. The solution provides a simple, cost-effective static site hosting with automated deployment via GitHub Actions, optimized for personal/single-user usage with minimal operational overhead.

**Value Proposition**: Reliable, fast, and maintenance-free web hosting for React applications with automated CI/CD pipeline and CloudFront CDN distribution.

## Problem Statement

### What problem are we solving?
The workflow React application requires a production hosting environment that:
- Serves static assets (HTML, CSS, JavaScript) globally
- Supports React SPA routing and client-side navigation
- Enables automated deployments from GitHub repository
- Minimizes infrastructure management complexity
- Operates cost-effectively for personal/low-traffic usage

### Why is this important now?
- React application is ready for production deployment
- Need reliable hosting infrastructure without server management
- Require automated deployment pipeline to streamline updates
- Want to leverage AWS managed services for scalability and reliability

## User Stories

### Primary Persona: Developer/Owner
**Background**: Solo developer maintaining the workflow React application, requiring simple deployment and hosting.

**User Journey**:
1. Developer pushes code changes to GitHub repository
2. GitHub Actions automatically builds React application
3. Built assets are deployed to S3 bucket
4. CloudFront cache is invalidated to serve latest version
5. Application is accessible via CloudFront distribution URL
6. Developer verifies deployment and functionality

### Pain Points Being Addressed
- **Manual Deployment**: Eliminates manual upload of built assets
- **Server Management**: No need to manage EC2 instances or web servers
- **Deployment Complexity**: Simplified pipeline with GitHub Actions
- **Global Distribution**: CloudFront provides CDN capabilities if needed in future

## Requirements

### Functional Requirements

#### FR1: S3 Static Website Hosting
- **FR1.1**: Create S3 bucket named `jokertrickster-workflow`
- **FR1.2**: Configure bucket for static website hosting
- **FR1.3**: Set bucket policy to allow CloudFront access
- **FR1.4**: Store React build artifacts (index.html, static assets)
- **FR1.5**: Support SPA routing (handle 404 → index.html redirection)

#### FR2: CloudFront Distribution
- **FR2.1**: Create CloudFront distribution with S3 bucket as origin
- **FR2.2**: Configure default root object as `index.html`
- **FR2.3**: Enable automatic compression (Gzip)
- **FR2.4**: Set default TTL for caching behavior
- **FR2.5**: Support all HTTP methods (GET, HEAD, OPTIONS)
- **FR2.6**: Configure error pages to redirect to `index.html` for SPA routing

#### FR3: GitHub Actions Deployment Pipeline
- **FR3.1**: Trigger on push to main branch
- **FR3.2**: Build React application (`npm run build`)
- **FR3.3**: Sync build output to S3 bucket
- **FR3.4**: Invalidate CloudFront cache after deployment
- **FR3.5**: Use IAM credentials stored in GitHub Secrets
- **FR3.6**: Provide deployment status feedback

#### FR4: Terraform Infrastructure as Code
- **FR4.1**: Define S3 bucket resource with website configuration
- **FR4.2**: Define CloudFront distribution resource
- **FR4.3**: Create IAM policy for GitHub Actions deployment access
- **FR4.4**: Output CloudFront distribution URL
- **FR4.5**: Support `terraform apply` for infrastructure provisioning
- **FR4.6**: Support `terraform destroy` for cleanup

### Non-Functional Requirements

#### NFR1: Performance
- **NFR1.1**: CloudFront should cache assets with reasonable TTL (e.g., 1 hour)
- **NFR1.2**: React application should load within acceptable time for single user
- **NFR1.3**: No specific performance SLA required (personal use)

#### NFR2: Security
- **NFR2.1**: Public read access to S3 bucket objects (simplified security model)
- **NFR2.2**: IAM policy grants minimum permissions for GitHub Actions
- **NFR2.3**: No custom TLS/SSL certificate required (use CloudFront default)
- **NFR2.4**: No WAF or IP whitelisting required

#### NFR3: Scalability
- **NFR3.1**: Architecture should handle personal/single-user traffic
- **NFR3.2**: CloudFront provides CDN capability if traffic grows
- **NFR3.3**: S3 automatically scales storage as needed

#### NFR4: Maintainability
- **NFR4.1**: Infrastructure defined as code (Terraform)
- **NFR4.2**: Deployment fully automated via GitHub Actions
- **NFR4.3**: No manual intervention required for routine deployments
- **NFR4.4**: Clear documentation for setup and troubleshooting

#### NFR5: Cost Optimization
- **NFR5.1**: Use AWS Free Tier where applicable
- **NFR5.2**: Minimize unnecessary features (logging, monitoring, versioning)
- **NFR5.3**: No budget constraints, but optimize for cost-effectiveness

## Success Criteria

### Measurable Outcomes
1. **Infrastructure Provisioning**: Successfully create S3 + CloudFront via Terraform on first run
2. **Deployment Automation**: GitHub Actions successfully deploys React app within 5 minutes
3. **Application Accessibility**: React application loads correctly via CloudFront URL
4. **SPA Routing**: Client-side routing works without 404 errors
5. **Cache Invalidation**: Updated code visible after deployment completes
6. **Zero Manual Steps**: No manual file uploads or configuration changes required

### Key Metrics
- **Deployment Success Rate**: 100% of GitHub Actions workflows complete successfully
- **Infrastructure Stability**: Zero unplanned downtime
- **Deployment Time**: < 5 minutes from git push to live deployment
- **Cost**: Stay within AWS Free Tier limits for low traffic

## Constraints & Assumptions

### Technical Constraints
- **TC1**: Must use existing AWS account in ap-south-1 region
- **TC2**: No custom domain configuration (use CloudFront default URL)
- **TC3**: No SSL certificate management (use CloudFront managed certificate)
- **TC4**: React application must be build-able via `npm run build`

### Timeline Constraints
- **TL1**: Infrastructure should be deployable immediately
- **TL2**: No specific deadline (personal project)

### Resource Constraints
- **RC1**: Solo developer maintaining infrastructure
- **RC2**: Minimal operational overhead preferred
- **RC3**: No dedicated DevOps resources

### Assumptions
- **A1**: React application is already developed and working locally
- **A2**: GitHub repository exists or will be created
- **A3**: AWS CLI and Terraform are installed locally
- **A4**: Developer has AWS credentials configured
- **A5**: Application uses client-side routing (React Router)
- **A6**: No backend API required (static site only)

## Out of Scope

Explicitly NOT building:

### OS1: Advanced Features
- Custom domain configuration (Route 53)
- SSL/TLS certificate management
- HTTPS enforcement
- Origin Access Identity (OAI) for enhanced security
- WAF rules or IP whitelisting
- Custom error pages beyond SPA routing needs

### OS2: Monitoring & Logging
- CloudWatch monitoring dashboards
- Access logging to S3
- Error rate alerts
- Performance monitoring
- Usage analytics

### OS3: Multi-Environment Setup
- Staging environment
- Development environment
- Environment-specific configurations

### OS4: Advanced Deployment
- Blue-green deployments
- Canary releases
- Rollback automation beyond Terraform state management
- Preview deployments for pull requests

### OS5: Storage Features
- S3 versioning
- Lifecycle policies
- Cross-region replication
- Backup strategies

### OS6: Performance Optimization
- Custom cache behaviors
- Edge Lambda functions
- Response header customization
- Brotli compression (Gzip only)

## Dependencies

### External Dependencies
- **ED1**: AWS Account with active credentials
- **ED2**: GitHub repository for workflow application
- **ED3**: GitHub Secrets configured with AWS credentials
- **ED4**: Terraform >= 1.0 installed locally
- **ED5**: AWS CLI configured for Terraform provider
- **ED6**: Node.js and npm for React build process

### Internal Dependencies
- **ID1**: React application code ready for production build
- **ID2**: Existing Terraform infrastructure (VPC, EC2, etc.) should not conflict
- **ID3**: AWS region selection (ap-south-1 to match existing infrastructure)

### Potential Blockers
- **B1**: S3 bucket name `jokertrickster-workflow` might be taken globally
- **B2**: AWS Free Tier limits could be exceeded with existing resources
- **B3**: GitHub Actions runner compatibility with AWS CLI/Terraform

## Implementation Phases

### Phase 1: Infrastructure Setup (Terraform)
**Deliverables**:
- S3 bucket module for static website hosting
- CloudFront distribution module
- IAM policy for GitHub Actions
- Terraform outputs for CloudFront URL
- README documentation for infrastructure setup

**Acceptance Criteria**:
- `terraform apply` successfully creates all resources
- CloudFront URL is accessible and returns default CloudFront page
- S3 bucket is configured for website hosting
- IAM policy allows necessary S3/CloudFront operations

### Phase 2: GitHub Actions Pipeline
**Deliverables**:
- `.github/workflows/deploy.yml` workflow file
- Workflow builds React application
- Workflow syncs to S3 bucket
- Workflow invalidates CloudFront cache
- GitHub Secrets documentation

**Acceptance Criteria**:
- Workflow triggers on push to main branch
- React build succeeds without errors
- Files uploaded to correct S3 bucket path
- CloudFront invalidation completes successfully
- Workflow provides clear status messages

### Phase 3: Testing & Documentation
**Deliverables**:
- End-to-end deployment test
- SPA routing verification (all routes work)
- Documentation for setup and deployment
- Troubleshooting guide

**Acceptance Criteria**:
- Fresh deployment works from start to finish
- Application loads correctly via CloudFront URL
- Client-side routing functions properly (no 404s)
- Documentation is clear and complete

## Technical Architecture

### Component Diagram
```
┌─────────────────────────────────────────────────────────┐
│                   GitHub Repository                      │
│                  (workflow project)                      │
└────────────────────┬────────────────────────────────────┘
                     │ git push (main branch)
                     ▼
┌─────────────────────────────────────────────────────────┐
│              GitHub Actions Workflow                     │
│  1. npm install                                         │
│  2. npm run build                                       │
│  3. aws s3 sync build/ → S3                            │
│  4. aws cloudfront create-invalidation                 │
└────────────────────┬────────────────────────────────────┘
                     │ deploys to
                     ▼
┌─────────────────────────────────────────────────────────┐
│      S3 Bucket: jokertrickster-workflow                 │
│      - Static Website Hosting Enabled                   │
│      - Stores: index.html, static/*, etc.              │
│      - Public Read Access                               │
└────────────────────┬────────────────────────────────────┘
                     │ origin for
                     ▼
┌─────────────────────────────────────────────────────────┐
│           CloudFront Distribution                        │
│      - Default Root: index.html                         │
│      - Error Handling: 404 → index.html                │
│      - Caching: Default TTL                             │
│      - Compression: Gzip Enabled                        │
└────────────────────┬────────────────────────────────────┘
                     │ serves to
                     ▼
              ┌──────────────┐
              │     User     │
              │  (Developer) │
              └──────────────┘
```

### Infrastructure Components

#### S3 Bucket Configuration
```hcl
resource "aws_s3_bucket" "workflow_hosting" {
  bucket = "jokertrickster-workflow"

  website {
    index_document = "index.html"
    error_document = "index.html"  # SPA routing
  }
}
```

#### CloudFront Distribution
```hcl
resource "aws_cloudfront_distribution" "workflow_cdn" {
  origin {
    domain_name = aws_s3_bucket.workflow_hosting.website_endpoint
    origin_id   = "S3-workflow-hosting"
  }

  default_cache_behavior {
    compress = true
    # ... cache settings
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }
}
```

#### IAM Policy for GitHub Actions
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::jokertrickster-workflow",
        "arn:aws:s3:::jokertrickster-workflow/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudfront:CreateInvalidation"
      ],
      "Resource": "*"
    }
  ]
}
```

## Risk Assessment

### Risk 1: Bucket Name Availability
- **Probability**: Medium
- **Impact**: Low
- **Mitigation**: Have backup naming convention (e.g., `jokertrickster-workflow-prod`, `jt-workflow`, etc.)

### Risk 2: Cache Invalidation Costs
- **Probability**: Low (personal use)
- **Impact**: Low
- **Mitigation**: AWS Free Tier includes 1,000 invalidation paths/month

### Risk 3: SPA Routing Configuration
- **Probability**: Medium (common misconfiguration)
- **Impact**: High (app breaks)
- **Mitigation**: Proper CloudFront error page configuration, thorough testing

### Risk 4: GitHub Actions Secrets Exposure
- **Probability**: Low
- **Impact**: High (AWS credentials leak)
- **Mitigation**: Use least-privilege IAM policy, rotate credentials if exposed

## Appendix

### Terraform Module Structure
```
terraform_app/
├── modules/
│   └── workflow-hosting/
│       ├── main.tf           # S3 + CloudFront resources
│       ├── variables.tf      # Input variables
│       ├── outputs.tf        # CloudFront URL, bucket name
│       └── iam.tf            # GitHub Actions IAM policy
```

### GitHub Actions Workflow Example
```yaml
name: Deploy to S3 + CloudFront

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18

      - name: Install dependencies
        run: npm ci

      - name: Build React app
        run: npm run build

      - name: Deploy to S3
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          aws s3 sync build/ s3://jokertrickster-workflow --delete

      - name: Invalidate CloudFront
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          aws cloudfront create-invalidation \
            --distribution-id ${{ secrets.CLOUDFRONT_DISTRIBUTION_ID }} \
            --paths "/*"
```

### Estimated Costs (Personal Use)
- **S3 Storage**: ~$0.023/GB/month (negligible for React app)
- **CloudFront Data Transfer**: First 1TB free per month
- **CloudFront Requests**: First 10M requests free per month
- **Invalidations**: First 1,000 paths free per month

**Total Estimated Cost**: $0/month (within Free Tier for personal use)

### Next Steps After PRD Approval
1. Run `/pm:prd-parse workflow-web-hosting` to create implementation epic
2. Decompose epic into GitHub issues via `/pm:epic-oneshot workflow-web-hosting`
3. Start implementation with `/pm:issue-start <issue-number>`
4. Create Terraform module structure
5. Implement GitHub Actions workflow
6. Test end-to-end deployment
