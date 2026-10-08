import 'package:flutter/material.dart';
import '3-2.dart';

class RestaurantRecommendationScreen extends StatefulWidget {
  const RestaurantRecommendationScreen({super.key});
  @override
  State<RestaurantRecommendationScreen> createState() =>
      _RestaurantRecommendationScreenState();
}

class _RestaurantRecommendationScreenState
    extends State<RestaurantRecommendationScreen> {
  bool _showMore = false;
  static const _ink = Color(0xFF2B1715);
  static const _muted = Color(0xFF858585);
  static const _restaurants = [
    ('졸리앤몰트', '서울 노원구 노해로 88길 20 5층', '이탈리안', '차분한', '뷰가 좋은'),
    ('수시로스시', '서울 노원구 노해로 479 1층', '일식', '특별한', '대화하기 좋은'),
    ('다함닭갈비', '서울 노원구 상계3·4동 38-6 1층', '한식', '오래 머물기 좋은', '대화하기 좋은'),
    ('오늘의 식탁', '서울 노원구 동일로 123길 8', '한식', '아늑한', '혼밥 추천'),
    ('작은 파스타집', '서울 노원구 상계로 41', '이탈리안', '데이트', '분위기 좋은'),
  ];
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
                          ...List.generate(
                            _showMore ? _restaurants.length : 3,
                            _restaurantCard,
                          ),
                          TextButton.icon(
                            onPressed: () =>
                                setState(() => _showMore = !_showMore),
                            icon: Icon(
                              _showMore
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 16,
                              color: _muted,
                            ),
                            label: Text(
                              _showMore ? '접기' : '더보기',
                              style: const TextStyle(
                                fontSize: 12,
                                color: _muted,
                              ),
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

  Widget _restaurantCard(int index) {
    final item = _restaurants[index];
    const colors = [Color(0xFFD08A00), Color(0xFF8A8A8A), Color(0xFF8E4B35)];
    return InkWell(
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const Screen3_2())),
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 19,
                        height: 19,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors[index % 3],
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.$1,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF777777),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 4,
                    children: [item.$3, item.$4, item.$5]
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3C5),
                              border: Border.all(
                                color: const Color(0xFFE8D68F),
                                width: .6,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 7,
                                color: Color(0xFF806C35),
                              ),
                            ),
                          ),
                        )
                        .toList(),
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
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF303030),
                    Color(0xFF8D492A),
                    Color(0xFFE0AE52),
                  ],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8D4),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                  const Text('🍝', style: TextStyle(fontSize: 34)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavigation() => SizedBox(
    height: 62,
    width: double.infinity,
    child: Image.asset('assets/screens/2-1-1/underbar.png', fit: BoxFit.contain),
  );
}
