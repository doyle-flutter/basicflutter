# basicflutter

해당 Flutter 플러터 코드는 basicexpress( https://github.com/doyle-flutter/basicexpress )와 basicDjangoPython(https://github.com/doyle-flutter/basicDjangoPython) 의 서버 사이드와 함께 보셔야 합니다.
초급 ~ 중급 대상이므로 입문자인 경우 영상([유튜브](https://youtube.com/playlist?list=PLIKnSA4GMR4NXpNdCtJOL0BhWcxX_BBHJ))을 통해 먼저 보시면 좋습니다.
모든 내용 안드로이드 및 아이폰(에뮬레이터 및 실제 기기)에서 동시에 적용/테스트 가능합니다.

## 목록
 - [x] 서버 및 데이터베이스 연결 : Node.js(Express.js) - [서버 코드 바로가기](https://github.com/doyle-flutter/basicexpress)
 - [x] mysql CRUD 구현
 - [x] Redis 직접 연결 - [Flutter Code](https://github.com/doyle-flutter/basicflutter/blob/master/lib/redisExample/redisSample.dart) / [설치 및 실행 for MAC](https://github.com/doyle-flutter/basicflutter/blob/master/lib/redisExample/redisSETUP.txt)
 - [x] Redis + Node.js - [Flutter Code](예정) / [Node Code](https://github.com/doyle-flutter/basicexpress/blob/master/redisserver.js)
 - [x] Local DB : Sqflite CRUD
 - [x] Local DB : SharedPreferences & 카카오 로그인 토큰 사용
 - [x] socket.io를 통한 채팅 구현
 - [x] 카메라 & 앨범 사용 및 express multer를 이용한 이미지 업로드(단일 업로드 구현 / 다중 업로드 구현) ... 아이폰의 경우 실제 기기를 이용해야 카메라 접근이 수월 합니다
 - [x] SNS 로그인
 - [x] WebView( SNS 로그인과 함께 사용 )
 - [x] WebView & Express.js / Vue.js
 - [x] Local Notification 구현 : Socket Chat과 연결하였습니다
 (LocalNotification은 앱이 활성화 상태에서만 동작하므로 종료시에도 작업하기 위해서는 FCM 사용해야합니다, And/IOS 테스크까지는 동작하지만 완전 종료(백그라운드)에서는 동작하지 않습니다)
 - [x] FCM Push MSG : And & IOS 적용 코드 배포 / 여러 설정 및 부수적인 작업이 필요합니다
 - [x] webRtc를 이용한 영상 통화,채팅(안드로이드 가능 / IOS 사파리에서 일부 가능)
 - [x] Geolocation : 위치(위경도) 한번 & 지속 확인 / IOS 기기 테스트
 - [x] GraphQL : HTTP(s) || GraphQL 패키지 사용
 - [x] foreground_service : notification background(안드로이드만 사용 가능 / apk --debug 가능)
 - [x] 오디오 또는 비디오 스트리밍 : MP3 안드로이드 및 아이폰 테스트 완료
 - [x] 예외 처리 : 일부
 - [x] Django 및 Express.js(Node.js)를 활용한 카카오 페이 직접 연동
 - [x] GetX : [(1) State - Code](https://github.com/doyle-flutter/basicflutter/blob/master/lib/views/GetXPage.dart) / (2) [Navigation - Code](https://github.com/doyle-flutter/basicflutter/blob/master/lib/main.dart) / (3) [HTTP - Code](https://github.com/doyle-flutter/basicflutter/blob/master/lib/views/GetXHttpPage.dart) / (4) Socket.io - Code...

## Project
 - 전자 공시 시스템 : 최근 3개월 공시 기업 내용 조회 어플(입문자 (Code...))

## 일정
 - 11/15 : Node.js + Redis DB 연결(Android & IOS 완료)
 - 11/14 : Redis DB 직접 연결(IOS 테스트)
 - 10/16~17 : Django 및 Express.js(Node.js)를 활용한 카카오 페이 직접 연동
 - 9/10 : 보조 서버를 활용
 - 8/27 : express Vue.js 페이지 WebView 활용
 - 8/26 : express multer를 이용한 영상 업로드 / 사진첩(영상) 활용
 - 8/23 : Streaming MP3 안드로이드 및 아이폰 테스트 완료
 - 8/21 : 안드로이드 포그라운드(foreground_service / notification background)
 - 8/20 : GraphQL HTTP(s) || GraphQL 패키지 사용 둘 다 적용 가능
 - 8/19 : GeoLocation 위치(IOS는 실제 기기에서만 가능하므로 가상 기기에서는 예외처리 구현)
 - 8/18 : webRTC(And : Chrome / IOS : Safari 일부 지원)
 - 8/17 : FCM 코드 배포
 - 8/15 : FCM And & IOS 과 채팅 적용 예정
 - 8/14 (1) : Local DB SharedPreferences & 카카오 로그인 적용(임시 구현)
 - 8/13 (2) : 카카오톡 로그인(토큰까지 구현 중) & WebView 적용
 - 8/13 (1) : Local notification 로직 및 Socket 채팅 알림으로 사용(채팅 페이지 및 메인 페이지에서 알림)
 - 8/12 (2) : 카메라 & 앨범 사용 및 다중 이미지 파일 업로드 구현(express multer 지원) 로직 분리 필요
 - 8/12 (1) : SQflite CRUD 구현
