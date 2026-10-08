/// 공개 백엔드 주소만 설정합니다. 비밀 API 키는 백엔드에서 관리합니다.
class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  /// Can be set with --dart-define=API_RECOMMENDATION_PATH=/your/route.
  static const String recommendationPath = String.fromEnvironment(
    'API_RECOMMENDATION_PATH',
    defaultValue: '/api/recommend/quick',
  );
}
