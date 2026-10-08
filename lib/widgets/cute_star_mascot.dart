import 'package:flutter/material.dart';

/// Small rounded star mascot used by the onboarding and recommendation screens.
class CuteStarMascot extends StatelessWidget {
  const CuteStarMascot({super.key, this.width = 68, this.height = 58});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    height: height,
    child: CustomPaint(painter: _StarMascotPainter()),
  );
}

class _StarMascotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 100;
    final sy = size.height / 100;
    canvas.save();
    canvas.scale(sx, sy);
    final shadow = Paint()..color = const Color(0x1E786A51);
    canvas.drawOval(const Rect.fromLTWH(20, 86, 60, 9), shadow);
    final fill = Paint()..color = const Color(0xFFFFD978);
    final path = Path()
      ..moveTo(50, 5)
      ..cubicTo(61, 5, 66, 22, 73, 29)
      ..cubicTo(80, 36, 97, 35, 99, 47)
      ..cubicTo(101, 59, 84, 66, 81, 76)
      ..cubicTo(78, 87, 82, 98, 70, 99)
      ..cubicTo(61, 100, 56, 92, 50, 92)
      ..cubicTo(43, 92, 36, 100, 27, 98)
      ..cubicTo(16, 95, 22, 82, 18, 73)
      ..cubicTo(14, 63, 0, 58, 1, 47)
      ..cubicTo(2, 36, 19, 35, 27, 29)
      ..cubicTo(36, 22, 39, 5, 50, 5)
      ..close();
    canvas.drawPath(path, fill);
    final limb = Paint()..color = const Color(0xFFFFD978);
    limb.strokeWidth = 8;
    limb.strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(18, 59), const Offset(5, 54), limb);
    canvas.drawLine(const Offset(82, 59), const Offset(96, 63), limb);
    final leg = Paint()..color = const Color(0xFFFFD978);
    leg.strokeWidth = 7;
    leg.strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(42, 86), const Offset(40, 98), leg);
    canvas.drawLine(const Offset(58, 86), const Offset(60, 98), leg);
    final eye = Paint()
      ..color = const Color(0xFF603D32)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(36, 43), const Offset(40, 46), eye);
    canvas.drawLine(const Offset(40, 46), const Offset(37, 49), eye);
    canvas.drawLine(const Offset(64, 43), const Offset(60, 46), eye);
    canvas.drawLine(const Offset(60, 46), const Offset(63, 49), eye);
    final blush = Paint()..color = const Color(0xFFFFA49B);
    canvas.drawOval(const Rect.fromLTWH(28, 51, 12, 6), blush);
    canvas.drawOval(const Rect.fromLTWH(60, 51, 12, 6), blush);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(46, 52, 8, 7), const Radius.circular(4)),
      Paint()..color = const Color(0xFFB95755),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _StarMascotPainter oldDelegate) => false;
}
