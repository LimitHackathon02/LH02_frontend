import 'dart:math' as math;
import 'package:flutter/material.dart';

class TimeSelectScreen extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const TimeSelectScreen({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<TimeSelectScreen> createState() => _TimeSelectScreenState();
}

class _TimeSelectScreenState extends State<TimeSelectScreen> {
  double startHour = 9;
  double endHour = 18.5;
  bool draggingStart = true;

  String formatHour(double value) {
    final hour = value.floor() % 24;
    final minute = ((value - value.floor()) * 60).round();
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:${minute.toString().padLeft(2, '0')}';
  }

  double hourFromPosition(Offset point, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final angle = math.atan2(point.dy - center.dy, point.dx - center.dx);

    return (((angle + math.pi / 2) / (2 * math.pi) * 24 + 24) % 24)
        .roundToDouble();
  }

  void updateTime(Offset position, Size size) {
    final hour = hourFromPosition(position, size);

    setState(() {
      if (draggingStart) {
        startHour = hour;
      } else {
        endHour = hour;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 뒤로 가기
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
              ),

              const SizedBox(height: 65),

              // 상단 안내 문구
              Container(
                padding: const EdgeInsets.all(5),
                color: const Color(0xFFFFF5D2),
                child: const Text(
                  '모두가 만족하는 일정을 정해볼게요',
                  style: TextStyle(color: Color(0xFFAA801B), fontSize: 13),
                ),
              ),

              const SizedBox(height: 22),

              const Text('STEP.1', style: TextStyle(color: Colors.grey)),

              const SizedBox(height: 6),

              // 제목
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF281313),
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(text: '원하는 '),
                    TextSpan(
                      text: '시간',
                      style: TextStyle(color: Color(0xFFE65E61)),
                    ),
                    TextSpan(text: '을\n선택해주세요'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 원형 시간 선택 UI
              Center(
                child: SizedBox(
                  width: 270,
                  height: 270,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 기존 시간 선택 기능 유지
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanStart: (details) {
                          final size = const Size(270, 270);

                          final touchedHour = hourFromPosition(
                            details.localPosition,
                            size,
                          );

                          double distance(double a, double b) {
                            final d = (a - b).abs();
                            return math.min(d, 24 - d);
                          }

                          draggingStart =
                              distance(touchedHour, startHour) <=
                              distance(touchedHour, endHour);
                        },
                        onPanUpdate: (details) {
                          updateTime(
                            details.localPosition,
                            const Size(270, 270),
                          );
                        },
                        child: CustomPaint(
                          painter: TimeRingPainter(
                            startHour: startHour,
                            endHour: endHour,
                          ),
                          child: const SizedBox(width: 270, height: 270),
                        ),
                      ),

                      // 만나미 캐릭터
                      Positioned(
                        bottom: 25,
                        child: IgnorePointer(
                          child: Image.asset(
                            'assets/images/mannami_only.png',
                            width: 115,
                            height: 115,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // 선택한 시간 표시
                      Positioned(
                        top: 72,
                        child: IgnorePointer(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF5D2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              '${formatHour(startHour)} - ${formatHour(endHour)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFAA801B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 노란색 안내 상자
              Container(
                width: double.infinity,
                height: 90,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF8E5), Color(0xFFF8E8B7)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '참여인원이 가능한 시간을\n모두 반영해드려요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.7,
                    color: Color(0xFFBD8B24),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // 다음 버튼
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 88,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('일정 선택 완료'),
                          content: Text(
                            '${widget.startDate.year}년 ${widget.startDate.month}월 ${widget.startDate.day}일'
                            '${widget.endDate != widget.startDate ? ' - ${widget.endDate.month}월 ${widget.endDate.day}일' : ''}\n'
                            '${formatHour(startHour)} - ${formatHour(endHour)}',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('확인'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFF2BD),
                      foregroundColor: const Color(0xFF6B5B32),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Color(0xFFE2D7B2)),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('다음', style: TextStyle(fontSize: 12)),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 13),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

// 원형 시간 선택 슬라이더 그리기
class TimeRingPainter extends CustomPainter {
  final double startHour;
  final double endHour;

  TimeRingPainter({required this.startHour, required this.endHour});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.width / 2 - 15;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // 원형 테두리
    final basePaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius + 10, basePaint);
    canvas.drawCircle(center, radius - 10, basePaint);

    // 시작 시간과 종료 시간의 각도
    final startAngle = -math.pi / 2 + startHour / 24 * 2 * math.pi;

    final endAngle = -math.pi / 2 + endHour / 24 * 2 * math.pi;

    final sweep = (endAngle - startAngle + 2 * math.pi) % (2 * math.pi);

    // 노란색 시간 선택 영역
    final arcPaint = Paint()
      ..color = const Color(0xFFFFE3A0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 17
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweep, false, arcPaint);

    // 시작점과 종료점 표시
    for (final angle in [startAngle, endAngle]) {
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      canvas.drawCircle(point, 9, Paint()..color = const Color(0xFFE2C779));
    }
  }

  @override
  bool shouldRepaint(covariant TimeRingPainter oldDelegate) {
    return oldDelegate.startHour != startHour || oldDelegate.endHour != endHour;
  }
}
