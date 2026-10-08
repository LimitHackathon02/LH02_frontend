// ignore_for_file: file_names, camel_case_types
import 'package:flutter/material.dart';

class Screen3_2 extends StatelessWidget {
  const Screen3_2({super.key});

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
                      color: Color(0xFF999999),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const CustomPaint(painter: _MapPainter()),
                Positioned(
                  left: MediaQuery.sizeOf(context).width * .48,
                  top: MediaQuery.sizeOf(context).height * .18,
                  child: const Icon(
                    Icons.location_on,
                    size: 34,
                    color: Color(0xFFE9694F),
                  ),
                ),
                Positioned(
                  right: 12,
                  bottom: 14,
                  child: Column(
                    children: [
                      _mapButton(Icons.add),
                      const SizedBox(height: 4),
                      _mapButton(Icons.remove),
                    ],
                  ),
                ),
                const Positioned(
                  left: 8,
                  bottom: 8,
                  child: Text(
                    '지도 데이터 · 현재 위치 기준',
                    style: TextStyle(fontSize: 8, color: Color(0xFF888888)),
                  ),
                ),
              ],
            ),
          ),
          const _PlaceSummary(),
          const Expanded(flex: 2, child: _TravelTime()),
          _bottomNavigation(),
        ],
      ),
    ),
  );

  static Widget _mapButton(IconData icon) => Container(
    width: 28,
    height: 28,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 3)],
    ),
    child: Icon(icon, size: 18, color: const Color(0xFF777777)),
  );

  Widget _bottomNavigation() {
    const labels = ['홈', '맵', '채팅', '프로필'];
    const icons = [
      Icons.home_outlined,
      Icons.location_on,
      Icons.chat_bubble_outline,
      Icons.person,
    ];
    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFE7E7E7))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 7,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: List.generate(
          labels.length,
          (index) => Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icons[index],
                  size: 20,
                  color: index == 1
                      ? const Color(0xFF777777)
                      : const Color(0xFFB2B4BA),
                ),
                const SizedBox(height: 2),
                Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 9,
                    color: index == 1
                        ? const Color(0xFF777777)
                        : const Color(0xFFB2B4BA),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaceSummary extends StatelessWidget {
  const _PlaceSummary();

  @override
  Widget build(BuildContext context) => Container(
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
                const Text('졸리앤몰트', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF2B1715))),
                const SizedBox(width: 7),
                const Icon(Icons.star, size: 14, color: Color(0xFFE66B5D)),
                const SizedBox(width: 2),
                const Text('4.87', style: TextStyle(fontSize: 10, color: Color(0xFF555555))),
              ]),
              const SizedBox(height: 4),
              const Text(
                '7년만의 재방문에도 변치 않는 맛',
                style: TextStyle(fontSize: 8, color: Color(0xFF555555)),
              ),
              const SizedBox(height: 2),
              const Text(
                '서울 노원구 노해로 88길 20 5층',
                style: TextStyle(fontSize: 8, color: Color(0xFF777777)),
              ),
              const SizedBox(height: 5),
              Wrap(
                spacing: 4,
                children: ['이탈리안', '차분한', '뷰가 좋은']
                    .map(
                      (text) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3C5),
                          border: Border.all(
                            color: const Color(0xFFE8D68F),
                            width: .6,
                          ),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          text,
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

class _TravelTime extends StatelessWidget {
  const _TravelTime();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '걸리는 시간을 확인해요.',
              style: TextStyle(
                fontSize: 10,
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
        const SizedBox(height: 18),
        SizedBox(
          height: 58,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 12,
                right: 12,
                top: 10,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3D4F7),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Positioned(
                left: 0,
                top: 0,
                child: _TimeStop(
                  label: '나',
                  time: '13분',
                  icon: Icons.directions_walk,
                ),
              ),
              const Positioned(
                right: 0,
                top: 27,
                child: _TimeStop(
                  label: '1',
                  time: '57분',
                  icon: Icons.directions_car_filled,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _TimeStop extends StatelessWidget {
  const _TimeStop({
    required this.label,
    required this.time,
    required this.icon,
  });
  final String label;
  final String time;
  final IconData icon;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 40,
    child: Column(
      children: [
        Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD2C9E1)),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 8, color: Color(0xFF555555)),
          ),
        ),
        const SizedBox(height: 2),
        Icon(icon, size: 15, color: const Color(0xFF777777)),
        Text(
          time,
          style: const TextStyle(fontSize: 7, color: Color(0xFF555555)),
        ),
      ],
    ),
  );
}

