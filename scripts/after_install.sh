#!/bin/bash
# 필요한 설정 작업 수행
cd /home/ec2-user/Pharmacy-Recommendation

# gradlew 파일의 소유자를 ec2-user로 변경
sudo chown ec2-user:ec2-user gradlew

# gradlew에 실행 권한 부여
chmod +x gradlew

# Gradle 캐시 디렉토리의 소유자를 ec2-user로 변경
sudo chown -R ec2-user:ec2-user .gradle

# Gradle 빌드 실행
./gradlew clean build -x test