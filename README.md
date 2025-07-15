# Terraform AWS Infrastructure

AWS에서 VPC, 퍼블릭 서브넷, EC2 인스턴스, ECR 리포지토리를 생성하는 Terraform 프로젝트입니다.

## 프로젝트 구조

```
terraform_app/
├── main.tf              # 메인 Terraform 구성
├── variables.tf         # 변수 정의
├── outputs.tf          # 출력 값 정의
├── versions.tf         # Terraform 및 프로바이더 버전
├── modules/
│   ├── vpc/           # VPC 및 네트워킹 모듈
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security/      # 보안 그룹 모듈
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ec2/           # EC2 인스턴스 모듈
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ecr/           # ECR 리포지토리 모듈
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── iam/           # IAM 역할 및 정책 모듈
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md
```

## 모듈 설명

### VPC 모듈 (`modules/vpc/`)
- **VPC 생성**: CIDR 블록 10.0.0.0/16
- **퍼블릭 서브넷 생성**: CIDR 블록 10.0.1.0/24
- **Internet Gateway 생성**: 외부 인터넷 연결
- **라우팅 테이블 설정**: 퍼블릭 서브넷의 인터넷 라우팅

### Security 모듈 (`modules/security/`)
- **Security Group 생성**: EC2 인스턴스 보안 설정
- **SSH 접속 허용**: 포트 22 (0.0.0.0/0)
- **HTTP 접속 허용**: 포트 80 (0.0.0.0/0)
- **HTTPS 접속 허용**: 포트 443 (0.0.0.0/0)
- **아웃바운드 트래픽 허용**: 모든 포트

### EC2 모듈 (`modules/ec2/`)
- **Amazon Linux 2 AMI 사용**: 최신 안정 버전
- **t3.micro 인스턴스 타입**: 프리티어 사용
- **Apache 웹 서버 자동 설치**: user_data 스크립트
- **퍼블릭 IP 자동 할당**: 서브넷 설정으로 인해

### ECR 모듈 (`modules/ecr/`)
- **ECR 리포지토리 생성**: Docker 이미지 저장소
- **리포지토리 이름**: `terraform-app-ecr`
- **이미지 태그**: 태그 없이 빌드 시 자동 생성

### IAM 모듈 (`modules/iam/`)
- **IAM 역할 생성**: EC2, ECR에 대한 권한 부여
- **IAM 정책 생성**: 필요한 권한 포함

## 사용 방법

### 1. 사전 준비
```bash
# AWS CLI 설정
aws configure

# SSH 키 페어 생성 (AWS 콘솔에서)
# 키 페어 이름: terraform-key
```

### 2. Terraform 실행
```bash
# Terraform 초기화
terraform init

# 실행 계획 확인
terraform plan

# 인프라 생성
terraform apply

# 인프라 삭제 (비용 절약)
terraform destroy
```

## 출력 값

- `vpc_id`: 생성된 VPC의 ID
- `public_subnet_id`: 퍼블릭 서브넷의 ID
- `ec2_instance_id`: EC2 인스턴스의 ID
- `ec2_public_ip`: EC2 인스턴스의 공인 IP
- `ec2_public_dns`: EC2 인스턴스의 공인 DNS

## 네트워크 구성

```
Internet
    │
    ▼
Internet Gateway
    │
    ▼
VPC (10.0.0.0/16)
    │
    ▼
퍼블릭 서브넷 (10.0.1.0/24)
    │
    ▼
EC2 인스턴스 (t3.micro)
```

## 보안 설정

- **Security Group**: EC2 인스턴스에 연결
- **SSH 접속**: 키 페어 인증 필요
- **웹 서버**: HTTP/HTTPS 접속 가능
- **아웃바운드**: 모든 트래픽 허용

## 비용 고려사항

- **t3.micro**: 프리티어 (월 750시간)
- **VPC**: 무료
- **Internet Gateway**: 무료
- **Security Group**: 무료
- **Data Transfer**: 사용량에 따라 과금

## 주의사항

1. **리전**: 서울 리전 (ap-northeast-2) 사용
2. **SSH 키 페어**: 반드시 미리 생성 필요
3. **비용 관리**: 사용 후 `terraform destroy` 실행
4. **보안**: 프로덕션 환경에서는 Security Group 규칙 강화 필요

## 트러블슈팅

### SSH 연결 문제
```bash
# EC2 인스턴스에 SSH 연결
ssh -i terraform-key.pem ec2-user@[PUBLIC_IP]
```

