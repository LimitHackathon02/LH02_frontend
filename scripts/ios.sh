#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

usage() {
  cat <<'EOF'
사용법: ./scripts/ios.sh [simulator|device|ipa|run DEVICE_ID]
  simulator  시뮬레이터 Debug 앱 빌드 (기본값, 서명 불필요)
  device     실기기 Release 앱 빌드 (서명 제외, 설치용 IPA 아님)
  ipa        서명된 배포용 아카이브/IPA 생성 (Xcode Team 설정 필요)
  run        지정한 iOS 시뮬레이터 또는 실기기에서 Debug 실행

설정: API_BASE_URL, API_RECOMMENDATION_PATH 환경 변수
Release 빌드(device/ipa)는 HTTPS API_BASE_URL이 필요합니다.
EOF
}

mode="${1:-simulator}"
case "$mode" in
  -h|--help) usage; exit 0 ;;
  simulator|device|ipa) [[ $# -le 1 ]] || { usage; exit 2; } ;;
  run) [[ $# -eq 2 ]] || { usage; exit 2; } ;;
  *) usage; exit 2 ;;
esac

[[ "$(uname -s)" == Darwin ]] || { echo 'iOS 빌드는 macOS와 Xcode가 필요합니다.' >&2; exit 1; }
command -v flutter >/dev/null || { echo 'Flutter SDK의 bin 폴더를 PATH에 추가하세요.' >&2; exit 1; }
xcodebuild -version >/dev/null

api_base_url="${API_BASE_URL:-http://127.0.0.1:8000}"
if [[ "$mode" == device || "$mode" == ipa ]]; then
  [[ "$api_base_url" == https://?* ]] || { echo 'Release 빌드는 API_BASE_URL=https://실제서버주소를 지정하세요.' >&2; exit 2; }
fi
defines=("--dart-define=API_BASE_URL=$api_base_url" "--dart-define=API_RECOMMENDATION_PATH=${API_RECOMMENDATION_PATH:-/api/recommend/quick}")

flutter pub get
# pub get이 생성한 Swift 패키지의 기본 iOS 13 설정은 일부 플러그인과
# 충돌하여 Xcode 빌드 설정 조회부터 실패합니다. 프로젝트 버전을 먼저 반영합니다.
python3 - <<'PY'
from pathlib import Path
import re

manifest = Path('ios/Flutter/ephemeral/Packages/FlutterGeneratedPluginSwiftPackage/Package.swift')
if manifest.exists():
    project = Path('ios/Runner.xcodeproj/project.pbxproj').read_text()
    content = manifest.read_text()
    versions = re.findall(r'IPHONEOS_DEPLOYMENT_TARGET = ([\d.]+);', project)
    versions += re.findall(r'\.iOS\("([\d.]+)"\)', content)
    minimum = max(versions, key=lambda value: tuple(map(int, value.split('.'))))
    updated = re.sub(r'\.iOS\("[\d.]+"\)', f'.iOS("{minimum}")', content)
    if updated != content:
        manifest.write_text(updated)
PY
# 플러그인 의존성을 생성한 뒤 변경된 최소 iOS 버전을 반영합니다.
flutter build ios --config-only --debug --no-codesign --no-pub "${defines[@]}"
case "$mode" in
  simulator) flutter build ios --simulator --debug --no-pub "${defines[@]}" ;;
  device) flutter build ios --release --no-codesign --no-pub "${defines[@]}" ;;
  ipa) flutter build ipa --release --no-pub "${defines[@]}" ;;
  run) flutter run --debug --no-pub -d "$2" "${defines[@]}" ;;
esac
