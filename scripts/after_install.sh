#!/bin/bash
# 필요한 설정 작업 수행
cd /home/ec2-user/Pharmacy-Recommendation
chmod +x gradlew
./gradlew clean build -x test