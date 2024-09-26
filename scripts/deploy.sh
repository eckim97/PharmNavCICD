#!/bin/bash

# 프로젝트 설정
PROJECT_NAME="Pharmacy-Recommendation"
REPOSITORY="/home/ec2-user/$PROJECT_NAME"
DEPLOY_LOG_PATH="$REPOSITORY/deploy.log"

# 로그 시작
echo "===== 배포 시작 : $(date +%c) =====" >> $DEPLOY_LOG_PATH

# 새 애플리케이션 배포
echo "> 새 애플리케이션 배포" >> $DEPLOY_LOG_PATH

# Docker Compose 실행
echo "> Docker Compose 빌드 및 실행" >> $DEPLOY_LOG_PATH
cd $REPOSITORY
docker-compose down
docker-compose up --build -d

# 배포 완료 로그
echo "> 새 애플리케이션 배포 완료 : $(date +%c)" >> $DEPLOY_LOG_PATH