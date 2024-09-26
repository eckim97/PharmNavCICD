#!/bin/bash

set -e  # 오류 발생 시 스크립트 중단

LOG_FILE="/home/ec2-user/deploy.log"

log() {
    echo "$(date): $1" | tee -a $LOG_FILE
}

log "Deployment started"

# 프로젝트 디렉토리로 이동
cd /home/ec2-user/Pharmacy-Recommendation
log "Changed to project directory"

# Gradle 관련 디렉토리 및 파일에 대한 권한 설정
log "Setting permissions for Gradle files"
sudo chown -R ec2-user:ec2-user .
sudo chmod -R 755 .
sudo find . -type d -exec chmod 755 {} \;
sudo find . -type f -exec chmod 644 {} \;
sudo chmod +x ./gradlew

# Gradle 빌드 실행 (테스트 제외)
log "Starting Gradle build"
./gradlew clean build -x test
log "Gradle build completed"

# Docker Compose로 애플리케이션 시작
log "Starting application with Docker Compose"
docker-compose up --build -d
log "Application started"

log "Deployment completed successfully"