import 'package:flutter/material.dart';

import '../models/recommendation_result.dart';

class RecommendationDetailScreen extends StatelessWidget {
  const RecommendationDetailScreen({required this.recommendation, super.key});

  final PlaceRecommendation recommendation;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('추천 장소 결과')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Icon(Icons.location_on, size: 64, color: Color(0xFFE9694F)),
        const SizedBox(height: 20),
        Text(
          recommendation.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        SelectableText(recommendation.address),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          children: recommendation.tags
              .map((tag) => Chip(label: Text(tag)))
              .toList(),
        ),
        const SizedBox(height: 20),
        const Text(
          '추천 이유',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(recommendation.reason),
        const SizedBox(height: 8),
        Text('추천 적합도 ${recommendation.score.toStringAsFixed(0)}점'),
        if (recommendation.travel.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text(
            '예상 이동 시간',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...recommendation.travel.map(
            (travel) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.directions_walk),
              title: Text('${travel.member} · 약 ${travel.minutes}분'),
              subtitle: Text('직선 거리 ${travel.distanceKm.toStringAsFixed(1)}km'),
            ),
          ),
          const Text(
            '서버가 계산한 추정치이며 실제 교통 경로에 따라 달라질 수 있어요.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
        if (recommendation.warnings.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text(
            '방문 전 확인해주세요',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...recommendation.warnings.map(
            (warning) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(warning),
            ),
          ),
        ],
      ],
    ),
  );
}
