// ignore_for_file: file_names, camel_case_types
import 'package:flutter/material.dart';

import '../models/quick_recommendation.dart';
import '../widgets/place_map.dart';

class Screen3_2 extends StatelessWidget {
  const Screen3_2({this.recommendation, super.key});

  final QuickRecommendation? recommendation;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      bottom: false,
      child: Column(
        children: [
          SizedBox(
            height: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  '추천 장소 결과',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF454545),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    padding: const EdgeInsets.only(left: 14),
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 17,
                      color: Color(0xFF1683F5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: PlaceMap(place: recommendation),
          ),
          _PlaceSummary(recommendation: recommendation),
          Expanded(flex: 3, child: _TravelTime(recommendation: recommendation)),
        ],
      ),
    ),
  );
}

class _PlaceSummary extends StatelessWidget {
  const _PlaceSummary({this.recommendation});

  final QuickRecommendation? recommendation;

  @override
  Widget build(BuildContext context) {
    final item = recommendation;
    final tags = <String>[];
    if (item != null) {
      tags.addAll(item.matched.map((tag) => tag.trim()).where((tag) => tag.isNotEmpty));
    }
    final visibleTags = tags.toSet().take(3).toList();
    return Container(
    height: 112,
    padding: const EdgeInsets.fromLTRB(20, 12, 18, 8),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: Color(0xFFE6E6E6))),
      boxShadow: [
        BoxShadow(
          color: Color(0x12000000),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text(
                    item?.name.isNotEmpty == true ? item!.name : '졸리앤몰트',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF2B1715)),
                  ),
                ),
                if (item?.score != null) ...[
                  const Icon(Icons.star, size: 14, color: Color(0xFFE66B5D)),
                  const SizedBox(width: 2),
                  Text(item!.score!.toStringAsFixed(2), style: const TextStyle(fontSize: 10, color: Color(0xFF555555))),
                ],
              ]),
              const SizedBox(height: 4),
              Text(
                item?.reason.isNotEmpty == true ? item!.reason : '추천 이유를 확인해 보세요.',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 8, color: Color(0xFF555555)),
              ),
              const SizedBox(height: 2),
              Text(
                item?.address.isNotEmpty == true ? item!.address : '주소 정보가 없습니다.',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 8, color: Color(0xFF777777)),
              ),
              const SizedBox(height: 5),
              Wrap(
                spacing: 4,
                children: (visibleTags.isEmpty ? <String>['추천 장소'] : visibleTags)
                    .map((text) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3C5),
                        border: Border.all(color: const Color(0xFFE8D68F), width: .6),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(text, style: const TextStyle(fontSize: 7, color: Color(0xFF806C35))),
                    ))
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            gradient: const LinearGradient(
              colors: [Color(0xFF34302B), Color(0xFF91502D), Color(0xFFE6BD75)],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 57,
                height: 57,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4E9D7),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
              ),
              const Text('🍝', style: TextStyle(fontSize: 35)),
            ],
          ),
        ),
      ],
    ),
  );
  }
}

class _TravelTime extends StatelessWidget {
  const _TravelTime({this.recommendation});

  final QuickRecommendation? recommendation;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(28, 18, 20, 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '걸리는 시간을 확인해요.',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF33211D),
              ),
            ),
            Text(
              '평균 시간 15분',
              style: TextStyle(fontSize: 8, color: Colors.grey.shade500),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TravelCard(
                label: '1',
                time: recommendation?.travelMinutesFor('보경') ?? '정보 없음',
              ),
              const SizedBox(width: 30),
              _TravelCard(
                label: '2',
                time: recommendation?.travelMinutesFor('지민') ?? '정보 없음',
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _TravelCard extends StatelessWidget {
  const _TravelCard({required this.label, required this.time});

  final String label;
  final String time;

  @override
  Widget build(BuildContext context) => Container(
    width: 68,
    height: 92,
    decoration: BoxDecoration(
      color: const Color(0xFFFFFEFC),
      border: Border.all(color: const Color(0xFFD8D4CF)),
      borderRadius: BorderRadius.circular(5),
      boxShadow: const [
        BoxShadow(color: Color(0x10000000), blurRadius: 3, offset: Offset(0, 2)),
      ],
    ),
    child: Column(
      children: [
        const SizedBox(height: 8),
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFFFF2C0),
            shape: BoxShape.circle,
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Color(0xFF55482A),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Icon(
          Icons.directions_car_filled,
          size: 20,
          color: Color(0xFF806293),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 8, color: Color(0xFF555555)),
        ),
      ],
    ),
  );
}
