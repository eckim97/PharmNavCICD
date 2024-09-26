#!/bin/bash

# 프로젝트 디렉토리로 이동
cd /home/ec2-user/Pharmacy-Recommendation

# 이전 배포 정리
/usr/local/bin/docker-compose down

# gradlew 파일의 소유자를 ec2-user로 변경
sudo chown ec2-user:ec2-user gradlew

# gradlew에 실행 권한 부여
chmod +x gradlew

# Gradle 캐시 디렉토리의 소유자를 ec2-user로 변경
sudo chown -R ec2-user:ec2-user .gradle

# Gradle 빌드 실행
./gradlew clean build -x test

# 애플리케이션 시작
/usr/local/bin/docker-compose up --build -d

echo "Deployment completed successfully"