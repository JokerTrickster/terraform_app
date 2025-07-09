# 기본 VPC 리소스 사용
resource "aws_default_vpc" "default" {
  tags = {
    Name = "default_vpc"
  }
}

# 기본 VPC의 서브넷 데이터 소스
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

# 각 기본 서브넷에 가용영역별 이름 태그 추가
resource "aws_default_subnet" "default_az_a" {
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "ap-northeast-2a"
  }
}

resource "aws_default_subnet" "default_az_b" {
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "ap-northeast-2b"
  }
}

resource "aws_default_subnet" "default_az_c" {
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "ap-northeast-2c"
  }
}

resource "aws_default_subnet" "default_az_d" {
  availability_zone = "ap-northeast-2d"

  tags = {
    Name = "ap-northeast-2d"
  }
}

# 기본 VPC의 인터넷 게이트웨이 데이터 소스
data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

# 기본 VPC의 라우팅 테이블 데이터 소스
data "aws_route_table" "default" {
  vpc_id = aws_default_vpc.default.id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

# 가용영역 데이터 소스
data "aws_availability_zones" "available" {
  state = "available"
}

# 리전 설정
provider "aws" {
  region = "ap-northeast-2"
} 