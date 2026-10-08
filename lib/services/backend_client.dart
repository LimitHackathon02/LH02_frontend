import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/recommendation_result.dart';

class BackendClient {
  BackendClient({http.Client? client, Uri? baseUri, String? recommendationPath})
    : _client = client ?? http.Client(),
      _baseUri = baseUri ?? _configuredBaseUri(),
      _recommendationPath = recommendationPath ?? AppConfig.recommendationPath;

  final http.Client _client;
  final Uri _baseUri;
  final String _recommendationPath;

  static Uri _configuredBaseUri() {
    final uri = Uri.parse(AppConfig.apiBaseUrl);
    // Android emulators access the host machine through 10.0.2.2.
    if (!kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        uri.host == '127.0.0.1') {
      return uri.replace(host: '10.0.2.2');
    }
    return uri;
  }

  Uri get recommendationUri => _baseUri.resolve(_recommendationPath);

  Future<RecommendationResult> submitPeople(Map<String, Object> payload) async {
    late final http.Response response;
    try {
      response = await _client
          .post(
            recommendationUri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 120));
    } on TimeoutException {
      throw const BackendConnectionException(
        '추천 응답이 지연되고 있어요. 잠시 후 다시 시도해주세요.',
      );
    } on http.ClientException {
      throw const BackendConnectionException(
        '서버에 연결할 수 없어요. 백엔드 실행 상태와 주소를 확인해주세요.',
      );
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw BackendRequestException(
        response.statusCode,
        utf8.decode(response.bodyBytes),
      );
    }
    try {
      final body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      if (data is! Map<String, dynamic>) {
        throw const FormatException('JSON 객체가 필요합니다.');
      }
      return RecommendationResult.fromJson(data, body: body);
    } on FormatException {
      throw const BackendConnectionException(
        '서버의 추천 결과를 읽을 수 없어요. API 응답을 확인해주세요.',
      );
    } on TypeError {
      throw const BackendConnectionException('서버의 추천 결과 형식이 올바르지 않아요.');
    }
  }

  void close() => _client.close();
}

class BackendRequestException implements Exception {
  const BackendRequestException(this.statusCode, this.responseBody);

  final int statusCode;
  final String responseBody;

  @override
  String toString() {
    try {
      final body = jsonDecode(responseBody);
      final detail = body['detail'];
      if (detail is Map && detail['message'] is String) {
        return detail['message'] as String;
      }
      if (detail is String) return detail;
    } catch (_) {
      // JSON이 아닌 오류 응답도 HTTP 상태로 안내합니다.
    }
    return '추천 요청을 처리하지 못했어요. (HTTP $statusCode)';
  }
}

class BackendConnectionException implements Exception {
  const BackendConnectionException(this.message);
  final String message;
  @override
  String toString() => message;
}
