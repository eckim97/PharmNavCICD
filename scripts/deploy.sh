#!/bin/bash

# 프로젝트 설정
PROJECT_NAME="Pharmacy-Recommendation"
REPOSITORY="/home/ec2-user/$PROJECT_NAME"
JAR_PATH="$REPOSITORY/build/libs/*.jar"
DEPLOY_LOG_PATH="$REPOSITORY/deploy.log"
DEPLOY_ERR_LOG_PATH="$REPOSITORY/deploy_err.log"
APPLICATION_LOG_PATH="$REPOSITORY/application.log"

# 로그 시작
echo "===== 배포 시작 : $(date +%c) =====" >> $DEPLOY_LOG_PATH

# JAR 파일 찾기
JAR_NAME=$(ls -tr $JAR_PATH | tail -n 1)
echo "> build 파일명: $JAR_NAME" >> $DEPLOY_LOG_PATH

# 현재 실행 중인 애플리케이션 종료
echo "> 현재 실행 중인 애플리케이션 pid 확인" >> $DEPLOY_LOG_PATH
CURRENT_PID=$(pgrep -f ${PROJECT_NAME}.*.jar)
if [ -z "$CURRENT_PID" ]; then
    echo "> 현재 실행 중인 애플리케이션이 없습니다." >> $DEPLOY_LOG_PATH
else
    echo "> kill -15 $CURRENT_PID" >> $DEPLOY_LOG_PATH
    kill -15 $CURRENT_PID
    sleep 5
fi

# 새 애플리케이션 배포
echo "> 새 애플리케이션 배포" >> $DEPLOY_LOG_PATH

# Docker Compose 사용 시 (선택적)
if [ -f "$REPOSITORY/docker-compose.yml" ]; then
    echo "> Docker Compose 재시작" >> $DEPLOY_LOG_PATH
    cd $REPOSITORY
    docker-compose down
    docker-compose up -d
else
    # JAR 파일 직접 실행
    echo "> JAR 파일 직접 실행" >> $DEPLOY_LOG_PATH
    nohup java -jar $JAR_NAME > $APPLICATION_LOG_PATH 2> $DEPLOY_ERR_LOG_PATH &
fi

# 배포 완료 로그
echo "> 새 애플리케이션 배포 완료 : $(date +%c)" >> $DEPLOY_LOG_PATH