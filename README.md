# LH02_frontend
LH02 해커톤 공통 프론트엔드 — 이미지·텍스트 입력, 지도 API, AI 분석 결과 화면

## 팀 공통 기본 실행 환경

현재 앱은 2-1-1부터 2-1-3까지 입력한 한 사람의 출발 위치, 선호, 비선호를 빠른 장소 추천 API로 전송합니다.

### Flutter 버전과 설치 확인

- 팀 공통 기준: **Flutter 3.44.7 stable**, Framework revision `84fc5cbb22`
- Dart: 위 Flutter에 포함된 **Dart 3.12.2** 사용
- SDK를 임의로 업그레이드하거나 Dart를 별도로 설치하지 않습니다.
- Flutter SDK 3.44.7을 준비하고 SDK의 `bin` 폴더를 Windows 사용자 PATH에 추가한 뒤 PowerShell을 다시 엽니다.
- 현재 PC의 SDK 경로는 `C:\Users\USER\flutter`입니다. 팀원의 설치 경로는 달라도 됩니다.

현재 PowerShell에서만 PATH를 설정하려면 아래 명령을 실행합니다. 설치 위치가 다르면 경로를 바꾸세요.

```powershell
$env:Path = "C:\Users\USER\flutter\bin;$env:Path"
flutter --version
flutter doctor
```

`flutter --version`에서 위 Flutter/Dart 버전을 확인합니다. `flutter doctor`의 Chrome 항목이 정상이어야 웹을 실행할 수 있습니다. Android 라이선스 문제는 Chrome 웹 실행을 막지 않습니다.

### 의존성 설치와 Chrome 실행

PowerShell에서 저장소 루트(본인 PC의 경로에 맞게 변경)로 이동합니다.

```powershell
Set-Location C:\limit_ai\LH02_frontend
flutter pub get
flutter run -d chrome --web-port 5173 --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

브라우저에서 기본 문구를 확인합니다. 터미널에서 `q`를 누르면 실행이 종료됩니다. 앱 프로젝트의 `pubspec.lock`은 팀의 의존성 버전을 공유하기 위해 Git에 포함합니다.

### 분석, 테스트, 웹 빌드

```powershell
flutter analyze
flutter test
flutter build web
```

웹 빌드 결과는 `build\web`에 생성되며 Git에 포함하지 않습니다.

추천 요청 이름은 `AppConfig.memberName`이며 기본값은 `사용자`입니다. 실행 시 `--dart-define=MEMBER_NAME=지민`처럼 지정할 수 있습니다.

### 백엔드 주소 설정

백엔드는 별도로 실행해야 합니다. `lib/config/app_config.dart`의 `AppConfig.apiBaseUrl`은 `String.fromEnvironment`로 `API_BASE_URL`을 읽으며 기본값은 `http://127.0.0.1:8000`입니다. 2-1-3에서 다음을 누르면 `POST /api/recommend/quick`을 호출합니다. Android 에뮬레이터에서는 127.0.0.1을 10.0.2.2로 자동 변환합니다.

`127.0.0.1`은 앱을 실행하는 컴퓨터 자신을 가리킵니다. 팀원의 백엔드를 연결하려면 해당 팀원 PC의 접근 가능한 IP와 포트를 사용합니다. 예를 들어:

```powershell
flutter run -d chrome --web-port 5173 --dart-define=API_BASE_URL=http://192.168.0.10:8000
```

배포 서버를 연결할 때는 실제 서버 주소로 바꿉니다.

```powershell
flutter run -d chrome --web-port 5173 --dart-define=API_BASE_URL=https://api.example.com
flutter build web --dart-define=API_BASE_URL=https://api.example.com
```

위 주소는 예시입니다. `--dart-define`은 실행/빌드 시 적용되므로 주소를 변경하면 다시 실행하거나 빌드합니다.

웹에서 백엔드를 호출할 때는 백엔드에서 CORS를 설정하여 프론트엔드 origin(로컬 Chrome 실행은 `http://localhost:5173`)을 허용해야 합니다. 팀원 백엔드는 네트워크에서 접근할 수 있도록 별도로 실행되어 있어야 합니다.

네이버 API 키는 백엔드에서만 관리합니다. 프론트 코드, 설정, `--dart-define`에 비밀 키를 넣지 않습니다. 프론트 빌드에 포함된 설정 값은 사용자에게 공개됩니다.

### 백엔드 연결 확인

백엔드 프로젝트에서 `uvicorn app.main:app --reload --port 8000`을 실행한 뒤 확인합니다. iOS 앱 빌드 명령은 백엔드 서버를 실행하지 않습니다.

```bash
curl http://127.0.0.1:8000/health
```

현재 기본 추천 API는 `POST /api/recommend/quick`입니다. 출발 장소·선호·비선호를 자연어로 합쳐 `{"people":[{"name":"나","text":"노원역에서 출발해요. 원하는 약속: 파스타. 피하고 싶은 약속: 시끄러운 곳."}]}` 형식으로 보냅니다. 응답의 `recommendations`를 목록에 표시하고 선택한 장소의 추천 이유·예상 이동 시간을 상세 화면에 전달합니다. 요청 실패 시 입력 화면에 남고 서버의 오류 안내를 표시합니다.

`API_BASE_URL`이나 `API_RECOMMENDATION_PATH`를 변경하면 앱을 완전히 종료하고 다시 실행하세요. Hot reload만으로는 `--dart-define` 값이 바뀌지 않습니다. 예를 들어:

```bash
API_BASE_URL=http://127.0.0.1:8000 API_RECOMMENDATION_PATH=/api/recommend/quick ./scripts/ios.sh run <iOS_DEVICE_ID>
```

`/health`는 정상인데 `NO_LOCATION`이나 `MAP_ERROR`가 나오면 백엔드의 네이버 지역검색/Maps 키 설정을 확인합니다. `backnew/Backend`의 설정은 기존 `NAVER_CLIENT_ID`, `NAVER_CLIENT_SECRET`, `NCP_MAPS_KEY_ID`, `NCP_MAPS_KEY`와 `.env`의 `NAVER_SEARCH_CLIENT_ID`, `NAVER_SEARCH_CLIENT_SECRET`, `NCP_MAPS_CLIENT_ID`, `NCP_MAPS_CLIENT_SECRET` 이름을 모두 지원합니다. 비밀 키 값은 백엔드 `.env`에서만 관리합니다.

## iOS 빌드와 실행 (macOS)

Flutter **3.44.7 / Dart 3.12.2**, Xcode와 iOS 시뮬레이터 런타임이 필요합니다. `ios/Runner.xcworkspace`가 iOS 프로젝트이며, 최소 지원 버전은 `file_picker_darwin` 의존성에 맞춘 **iOS 14.0**입니다. Flutter의 Swift Package Manager로 플러그인을 연결하므로 현재 프로젝트는 `pod install`이 필요하지 않습니다.

```bash
export PATH="$HOME/flutter/bin:$PATH" # Flutter 설치 위치에 맞게 변경
flutter --version
flutter doctor -v
flutter pub get
open -a Simulator
flutter devices
```

### 시뮬레이터 빌드 / 실행

추천 장소의 마지막 상세 페이지는 백엔드 응답의 `place.lat`, `place.lng`로 iOS 기본 지도(MapKit)를 바로 표시합니다. 선택한 장소에 핀을 표시하며 지도를 이동하거나 확대할 수 있습니다. 별도의 지도 API 키나 현재 위치 권한은 필요하지 않습니다. 좌표가 없는 응답은 위치 정보 안내를 표시합니다.

```bash
./scripts/ios.sh simulator
./scripts/ios.sh run <flutter_devices에_표시된_iOS_DEVICE_ID>
```

스크립트는 의존성을 준비한 뒤 iOS 빌드 구성을 재생성합니다. 시뮬레이터 Debug 빌드는 Apple 계정이나 서명이 필요하지 않습니다. 결과는 `build/ios/iphonesimulator/Runner.app`에 생성됩니다. 같은 Mac의 백엔드 기본 주소는 `http://127.0.0.1:8000`입니다. 다른 서버를 연결하려면:

```bash
API_BASE_URL=http://192.168.0.10:8000 ./scripts/ios.sh run <iOS_DEVICE_ID>
```

`API_RECOMMENDATION_PATH`도 환경 변수로 지정할 수 있습니다. 스크립트는 이 두 공개 설정을 `--dart-define`으로 전달합니다. iOS 설정에는 로컬 네트워크 연결 허용과 한국어 권한 설명을 추가했습니다. 일반 인터넷 서버는 HTTPS를 사용합니다. [Apple 로컬 네트워크 ATS 설정](https://developer.apple.com/documentation/bundleresources/information-property-list/nsapptransportsecurity/nsallowslocalnetworking)

### 실제 iPhone / 배포 빌드

```bash
open ios/Runner.xcworkspace
```

Xcode의 **Runner → Signing & Capabilities**에서 자신의 **Team**을 선택하고 **Automatically manage signing**을 켭니다. 기본 Bundle Identifier는 `com.example.lh02Frontend`이며 배포 전 본인의 고유 ID로 변경합니다. 실제 iPhone을 연결하고 개발자 모드를 활성화한 뒤 `flutter devices`의 ID로 실행합니다. iPhone에서 `127.0.0.1`은 iPhone 자신이므로, Mac 백엔드는 같은 Wi-Fi의 Mac LAN IP를 사용하고 서버가 `0.0.0.0`에 바인딩되어 있어야 합니다.

```bash
# 실기기용 Release 컴파일 확인 (서명 없음, iPhone에 직접 설치 불가)
API_BASE_URL=https://api.example.com ./scripts/ios.sh device

# Xcode 서명 설정 후 배포 아카이브와 IPA 생성
API_BASE_URL=https://api.example.com ./scripts/ios.sh ipa
```

위 HTTPS 주소는 실제 백엔드로 바꿉니다. Release 명령은 HTTPS 주소를 필수로 받습니다. IPA는 Apple 배포 인증서와 프로비저닝 설정이 필요하며, 결과는 `build/ios/archive`와 `build/ios/ipa`에 생성됩니다. [Flutter iOS 배포 안내](https://docs.flutter.dev/deployment/ios)

`./scripts/ios.sh --help`로 명령을 확인할 수 있습니다. `ios/Flutter/Generated.xcconfig`, `ios/Flutter/ephemeral`, Xcode 사용자 설정과 빌드 결과는 Git에서 제외합니다.

Xcode가 Swift 패키지 최소 버전이나 캐시 불일치 오류를 내면 생성 파일을 정리하고 다시 빌드합니다.

```bash
flutter clean
./scripts/ios.sh simulator
```