class _MapPainter extends CustomPainter {
  const _MapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFF4F1EA), BlendMode.src);
    final blockColors = [
      const Color(0xFFFDFBF6),
      const Color(0xFFFFFDF8),
      const Color(0xFFEAF0E4),
      const Color(0xFFF5EBDD),
    ];
    final random = _FixedRandom(13);
    const columns = 7;
    const rows = 9;
    final cellW = size.width / columns;
    final cellH = size.height / rows;
    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < columns; col++) {
        final insetX = 3 + random.nextInt(5).toDouble();
        final insetY = 3 + random.nextInt(5).toDouble();
        final rect = Rect.fromLTWH(
          col * cellW + insetX,
          row * cellH + insetY,
          cellW - insetX - 5,
          cellH - insetY - 5,
        );
        final paint = Paint()
          ..color = blockColors[random.nextInt(blockColors.length)];
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(2)),
          paint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(2)),
          Paint()
            ..color = const Color(0xFFE5E0D6)
            ..style = PaintingStyle.stroke
            ..strokeWidth = .7,
        );
      }
    }
    final minorRoad = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke;
    final roadEdge = Paint()
      ..color = const Color(0xFFE1DDD5)
      ..strokeWidth = 4.8
      ..style = PaintingStyle.stroke;
    for (var row = 1; row < rows; row++) {
      final y = row * cellH;
      final path = Path()
        ..moveTo(0, y + (row.isEven ? -4 : 4))
        ..lineTo(size.width, y + (row.isEven ? 5 : -3));
      canvas.drawPath(path, roadEdge);
      canvas.drawPath(path, minorRoad);
    }
    for (var col = 1; col < columns; col++) {
      final x = col * cellW;
      final path = Path()
        ..moveTo(x - 3, 0)
        ..lineTo(x + 5, size.height);
      canvas.drawPath(path, roadEdge);
      canvas.drawPath(path, minorRoad);
    }
    final route = Path()
      ..moveTo(-10, size.height * .68)
      ..lineTo(size.width * .35, size.height * .56)
      ..lineTo(size.width * .64, size.height * .48)
      ..lineTo(size.width + 10, size.height * .34);
    canvas.drawPath(
      route,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 13
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawPath(
      route,
      Paint()
        ..color = const Color(0xFF6EB8E8)
        ..strokeWidth = 7
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    _label(
      canvas,
      '노원역',
      Offset(size.width * .45, size.height * .51),
      size: 10,
      bold: true,
      color: const Color(0xFF31465A),
    );
    _label(
      canvas,
      '노원 문화의 거리',
      Offset(size.width * .11, size.height * .22),
      size: 8,
    );
    _label(
      canvas,
      '롯데백화점',
      Offset(size.width * .69, size.height * .16),
      size: 8,
    );
    _label(
      canvas,
      '노원구청',
      Offset(size.width * .65, size.height * .75),
      size: 8,
    );
    _label(
      canvas,
      '상계역 방면',
      Offset(size.width * .16, size.height * .85),
      size: 7,
      color: const Color(0xFF6989A0),
    );
    final placeLabels = [
      ('엔제리너스', .08, .13), ('아웃백', .25, .08), ('메가커피', .44, .13),
      ('올리브영', .72, .12), ('롯데시네마', .83, .28), ('노원문고', .12, .37),
      ('다이소', .25, .67), ('스타벅스', .42, .75), ('약국', .77, .80),
      ('분식집', .62, .21), ('노원문화의거리', .11, .90), ('식당', .36, .30),
      ('카페', .57, .37), ('은행', .90, .57), ('버스정류장', .16, .55),
    ];
    for (final (name, x, y) in placeLabels) {
      _label(canvas, name, Offset(size.width * x, size.height * y), size: 6.5, color: const Color(0xFFB17A66));
    }
    final points = [
      Offset(size.width * .2, size.height * .39),
      Offset(size.width * .78, size.height * .58),
      Offset(size.width * .34, size.height * .82),
      Offset(size.width * .84, size.height * .2),
      Offset(size.width * .57, size.height * .29),
    ];
    for (var i = 0; i < points.length; i++) {
      canvas.drawCircle(
        points[i],
        5,
        Paint()
          ..color = i == 1 ? const Color(0xFFE66E57) : const Color(0xFFF0A353),
      );
      canvas.drawCircle(points[i], 2, Paint()..color = Colors.white);
    }
    _label(
      canvas,
      '카페',
      points[0] + const Offset(7, -7),
      size: 7,
      color: const Color(0xFFB65D40),
    );
    _label(
      canvas,
      '음식점',
      points[2] + const Offset(7, 4),
      size: 7,
      color: const Color(0xFFB65D40),
    );
  }

  void _label(
    Canvas canvas,
    String text,
    Offset position, {
    double size = 8,
    bool bold = false,
    Color color = const Color(0xFF8A877F),
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) => false;
}

class _FixedRandom {
  _FixedRandom(this._state);
  int _state;
  int nextInt(int max) {
    _state = (_state * 1103515245 + 12345) & 0x7fffffff;
    return _state % max;
  }
}
