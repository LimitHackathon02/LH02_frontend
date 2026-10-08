# LH02_frontend
LH02 해커톤 공통 프론트엔드 — 이미지·텍스트 입력, 지도 API, AI 분석 결과 화면

## 팀 공통 기본 실행 환경

현재는 주제 선정 전 기본 실행 환경만 준비합니다. 화면에는 “LH02 프론트엔드 실행 확인”만 표시하며 실제 API 호출은 없습니다.

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
flutter run -d chrome --web-port 5173 --dart-define=API_BASE_URL=http://127.0.0.1:8081
```

브라우저에서 기본 문구를 확인합니다. 터미널에서 `q`를 누르면 실행이 종료됩니다. 앱 프로젝트의 `pubspec.lock`은 팀의 의존성 버전을 공유하기 위해 Git에 포함합니다.

### 분석, 테스트, 웹 빌드

```powershell
flutter analyze
flutter test
flutter build web
```

웹 빌드 결과는 `build\web`에 생성되며 Git에 포함하지 않습니다.

### 백엔드 주소 설정

백엔드는 별도로 실행해야 합니다. `lib/config/app_config.dart`의 `AppConfig.apiBaseUrl`은 `String.fromEnvironment`로 `API_BASE_URL`을 읽으며 기본값은 `http://127.0.0.1:8081`입니다. 현재 기본 화면은 이 주소로 API를 호출하지 않습니다.

`127.0.0.1`은 앱을 실행하는 컴퓨터 자신을 가리킵니다. 팀원의 백엔드를 연결하려면 해당 팀원 PC의 접근 가능한 IP와 포트를 사용합니다. 예를 들어:

```powershell
flutter run -d chrome --web-port 5173 --dart-define=API_BASE_URL=http://192.168.0.10:8081
```

배포 서버를 연결할 때는 실제 서버 주소로 바꿉니다.

```powershell
flutter run -d chrome --web-port 5173 --dart-define=API_BASE_URL=https://api.example.com
flutter build web --dart-define=API_BASE_URL=https://api.example.com
```

위 주소는 예시입니다. `--dart-define`은 실행/빌드 시 적용되므로 주소를 변경하면 다시 실행하거나 빌드합니다.

웹에서 백엔드를 호출할 때는 백엔드에서 CORS를 설정하여 프론트엔드 origin(로컬 Chrome 실행은 `http://localhost:5173`)을 허용해야 합니다. 팀원 백엔드는 네트워크에서 접근할 수 있도록 별도로 실행되어 있어야 합니다.

네이버 API 키는 백엔드에서만 관리합니다. 프론트 코드, 설정, `--dart-define`에 비밀 키를 넣지 않습니다. 프론트 빌드에 포함된 설정 값은 사용자에게 공개됩니다.
