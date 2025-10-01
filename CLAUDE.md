# CLAUDE.md

> Think carefully and implement the most concise solution that changes as little code as possible.

## Project Information
- **Repository**: JokerTrickster/terraform_app
- **GitHub URL**: https://github.com/JokerTrickster/terraform_app
- **Project**: terraform_app

## CCPM Integration (Claude Code PM)
This project uses CCPM for structured project management with AI agents. 

### Quick Commands:
- `/pm:prd-new feature-name` - Create new Product Requirements Document
- `/pm:prd-parse feature-name` - Convert PRD to implementation plan
- `/pm:epic-oneshot feature-name` - Decompose and sync to GitHub issues
- `/pm:issue-start 1234` - Start working on GitHub issue with specialized agent
- `/pm:next` - Get next priority task with context
- `/pm:status` - Overall project dashboard

## USE SUB-AGENTS FOR CONTEXT OPTIMIZATION

### 1. Always use the file-analyzer sub-agent when asked to read files.
The file-analyzer agent is an expert in extracting and summarizing critical information from files, particularly log files and verbose outputs. It provides concise, actionable summaries that preserve essential information while dramatically reducing context usage.

### 2. Always use the code-analyzer sub-agent when asked to search code, analyze code, research bugs, or trace logic flow.

The code-analyzer agent is an expert in code analysis, logic tracing, and vulnerability detection. It provides concise, actionable summaries that preserve essential information while dramatically reducing context usage.

### 3. Always use the test-runner sub-agent to run tests and analyze the test results.

Using the test-runner agent ensures:

- Full test output is captured for debugging
- Main conversation stays clean and focused
- Context usage is optimized
- All issues are properly surfaced
- No approval dialogs interrupt the workflow

## Terraform AWS Infrastructure Project

### Project Overview
Terraform AWS infrastructure project for a board game application. Manages VPC, EC2, ECR, S3, SSM parameters, IAM roles, and security groups in AWS ap-south-1 region using modularized Terraform configuration.

### Essential Commands

#### Terraform Workflow
```bash
# Initialize Terraform (first time or after adding providers)
terraform init

# Validate configuration syntax
terraform validate

# Format Terraform files
terraform fmt -recursive

# Preview infrastructure changes
terraform plan

# Apply infrastructure changes
terraform apply

# Destroy all infrastructure (WARNING: destructive)
terraform destroy

# Show current state
terraform show

# List all resources in state
terraform state list
```

#### Development Commands
```bash
# Validate specific module
terraform validate -chdir=modules/vpc

# Plan specific target
terraform plan -target=module.ec2

# Apply specific target
terraform apply -target=module.vpc

# Output specific value
terraform output ec2_public_ip

# Refresh state from AWS
terraform refresh
```

### Architecture

#### Module Structure
Project uses a **modular architecture** where root `main.tf` orchestrates 7 specialized modules:

1. **vpc** → VPC, subnets, internet gateway, route tables
2. **iam** → EC2 IAM role with ECR, SSM, S3 permissions
3. **security** → Security groups (SSH, HTTP, HTTPS)
4. **ec2** → EC2 instance with IAM instance profile attached
5. **ecr** → Docker image repository
6. **ssm** → Secure parameter store for Redis, MySQL, RabbitMQ configs
7. **s3** → Application bucket + Terraform backend bucket

#### Module Dependencies
```
vpc ───┬──> security ──> ec2
       │
iam ───┘

ecr, ssm, s3 (independent modules)
```

EC2 module depends on VPC (subnet_id) and IAM (instance_profile) outputs. Security module depends on VPC (vpc_id).

#### Backend Configuration
- **Remote state**: S3 backend at `s3://board-game-app-terraform-backend-dev/terraform.tfstate`
- **Region**: ap-south-1
- **State management**: Backend already configured in `providers.tf:11-15`

