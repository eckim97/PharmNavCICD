# Pharmacy-Recommendation   
이 프로젝트는 [외부 API(카카오 주소 검색 API)](https://developers.kakao.com/docs/latest/ko/local/dev-guide)와 [공공 데이터(약국 현황 정보)](https://www.data.go.kr/data/15065023/fileData.do)를 활용하여 실제 서비스로 제공할 수 있는 수준의 약국 추천 시스템을 구현합니다. 추천된 약국의 길 안내는 [카카오 지도 및 로드뷰 바로가기 URL](https://apis.map.kakao.com/web/guide/#routeurl)로 제공됩니다.

## 목차
1. [요구사항 분석](#요구사항-분석)
2. [프로세스 흐름도](#프로세스-흐름도)
3. [주요 기능](#주요-기능)
4. [기술 스택](#기술-스택)
5. [결과 화면](#결과-화면)
6. [데모 페이지](#데모-페이지)
7. [실행 방법](#실행-방법)

## 요구사항 분석 
- 약국 현황 데이터(공공 데이터)를 관리하며, 데이터는 위도와 경도 정보를 포함합니다.
- 사용자가 입력한 주소 정보를 기반으로 가까운 약국 3곳을 추천합니다.
- 주소 입력 및 처리:
  - 도로명 주소 또는 지번 주소를 입력받습니다.
  - [Kakao 우편번호 서비스](https://postcode.map.daum.net/guide)를 사용하여 정확한 주소 입력을 유도합니다.
  - 상세 주소(동, 호수)를 제외한 주소 정보만 사용합니다. (예: 서울 성북구 종암로 10길)
  - 입력받은 주소를 위도, 경도로 변환합니다.
- 거리 계산 및 약국 추천:
  - [Haversine formula](https://en.wikipedia.org/wiki/Haversine_formula)를 사용하여 두 위경도 좌표 간 거리를 계산합니다.
  - 지구가 완전한 구형이 아니므로 미세한 오차가 있을 수 있습니다.
  - 입력한 주소로부터 반경 10km 내의 약국만 추천 대상으로 합니다.
- 추천 결과 제공:
  - 추출한 약국 데이터에 대해 길안내 URL 및 로드뷰 URL을 제공합니다.
    - 길안내 URL 예시: https://map.kakao.com/link/map/우리회사,37.402056,127.108212
    - 로드뷰 URL 예시: https://map.kakao.com/link/roadview/37.402056,127.108212
  - 가독성을 위해 길안내 URL은 단축 URL(shorten URL) 형태로 제공합니다.
- 단축 URL 처리:
  - Base62 인코딩을 사용하여 URL의 key 값을 생성합니다.
  - 단축 URL 예시: http://localhost:8080/dir/nqxtX
  - 단축 URL의 유효 기간은 30일로 제한합니다.

## 프로세스 흐름도
### Pharmacy Recommendation Process
<img width="615" alt="약국 추천 프로세스" src="https://user-images.githubusercontent.com/26623547/177694773-b53d1251-652f-41e6-8f19-c32b931d4b5b.png">

### Direction Shorten URL Process
<img width="615" alt="URL 단축 프로세스" src="https://user-images.githubusercontent.com/26623547/175301168-ee35793c-18ff-4a4a-8610-7a9455e9fef7.png">

## Feature List   
- Spring Data JPA를 이용한 CRUD 메서드 구현      
- Spock를 이용한 테스트 코드 작성     
- Testcontainers를 이용하여 독립 테스트 환경 구축
- 카카오 API 연동 (주소 검색, 지도 URL)  
- 공공 데이터를 활용 (약국 현황 데이터)
- Handlebars를 이용한 프론트엔드 구현  
- Docker를 사용한 다중 컨테이너 애플리케이션 구성  
- AWS EC2를 이용한 클라우드 배포
- Spring Retry를 이용한 재처리 구현 (카카오 API의 네트워크 오류 등)   
- Base62를 이용한 shorten url 개발 (길안내 URL)   
- Redis를 이용하여 성능 최적화하기

## Tech Stack   
- JDK 17
- Spring Boot 2.6.7
- Spring Data JPA
- Gradle
- Handlebars
- Lombok
- Github
- Docker
- AWS EC2
- Redis
- MariaDB
- Spock   
- Testcontainers

## Result   
**약국 추천**
<img width="100%" alt="PharmResult1" src="https://github.com/eckim97/-Github-User-Content/blob/main/PharmResult1.jpeg">

**약국 추천 결과**
<img width="100%" alt="PharmResult2" src="https://github.com/eckim97/-Github-User-Content/blob/main/PharmResult2.jpeg">

**길안내**
<img width="100%" alt="PharmResult3" src="https://raw.githubusercontent.com/eckim97/-Github-User-Content/main/PharmResult3.png">

**로드뷰**
<img width="100%" alt="PharmResult4" src="https://github.com/eckim97/-Github-User-Content/blob/main/PharmResult4.jpeg">
## 데모 페이지
http://13.124.212.102/

## 실행 방법
1. 프로젝트 클론
- `git clone https://github.com/eckim97/Pharmacy-Recommendation.git`

2. 환경 설정
- Project Structure에서 `JDK`를 `17`로 설정
- 프로젝트 루트에 `.env` 파일 생성:
  ```
  SPRING_DATASOURCE_USERNAME=root
  SPRING_DATASOURCE_PASSWORD=1234
  SPRING_PROFILES_ACTIVE=prod
  KAKAO_REST_API_KEY=[KAKAO_REST_API키]
  ```
- 메인 애플리케이션의 `Edit Configurations`에 환경변수 추가:
  ```
  SPRING_DATASOURCE_USERNAME=root
  SPRING_DATASOURCE_PASSWORD=1234
  KAKAO_REST_API_KEY=[KAKAO_REST_API키]
  ```

3. 애플리케이션 빌드
- `./gradlew clean build -x test`
  
4. Docker 컨테이너 실행
- `docker-compose -f docker-compose-local.yml up --build`

5. 애플리케이션 접속
- 웹 브라우저에서 `http://localhost:8080` 접속
참고
- KAKAO_REST_API_KEY는 실제 발급받은 키로 교체해야 합니다.
- 로컬 개발 환경에서는 `docker-compose-local.yml`을 사용합니다.
