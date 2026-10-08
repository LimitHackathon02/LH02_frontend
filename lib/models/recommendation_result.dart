class RecommendationResult {
  const RecommendationResult({
    required this.recommendations,
    required this.groupSummary,
    required this.centerName,
    required this.fallback,
    this.body = '',
  });

  factory RecommendationResult.fromJson(
    Map<String, dynamic> json, {
    String body = '',
  }) {
    final items = json['recommendations'];
    if (items is! List) {
      throw const FormatException('추천 목록이 없는 서버 응답입니다.');
    }
    return RecommendationResult(
      recommendations: items.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('추천 장소 형식이 올바르지 않습니다.');
        }
        return PlaceRecommendation.fromJson(item);
      }).toList(),
      groupSummary: json['group_summary'] as String? ?? '',
      centerName:
          (json['center'] as Map<String, dynamic>?)?['name'] as String? ?? '',
      fallback: json['fallback'] == true,
      body: body,
    );
  }

  final List<PlaceRecommendation> recommendations;
  final String groupSummary;
  final String centerName;
  final bool fallback;
  final String body;
}

class PlaceRecommendation {
  const PlaceRecommendation({
    required this.name,
    required this.address,
    required this.category,
    required this.rank,
    required this.score,
    required this.reason,
    required this.matched,
    required this.warnings,
    required this.travel,
  });

  factory PlaceRecommendation.fromJson(Map<String, dynamic> json) {
    final place = json['place'];
    if (place is! Map<String, dynamic> || place['name'] is! String) {
      throw const FormatException('추천 장소 이름이 없는 서버 응답입니다.');
    }
    return PlaceRecommendation(
      name: place['name'] as String,
      address: place['address'] as String? ?? '',
      category: place['category'] as String? ?? '',
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      score: (json['score'] as num?)?.toDouble() ?? 0,
      reason: json['reason'] as String? ?? '',
      matched: (json['matched'] as List? ?? []).whereType<String>().toList(),
      warnings: (json['warnings'] as List? ?? []).whereType<String>().toList(),
      travel: (json['travel'] as List? ?? []).map((item) {
        final data = item as Map<String, dynamic>;
        return TravelEstimate(
          member: data['member'] as String? ?? '',
          minutes: (data['est_minutes'] as num?)?.toInt() ?? 0,
          distanceKm: (data['distance_km'] as num?)?.toDouble() ?? 0,
        );
      }).toList(),
    );
  }

  final String name;
  final String address;
  final String category;
  final int rank;
  final double score;
  final String reason;
  final List<String> matched;
  final List<String> warnings;
  final List<TravelEstimate> travel;

  List<String> get tags =>
      {if (category.isNotEmpty) category.split('>').last, ...matched}.toList();
}

class TravelEstimate {
  const TravelEstimate({
    required this.member,
    required this.minutes,
    required this.distanceKm,
  });
  final String member;
  final int minutes;
  final double distanceKm;
}
