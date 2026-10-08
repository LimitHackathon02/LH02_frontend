import 'dart:convert';

class QuickRecommendation {
  const QuickRecommendation({
    required this.name,
    required this.address,
    required this.category,
    required this.url,
    required this.reason,
    required this.matched,
    this.travelText = const [],
    this.score,
  });

  final String name;
  final String address;
  final String category;
  final String url;
  final String reason;
  final List<String> matched;
  final List<String> travelText;
  final double? score;

  String travelMinutesFor(String member) {
    for (final text in travelText) {
      if (!text.contains("($member)")) continue;
      final match = RegExp(r"자동차\s*약\s*(\d+)\s*분").firstMatch(text);
      if (match != null) return "${match.group(1)}분";
    }
    return "정보 없음";
  }

  factory QuickRecommendation.fromJson(Map<String, dynamic> json) {
    final placeValue = json['place'];
    final place = placeValue is Map
        ? Map<String, dynamic>.from(placeValue)
        : const <String, dynamic>{};
    final scoreValue = json['score'];
    final matchedValue = json['matched'];
    final travelTextValue = json['travel_text'];
    final travelText = travelTextValue is List
        ? travelTextValue.map((value) => value.toString()).toList()
        : <String>[];
    final matched = matchedValue is List
        ? matchedValue.map((value) => value.toString()).toList()
        : matchedValue is String && matchedValue.isNotEmpty
        ? <String>[matchedValue]
        : <String>[];

    return QuickRecommendation(
      name: _string(place['name']),
      address: _string(place['address']),
      category: _string(place['category']),
      url: _string(place['url']),
      score: scoreValue is num
          ? scoreValue.toDouble()
          : double.tryParse(scoreValue?.toString() ?? ''),
      reason: _string(json['reason']),
      matched: matched,
      travelText: travelText,
    );
  }

  static List<QuickRecommendation> parseResponse(String body) {
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic> || decoded['recommendations'] is! List) {
      throw const FormatException('응답에 recommendations 배열이 없습니다.');
    }
    return (decoded['recommendations'] as List)
        .whereType<Map>()
        .map((item) => QuickRecommendation.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  static String _string(Object? value) => value?.toString() ?? '';
}
