# Terraform 모듈 구조

## S3 모듈 분류

| 유형 | 모듈 | 용도 |
|------|------|------|
| **Backend** | `s3/` | 앱 데이터 버킷 + Terraform 백엔드 버킷 + DynamoDB state lock |
| **Static Website** | `s3-static-website/` | 정적 웹사이트 호스팅 (재사용 모듈) |
| **Private Storage** | `s3-joker-repository/` | Presigned URL 기반 비공개 스토리지 |
| **Public Storage** | `s3-daily-memo/` | 공개 읽기 접근 스토리지 |
| **Workflow** | `workflow-hosting/` | 워크플로우 전용 정적 호스팅 (별도 IAM 구조) |

## s3-static-website 모듈 사용 현황

| 인스턴스 | 버킷명 |
|----------|--------|
| `s3_cloud_repository` | cloudbox-app |
| `s3_map_editor` | jokertrickster-map-editor-dev |
| `s3_psychology_test` | jokertrickster-psychology-test-dev |
| `s3_joker_mall` | jokertrickster-joker-mall-dev |
| `s3_molandolan` | jokertrickster-molandolan-dev |

## 환경 분리

```bash
# dev 환경
terraform plan -var-file=environments/dev.tfvars

# prod 환경
terraform plan -var-file=environments/prod.tfvars
```

## 모듈 버전 관리 (향후)

현재 모든 모듈은 로컬 경로(`./modules/...`)를 사용합니다.
모듈을 별도 Git 리포지토리로 분리하면 태그 기반 버전 관리가 가능합니다.

```hcl
# 현재 (로컬)
module "s3_static_website" {
  source = "./modules/s3-static-website"
}

# 향후 (Git 태그 기반)
module "s3_static_website" {
  source = "git::https://github.com/JokerTrickster/terraform-modules.git//s3-static-website?ref=v1.0.0"
}
```

### 버전 관리 전환 순서

1. `terraform-modules` 리포지토리 생성
2. 안정화된 모듈을 해당 리포지토리로 이동
3. 시맨틱 버전 태그 부여 (v1.0.0)
4. 루트 main.tf의 source를 Git URL로 변경
5. `terraform init -upgrade` 실행
