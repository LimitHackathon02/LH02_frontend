import 'package:flutter/material.dart';

import '../models/quick_recommendation.dart';
import '3-2.dart';

class RestaurantRecommendationScreen extends StatefulWidget {
  const RestaurantRecommendationScreen({
    required this.recommendations,
    super.key,
  });

  final List<QuickRecommendation> recommendations;
  @override
  State<RestaurantRecommendationScreen> createState() =>
      _RestaurantRecommendationScreenState();
}

class _RestaurantRecommendationScreenState
    extends State<RestaurantRecommendationScreen> {
  List<QuickRecommendation> get _visibleRecommendations =>
      widget.recommendations.take(3).toList();
  static const _ink = Color(0xFF2B1715);
  static const _muted = Color(0xFF858585);
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      bottom: false,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/screens/3-1/bgd.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  children: [
                    _topControls(),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _intro(),
                          if (_visibleRecommendations.isEmpty)
                            _emptyResults()
                          else
                            ...List.generate(
                              _visibleRecommendations.length,
                              (index) => _restaurantCard(
                                index,
                                _visibleRecommendations[index],
                              ),
                            ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _bottomNavigation(),
        ],
      ),
    ),
  );

  Widget _topControls() => Column(
    children: [
      AspectRatio(
        aspectRatio: 889 / 164,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/screens/3-1/upper bar.png', fit: BoxFit.fill),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 56,
                child: InkWell(onTap: () => Navigator.of(context).maybePop()),
              ),
            ),
          ],
        ),
      ),
      LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 0, 2),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/screens/3-1/date,time.png',
              width: constraints.maxWidth * .54,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    ],
  );

  Widget _intro() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 18, 12),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '이런 장소 어때요?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _ink, height: 1.3),
              ),
              const SizedBox(height: 3),
              const Text('만나미가 추천하는 만남의 장소예요', style: TextStyle(fontSize: 10, color: _muted)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Image.asset('assets/screens/3-1/mannami.png', width: 42, height: 42, fit: BoxFit.contain),
      ],
    ),
  );

  Widget _emptyResults() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 72, horizontal: 28),
    child: Column(
      children: [
        Icon(Icons.search_off, size: 32, color: Color(0xFFB2B4BA)),
        SizedBox(height: 10),
        Text('조건에 맞는 추천 장소가 없어요.', style: TextStyle(fontSize: 12, color: _muted)),
      ],
    ),
  );

  Widget _restaurantCard(int index, QuickRecommendation item) {
    const colors = [Color(0xFFD08A00), Color(0xFF8A8A8A), Color(0xFF8E4B35)];
    final tags = item.matched
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => Screen3_2(recommendation: item)),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 98,
        margin: const EdgeInsets.fromLTRB(16, 0, 24, 13),
        padding: const EdgeInsets.fromLTRB(13, 11, 13, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFDADADA)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 19,
                    height: 19,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: colors[index % 3], shape: BoxShape.circle),
                    child: Text((index + 1).toString(), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.name.isEmpty ? '추천 장소' : item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _ink),
                    ),
                  ),
                  if (item.score != null) ...[
                    const Icon(Icons.star, size: 11, color: Color(0xFFE66B5D)),
                    const SizedBox(width: 2),
                    Text(item.score!.toStringAsFixed(2), style: const TextStyle(fontSize: 8, color: _muted)),
                  ],
                ]),
                const SizedBox(height: 8),
                Text(
                  item.address.isEmpty ? item.reason : item.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9, color: Color(0xFF777777)),
                ),
                const SizedBox(height: 7),
                Wrap(
                  spacing: 4,
                  children: tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3C5),
                      border: Border.all(color: const Color(0xFFE8D68F), width: .6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(tag, style: const TextStyle(fontSize: 7, color: Color(0xFF806C35))),
                  )).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              gradient: const LinearGradient(colors: [Color(0xFF303030), Color(0xFF8D492A), Color(0xFFE0AE52)]),
            ),
            child: Stack(alignment: Alignment.center, children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(color: const Color(0xFFF3E8D4), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
              ),
              const Text('🍽️', style: TextStyle(fontSize: 34)),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _bottomNavigation() => SizedBox(
    height: 62,
    width: double.infinity,
    child: Image.asset('assets/screens/2-1-1/underbar.png', fit: BoxFit.contain),
  );
}
