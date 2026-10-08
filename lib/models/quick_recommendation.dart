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
    this.travelMinutesByMember = const {},
    this.score,
    this.latitude,
    this.longitude,
  });

  final String name;
  final String address;
  final String category;
  final String url;
  final String reason;
  final List<String> matched;
  final List<String> travelText;
  final Map<String, int> travelMinutesByMember;
  final double? score;
  final double? latitude;
  final double? longitude;

  bool get hasCoordinates =>
      latitude != null &&
      longitude != null &&
      latitude!.isFinite &&
      longitude!.isFinite &&
      latitude!.abs() <= 90 &&
      longitude!.abs() <= 180;

  List<String> get travelMembers {
    final members = travelMinutesByMember.keys.toSet();
    for (final text in travelText) {
      for (final line in text.split(RegExp(r'[\r\n]+'))) {
        final name = RegExp(
          r'\(\s*([^()]+?)\s*\)',
        ).firstMatch(line)?.group(1)?.trim();
        if (name != null &&
            name.isNotEmpty &&
            travelMinutesValueFor(name) != null) {
          members.add(name);
        }
      }
    }
    return members.toList();
  }

  int? travelMinutesValueFor(String member) {
    final memberPattern = RegExp(r'\(\s*' + RegExp.escape(member) + r'\s*\)');
    final minutesPattern = RegExp(r'자동차\s*약\s*(\d+)\s*분');
    for (final text in travelText) {
      for (final line in text.split(RegExp(r'[\r\n]+'))) {
        if (!memberPattern.hasMatch(line)) continue;
        final match = minutesPattern.firstMatch(line);
        if (match != null) return int.tryParse(match.group(1)!);
      }
    }
    return travelMinutesByMember[member];
  }

  String travelMinutesFor(String member) {
    final minutes = travelMinutesValueFor(member);
    return minutes == null ? '정보 없음' : '$minutes분';
  }

  factory QuickRecommendation.fromJson(Map<String, dynamic> json) {
    final placeValue = json['place'];
    final place = placeValue is Map
        ? Map<String, dynamic>.from(placeValue)
        : const <String, dynamic>{};
    final scoreValue = json['score'];
    final matchedValue = json['matched'];
    final travelTextValue = json['travel_text'] ?? json['tavel_text'];
    final travelText = travelTextValue is List
        ? travelTextValue.map((value) => value.toString()).toList()
        : travelTextValue is String
        ? <String>[travelTextValue]
        : <String>[];
    final travelMinutesByMember = <String, int>{};
    final travelValue = json['travel'];
    if (travelValue is List) {
      for (final entry in travelValue.whereType<Map>()) {
        final member = _string(entry['member']).trim();
        final minutes = _coordinate(entry['est_minutes']);
        if (member.isNotEmpty &&
            minutes != null &&
            minutes.isFinite &&
            minutes >= 0) {
          travelMinutesByMember[member] = minutes.round();
        }
      }
    }
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
      latitude: _coordinate(place['lat']),
      longitude: _coordinate(place['lng']),
      score: scoreValue is num
          ? scoreValue.toDouble()
          : double.tryParse(scoreValue?.toString() ?? ''),
      reason: _string(json['reason']),
      matched: matched,
      travelText: travelText,
      travelMinutesByMember: Map.unmodifiable(travelMinutesByMember),
    );
  }

  static List<QuickRecommendation> parseResponse(String body) {
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic> ||
        decoded['recommendations'] is! List) {
      throw const FormatException('응답에 recommendations 배열이 없습니다.');
    }
    return (decoded['recommendations'] as List)
        .whereType<Map>()
        .map(
          (item) =>
              QuickRecommendation.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  static String _string(Object? value) => value?.toString() ?? '';

  static double? _coordinate(Object? value) => value is num
      ? value.toDouble()
      : double.tryParse(value?.toString() ?? '');
}
