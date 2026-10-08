import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';

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

  Future<http.Response> submitPeople(Map<String, Object> payload) async {
    final response = await _client
        .post(
          recommendationUri,
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(payload),
        )
        .timeout(const Duration(seconds: 15));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw BackendRequestException(response.statusCode, response.body);
    }
    return response;
  }

  void close() => _client.close();
}

class BackendRequestException implements Exception {
  const BackendRequestException(this.statusCode, this.responseBody);

  final int statusCode;
  final String responseBody;

  @override
  String toString() {
    final suffix = responseBody.isEmpty ? '' : ': $responseBody';
    return 'Backend returned HTTP $statusCode$suffix';
  }
}