### 웹 서버 접속 확인
```bash
# 브라우저에서 확인
http://[PUBLIC_IP]
```

### 로그 확인
```bash
# Terraform 로그
terraform logs

# AWS CLI로 리소스 확인
aws ec2 describe-instances
aws ec2 describe-vpcs
```

## Terraform Best Practices

### 1. 상태 관리
- **Remote Backend 사용**: S3, Azure Blob, GCS 등
- **State Locking**: 동시 접근 방지
- **State 암호화**: 민감한 정보 보호

### 2. 모듈화
- **재사용 가능한 모듈**: 코드 중복 방지
- **버전 관리**: 모듈 버전 고정
- **입출력 명확화**: 모듈 간 의존성 관리

### 3. 보안
- **민감한 정보**: Vault, AWS Secrets Manager 사용
- **IAM 최소 권한**: 필요한 권한만 부여
- **네트워크 보안**: Security Group 규칙 최소화

### 4. 코드 품질
- **terraform fmt**: 코드 포맷팅
- **terraform validate**: 구문 검증
- **tflint**: 린팅 도구 사용

## 환경별 배포

### 개발 환경
```bash
# 개발 환경 변수 설정
export TF_VAR_environment="dev"
export TF_VAR_instance_type="t3.micro"
terraform apply
```

### 스테이징 환경
```bash
# 스테이징 환경 변수 설정
export TF_VAR_environment="staging"
export TF_VAR_instance_type="t3.small"
terraform apply
```

### 프로덕션 환경
```bash
# 프로덕션 환경 변수 설정
export TF_VAR_environment="prod"
export TF_VAR_instance_type="t3.medium"
terraform apply
```

## 모니터링 및 로깅

### CloudWatch 설정
```hcl
# EC2 인스턴스에 CloudWatch Agent 설치
resource "aws_cloudwatch_log_group" "main" {
  name = "/aws/ec2/${var.project_name}"
  retention_in_days = 7
}
```

### 알람 설정
```hcl
# CPU 사용률 알람
resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name = "${var.project_name}-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "300"
  statistic = "Average"
  threshold = "80"
  alarm_description = "CPU 사용률이 80%를 초과할 때"
}
```

## 백업 및 복구

### EBS 스냅샷
```hcl
# EBS 볼륨 스냅샷 생성
resource "aws_ebs_snapshot" "main" {
  volume_id = aws_instance.main.root_block_device[0].volume_id
  description = "${var.project_name} EBS 스냅샷"
  
  tags = {
    Name = "${var.project_name}-snapshot"
  }
}
```

## 확장성 고려사항

### Auto Scaling Group
```hcl
# Auto Scaling Group 설정 예시
resource "aws_autoscaling_group" "main" {
  name = "${var.project_name}-asg"
  min_size = 1
  max_size = 3
  desired_capacity = 1
  vpc_zone_identifier = [module.vpc.public_subnet_id]
  
  launch_template {
    id = aws_launch_template.main.id
    version = "$Latest"
  }
}
```

### Load Balancer
```hcl
# Application Load Balancer 설정 예시
resource "aws_lb" "main" {
  name = "${var.project_name}-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [module.security.security_group_id]
  subnets = [module.vpc.public_subnet_id]
}
```

## CI/CD 통합

### GitHub Actions 예시
```yaml
name: Terraform CI/CD
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1
      
    - name: Terraform Init
      run: terraform init
      
    - name: Terraform Plan
      run: terraform plan
      
    - name: Terraform Apply
      if: github.ref == 'refs/heads/main'
      run: terraform apply -auto-approve
```

## 성능 최적화

### Provider 캐싱
```hcl
# Provider 플러그인 캐싱
terraform {
  provider_installation {
    network_mirror {
      url = "https://registry.terraform.io/"
    }
  }
}
```

### 병렬 처리
```bash
# 병렬 처리로 속도 향상
terraform apply -parallelism=10
```

## 문제 해결 가이드

### 일반적인 오류

1. **Provider 버전 충돌**
   ```bash
   terraform init -upgrade
   ```

2. **State 파일 손상**
   ```bash
   terraform state pull > terraform.tfstate.backup
   terraform init -reconfigure
   ```

3. **모듈 경로 오류**
   ```bash
   terraform get -update
   ```

### 디버깅 명령어
```bash
# 상세한 로그 출력
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform.log
terraform apply

# 상태 확인
terraform show
terraform state list
```

## 참고 자료

- [Terraform 공식 문서](https://www.terraform.io/docs)
- [AWS Provider 문서](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

## 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

## 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request  