#!/bin/bash
# 시스템 업데이트
sudo apt-get update

# unzip 설치
sudo apt-get install -y unzip

# Docker 설치
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# 현재 사용자를 docker 그룹에 추가
sudo usermod -a -G docker ubuntu

# Docker Compose 설치
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Docker 서비스 시작
sudo systemctl start docker
sudo systemctl enable docker

# AWS CLI v2 설치 (ARM64용)
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
sudo rm -rf aws awscliv2.zip

# 프로젝트 디렉토리 생성
sudo mkdir -p /home/ubuntu/board_game_app
cd /home/ubuntu/board_game_app

# Docker Compose 파일 생성
sudo cat > docker-compose.yml << 'COMPOSE'
version: '3.8'

services:
  # Board Game Server
  board_game_server:
    image: 298483610289.dkr.ecr.ap-south-1.amazonaws.com/dev_frog:dev_latest
    ports:
      - "8080:8080"
    environment:
      - ENV=development
      - PORT=8080
      - DATABASE_URL=mysql://root:examplepassword@mysql:3306/dev_frog
      - REDIS_URL=redis://redis:6379
    depends_on:
      - mysql
      - redis
    networks:
      - board_game_network

  # MySQL Database
  mysql:
    image: mysql:8.0
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: examplepassword
      MYSQL_DATABASE: dev_frog
      MYSQL_USER: board
      MYSQL_PASSWORD: examplepassword
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - board_game_network

  # Redis (추가로 필요할 수 있음)
  redis:
    image: redis:7-alpine
    container_name: redis
    command: >
      redis-server
      --requirepass examplepassword
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - board_game_network

  # Promtail (로그 수집)
  promtail:
    image: grafana/promtail:latest
    ports:
      - "9080:9080"
    volumes:
      - /var/log:/var/log
      - ./promtail-config.yml:/etc/promtail/config.yml
    command: -config.file=/etc/promtail/config.yml
    networks:
      - board_game_network

  # Grafana (모니터링 대시보드)
  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana_data:/var/lib/grafana
    networks:
      - board_game_network

  # Loki (로그 저장소)
  loki:
    image: grafana/loki:latest
    ports:
      - "3100:3100"
    command: -config.file=/etc/loki/local-config.yaml
    volumes:
      - loki_data:/loki
    networks:
      - board_game_network

  # RabbitMQ (메시지 큐)
  rabbitmq:
    image: rabbitmq:3-management
    container_name: rabbitmq
    ports:
      - "5672:5672"     # AMQP 포트
      - "15672:15672"   # 관리 웹 UI 포트
    environment:
      RABBITMQ_DEFAULT_USER: board
      RABBITMQ_DEFAULT_PASS: examplepassword
    volumes:
      - rabbitmq_data:/var/lib/rabbitmq
    networks:
      - board_game_network

volumes:
  mysql_data:
  grafana_data:
  loki_data:
  redis_data:
  rabbitmq_data:

networks:
  board_game_network:
    driver: bridge
COMPOSE

# Promtail 설정 파일 생성
sudo cat > promtail-config.yml << 'PROMTAIL'
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          __path__: /var/log/*log

  - job_name: containers
    static_configs:
      - targets:
          - localhost
        labels:
          job: containerlogs
          __path__: /var/lib/docker/containers/*/*log
PROMTAIL

# Loki 설정 파일 생성
sudo cat > loki-config.yaml << 'LOKI'
auth_enabled: false

server:
  http_listen_port: 3100

ingester:
  lifecycler:
    address: 127.0.0.1
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
    final_sleep: 0s
  chunk_idle_period: 5m,30s
  chunk_retain_period: 30s

schema_config:
  configs:
    - from: 2020-05-15
      store: boltdb
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

storage_config:
  boltdb:
    directory: /tmp/loki/index

  filesystem:
    directory: /tmp/loki/chunks

limits_config:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h
LOKI

# ECR 컨테이너 실행 스크립트 생성
sudo cat > /home/ubuntu/server_start.sh << 'SCRIPT'
#!/bin/bash

# 변수 설정
AWS_REGION="ap-south-1"
REPOSITORY="298483610289.dkr.ecr.$AWS_REGION.amazonaws.com/dev_frog"
TAG="dev_latest"
CONTAINER_NAME="dev_frog_container"
PORT="8080"

echo "[1/4] ECR 로그인 중..."
aws ecr get-login-password --region $AWS_REGION | \
  sudo docker login --username AWS \
  --password-stdin 298483610289.dkr.ecr.$AWS_REGION.amazonaws.com

if [ $? -ne 0 ]; then
  echo "❌ ECR 로그인 실패"
  exit 1
fi

echo "[2/4] Docker 이미지 pull 중..."
sudo docker pull $REPOSITORY:$TAG

if [ $? -ne 0 ]; then
  echo "❌ Docker 이미지 pull 실패"
  exit 1
fi

echo "[3/4] 기존 컨테이너 정리..."
sudo docker rm -f $CONTAINER_NAME 2>/dev/null

echo "[4/4] 컨테이너 실행 중..."
sudo docker run -d \
  --name $CONTAINER_NAME \
  -p $PORT:$PORT \
  $REPOSITORY:$TAG

if [ $? -eq 0 ]; then
  echo "✅ 컨테이너 '$CONTAINER_NAME' 실행 완료!"
else
  echo "❌ 컨테이너 실행 실패"
fi
SCRIPT

# Docker Compose 실행 스크립트 생성
sudo cat > /home/ubuntu/docker_compose_start.sh << 'COMPOSE_SCRIPT'
#!/bin/bash

# ECR 로그인
echo "ECR 로그인 중..."
aws ecr get-login-password --region ap-south-1 | \
  sudo docker login --username AWS \
  --password-stdin 298483610289.dkr.ecr.ap-south-1.amazonaws.com

if [ $? -ne 0 ]; then
  echo "❌ ECR 로그인 실패"
  exit 1
fi

echo "Docker Compose로 서비스 시작 중..."
cd /home/ubuntu/board_game_app
sudo docker-compose up -d

if [ $? -eq 0 ]; then
  echo "✅ Docker Compose 서비스 시작 완료!"
  echo "📊 Grafana: http://localhost:3000 (admin/admin)"
  echo "🐰 RabbitMQ: http://localhost:15672 (board/examplepassword)"
  echo "📈 Promtail: http://localhost:9080"
  echo "📊 Loki: http://localhost:3100"
else
  echo "❌ Docker Compose 서비스 시작 실패"
fi
COMPOSE_SCRIPT

# 스크립트 실행 권한 부여
sudo chmod +x /home/ubuntu/server_start.sh
sudo chmod +x /home/ubuntu/docker_compose_start.sh

# ubuntu 소유권 변경
sudo chown ubuntu:ubuntu /home/ubuntu/server_start.sh
sudo chown ubuntu:ubuntu /home/ubuntu/docker_compose_start.sh
sudo chown -R ubuntu:ubuntu /home/ubuntu/board_game_app

echo "Docker installation completed!"
echo "ECR container script created at: /home/ubuntu/server_start.sh"
echo "Docker Compose script created at: /home/ubuntu/docker_compose_start.sh"
echo "To run ECR container: ./server_start.sh"
echo "To run Docker Compose: ./docker_compose_start.sh" 