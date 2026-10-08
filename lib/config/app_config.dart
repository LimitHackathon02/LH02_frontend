/// 공개 백엔드 주소만 설정합니다. 비밀 API 키는 백엔드에서 관리합니다.
class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  /// Override with --dart-define=MEMBER_NAME=... to send the participant name.
  static const String memberName = String.fromEnvironment(
    'MEMBER_NAME',
    defaultValue: '사용자',
  );

  /// Override with --dart-define=API_RECOMMENDATION_PATH=/your/route if needed.
  static const String recommendationPath = String.fromEnvironment(
    'API_RECOMMENDATION_PATH',
    defaultValue: '/api/recommend/quick',
  );
}