#### Key Configuration Details
- **AWS Region**: ap-south-1 (Mumbai)
- **VPC CIDR**: 172.31.0.0/16
- **Instance Type**: t4g.medium (ARM-based)
- **Key Pair**: logan.cho.home (must exist in AWS)
- **Project Name**: board_game_app
- **Default Environment**: dev

#### S3 Bucket Structure
Application bucket includes folders for:
- `profiles/`, `cards/`, `frog/images/`, `find-it/images/`, `board_game/images/`
- `wingspan/missions/`, `wingspan/images/`, `slime_war/images/`

#### IAM Permissions
EC2 role includes:
- Full EC2 access (`ec2:*`)
- ECR pull/push operations
- SSM parameter read access (`ssm:GetParameter*`)
- S3 access to `board-game-app` bucket

### Working with This Codebase

#### Before Making Changes
1. Always run `terraform plan` before `apply` to review changes
2. Backend state is shared - coordinate with team before applying
3. Key pair `logan.cho.home` must exist in AWS ap-south-1

#### Adding New Modules
- Place module in `modules/[name]/` with standard `main.tf`, `variables.tf`, `outputs.tf`
- Reference module in root `main.tf`
- Pass required variables from root `variables.tf`

#### Modifying IAM Permissions
Edit `modules/iam/main.tf:28-64` - EC2 policy statement. Changes require `terraform apply` to update attached policy.

#### Sensitive Variables
SSM parameters (Redis, MySQL, RabbitMQ credentials) are stored as `SecureString` type. Default values in `variables.tf` should be overridden via:
- Environment variables: `export TF_VAR_dev_frog_redis_user="value"`
- `terraform.tfvars` file (never commit this)
- CLI: `terraform apply -var="dev_frog_redis_user=value"`

#### State File Warning
Local `terraform.tfstate` and backup files exist but are NOT authoritative - remote S3 backend is source of truth. Do not manually edit state files.

## Philosophy

### Error Handling

- **Fail fast** for critical configuration (missing text model)
- **Log and continue** for optional features (extraction model)
- **Graceful degradation** when external services unavailable
- **User-friendly messages** through resilience layer

### Testing

- Always use the test-runner agent to execute tests.
- Do not use mock services for anything ever.
- Do not move on to the next test until the current test is complete.
- If the test fails, consider checking if the test is structured correctly before deciding we need to refactor the codebase.
- Tests to be verbose so we can use them for debugging.

## Tone and Behavior

- Criticism is welcome. Please tell me when I am wrong or mistaken, or even when you think I might be wrong or mistaken.
- Please tell me if there is a better approach than the one I am taking.
- Please tell me if there is a relevant standard or convention that I appear to be unaware of.
- Be skeptical.
- Be concise.
- Short summaries are OK, but don't give an extended breakdown unless we are working through the details of a plan.
- Do not flatter, and do not give compliments unless I am specifically asking for your judgement.
- Occasional pleasantries are fine.
- Feel free to ask many questions. If you are in doubt of my intent, don't guess. Ask.

## ABSOLUTE RULES:

- NO PARTIAL IMPLEMENTATION
- NO SIMPLIFICATION : no "//This is simplified stuff for now, complete implementation would blablabla"
- NO CODE DUPLICATION : check existing codebase to reuse functions and constants Read files before writing new functions. Use common sense function name to find them easily.
- NO DEAD CODE : either use or delete from codebase completely
- IMPLEMENT TEST FOR EVERY FUNCTIONS
- NO CHEATER TESTS : test must be accurate, reflect real usage and be designed to reveal flaws. No useless tests! Design tests to be verbose so we can use them for debuging.
- NO INCONSISTENT NAMING - read existing codebase naming patterns.
- NO OVER-ENGINEERING - Don't add unnecessary abstractions, factory patterns, or middleware when simple functions would work. Don't think "enterprise" when you need "working"
- NO MIXED CONCERNS - Don't put validation logic inside API handlers, database queries inside UI components, etc. instead of proper separation
- NO RESOURCE LEAKS - Don't forget to close database connections, clear timeouts, remove event listeners, or clean up file handles
