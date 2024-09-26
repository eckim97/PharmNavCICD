#!/bin/bash

set -e  # 오류 발생 시 스크립트 중단

LOG_FILE="/home/ec2-user/deploy.log"

log() {
    echo "$(date): $1" | tee -a $LOG_FILE
}

execute_with_timeout() {
    timeout 60 $1
    if [ $? -eq 124 ]; then
        log "Command timed out: $1"
        exit 1
    elif [ $? -ne 0 ]; then
        log "Command failed: $1"
        exit 1
    fi
}

log "Deployment started"

# 프로젝트 디렉토리로 이동
cd /home/ec2-user/Pharmacy-Recommendation
log "Changed to project directory"

# .env 파일 로드
if [ -f .env ]; then
    set -a
    source .env
    set +a
    log "Loaded environment variables from .env file"
else
    log "Error: .env file not found"
    exit 1
fi

# 환경 변수 확인
log "Environment variables:"
for var in SPRING_DATASOURCE_USERNAME SPRING_DATASOURCE_PASSWORD SPRING_PROFILES_ACTIVE KAKAO_REST_API_KEY
do
    if [ -n "${!var}" ]; then
        log "$var is set"
    else
        log "Error: $var is not set"
        exit 1
    fi
done

# Gradle 관련 디렉토리 및 파일에 대한 권한 설정
log "Setting permissions for Gradle files"
execute_with_timeout "sudo chown -R ec2-user:ec2-user ."
execute_with_timeout "sudo chmod -R 755 ."
execute_with_timeout "sudo find . -type d -exec chmod 755 {} \;"
execute_with_timeout "sudo find . -type f -exec chmod 644 {} \;"
execute_with_timeout "sudo chmod +x ./gradlew"
log "Permissions set"

# Gradle 환경 설정
export GRADLE_USER_HOME=/home/ec2-user/.gradle
log "Gradle environment set"

# Gradle 빌드 실행 (테스트 제외)
log "Starting Gradle build"
execute_with_timeout "./gradlew build -x test --no-daemon --parallel"
log "Gradle build completed"

# 기존 컨테이너 중지 및 제거
log "Stopping and removing existing containers"
execute_with_timeout "docker-compose down"
log "Existing containers stopped and removed"

# Docker Compose로 애플리케이션 시작
log "Starting application with Docker Compose"
execute_with_timeout "docker-compose up --build -d"
log "Application started"

# 애플리케이션 상태 확인
log "Checking application status"
sleep 10  # 애플리케이션이 시작될 때까지 잠시 대기
if curl -f http://localhost:80 > /dev/null 2>&1; then
    log "Application is running"
else
    log "Error: Application failed to start"
    exit 1
fi

log "Deployment completed successfully"