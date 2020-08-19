# basicflutter

해당 Flutter 플러터 코드는 basicexpress( https://github.com/doyle-flutter/basicexpress )와 함께 보셔야 합니다.
코드에 충분한 의도를 담아 표현하고 싶었지만 빠른 기간내 업로드하는 목표로 작업하고 있기 때문에 코드 레벨이 조금 부족할 수 있는 점 미리 양해부탁드립니다.
안드로이드 및 아이폰에서 동시에 적용/테스트 가능합니다.

## 일정
 - 8/19 (1) : GeoLocation 위치
 - 8/18 (1) : webRTC(And : Intent Chrome / IOS : Safari 일부 지원)
 - 8/17 (1) : FCM 코드 배포
 - 8/15 (1) : FCM And & IOS 과 채팅 적용 예정
 - 8/14 (1) : Local DB SharedPreferences & 카카오 로그인 적용(임시 구현)
 - 8/13 (2) : 카카오톡 로그인(토큰까지 구현 중) & WebView 적용
 - 8/13 (1) : Local notification 로직 및 Socket 채팅 알림으로 사용(채팅 페이지 및 메인 페이지에서 알림)
 - 8/12 (2) : 카메라 & 앨범 사용 및 다중 이미지 파일 업로드 구현(express multer 지원) 로직 분리 필요
 - 8/12 (1) : SQflite CRUD 구현

## 목록
 - [x] 서버 및 데이터베이스 연결 : Node.js( https://github.com/doyle-flutter/basicexpress )
 - [x] mysql CRUD 구현
 - [x] Local DB : Sqflite CRUD
 - [x] Local DB : SharedPreferences & 카카오 로그인 토큰 사용
 - [x] socket.io를 통한 채팅 구현
 - [x] 카메라 & 앨범 사용 및 express multer를 이용한 이미지 업로드(단일 업로드 구현 / 다중 업로드 구현) ... 아이폰의 경우 실제 기기를 이용해야 카메라 접근이 수월 합니다
 - [x] SNS 로그인
 - [x] WebView( SNS와 함께 사용 )
 - [x] Local Notification 구현 : Socket Chat과 연결하였습니다
 (LocalNotification은 앱이 활성화 상태에서만 동작하므로 종료시에도 작업하기 위해서는 FCM 사용해야합니다, And/IOS 테스크까지는 동작하지만 완전 종료(백그라운드)에서는 동작하지 않습니다)
 - [x] FCM Push MSG : And & IOS 적용 코드 배포 / 여러 설정 및 부수적인 작업이 필요합니다
 - [x] webRtc를 이용한 영상 통화,채팅 (구현 예정)
 - [ ] Geolocation : 위치(위경도) / IOS 기기 테스트
 - [ ] foreground_service : notification background(예정)
 - [ ] 오디오 또는 비디오 스트리밍 : (예정)
 - [ ] GraphQL : (예정) express-graphQL
 - [ ] 예외 처리 : (예정)
 - [ ] 배포 된 express 서버를 이용하여 마켓 출시(구글 및 애플) : 배포를 희망하는 플랫폼의 개발자 계정을 구매해주셔야 합니다
