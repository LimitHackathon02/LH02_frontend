// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'date_select_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: LayoutBuilder(builder: (context, c) {
      final h = c.maxHeight;
      return Stack(children: [
        const Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFFF0D5), Color(0xFFE4F3FB), Colors.white, Colors.white], stops: [0, .19, .40, 1])))),
        SafeArea(child: Column(children: [
          SizedBox(height: h * .13),
          const Text('세상이 빨라져도 우리는 만나요', style: TextStyle(fontSize: 11, color: Color(0xFF777777))),
          const SizedBox(height: 13),
          const Text('여러분을 위한\n맞춤형 약속', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, height: 1.45, fontWeight: FontWeight.w700, color: Color(0xFF2B100D))),
          SizedBox(height: h * .025),
          Expanded(child: Center(child: SizedBox(width: c.maxWidth * .60, height: c.maxWidth * .54, child: Stack(clipBehavior: Clip.none, children: [
            Positioned.fill(child: CustomPaint(painter: _LargeStarPainter())),
          ])))),
          const SizedBox(height: 18),
          Container(width: c.maxWidth * .61, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10), decoration: BoxDecoration(color: const Color(0xFFFFF1C8), borderRadius: BorderRadius.circular(22), boxShadow: const [BoxShadow(color: Color(0x14C89B32), blurRadius: 14)]), child: const Column(children: [Text('안녕하세요!', style: TextStyle(fontSize: 13, color: Color(0xFFB07A00))), SizedBox(height: 4), Text('만나미가 약속을 잡아줄게요', style: TextStyle(fontSize: 13, color: Color(0xFFB07A00)))])),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                height: 35,
                child: FilledButton(
                  onPressed: () => _openQuestions(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF191604),
                    foregroundColor: const Color(0xFFFFE88F),
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('직접 약속 잡기'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 35,
                child: OutlinedButton(
                  onPressed: () => _openQuestions(context),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF2BF),
                    foregroundColor: const Color(0xFF514936),
                    side: const BorderSide(color: Color(0xFFE2D6A8)),
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(fontSize: 11),
                  ),
                  child: const Text('그룹코드 입력'),
                ),
              ),
            ]),
          ),
          SizedBox(height: h * .06),
        ])),
      ]);
    }),
  );
}

void _openQuestions(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DateSelectScreen()));
}

class _LargeStarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    canvas.save(); canvas.scale(s.width/188, s.height/180);
    final path=Path()..moveTo(94,3)..cubicTo(119,3,123,31,140,40)..cubicTo(158,49,184,48,187,69)..cubicTo(190,91,166,103,160,119)..cubicTo(154,136,164,157,145,165)..cubicTo(127,173,108,155,94,155)..cubicTo(78,155,59,174,42,165)..cubicTo(24,156,34,137,28,120)..cubicTo(21,102,0,91,1,71)..cubicTo(2,50,29,48,46,40)..cubicTo(64,31,68,3,94,3)..close();
    canvas.drawPath(path, Paint()..color=const Color(0xFFFFD978));
    final arm=Paint()..color=const Color(0xFFFFD978)..strokeWidth=13..strokeCap=StrokeCap.round;
    canvas.drawLine(const Offset(31,105),const Offset(9,96),arm); canvas.drawLine(const Offset(157,105),const Offset(180,112),arm);
    final leg=Paint()..color=const Color(0xFFFFD978)..strokeWidth=11..strokeCap=StrokeCap.round;
    canvas.drawLine(const Offset(82,151),const Offset(80,176),leg); canvas.drawLine(const Offset(106,151),const Offset(108,176),leg);
    final eye=Paint()..color=const Color(0xFF603D32)..strokeWidth=5..strokeCap=StrokeCap.round..style=PaintingStyle.stroke;
    canvas.drawLine(const Offset(71,66),const Offset(79,71),eye);canvas.drawLine(const Offset(79,71),const Offset(75,77),eye);canvas.drawLine(const Offset(117,66),const Offset(109,71),eye);canvas.drawLine(const Offset(109,71),const Offset(113,77),eye);
    canvas.drawOval(const Rect.fromLTWH(59,82,17,9),Paint()..color=const Color(0xFFFFA49B));canvas.drawOval(const Rect.fromLTWH(112,82,17,9),Paint()..color=const Color(0xFFFFA49B));
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(87,80,14,11),const Radius.circular(6)),Paint()..color=const Color(0xFFB95755));canvas.restore();
  }
  @override bool shouldRepaint(covariant _LargeStarPainter oldDelegate)=>false;
}
