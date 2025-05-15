import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CaptchaRenderData {
  final List<CaptchaChar> characters;
  final List<Offset> noiseDots;

  CaptchaRenderData({required this.characters, required this.noiseDots});

  static CaptchaRenderData generate(String code) {
    final random = Random();
    final List<CaptchaChar> chars = [];
    final List<Offset> dots = [];

    for (int i = 0; i < code.length; i++) {
      double dx = 15.0 + i * 35 + random.nextDouble() * 5;  // Adjusted spacing for smaller width
      double dy = 10.0 + random.nextDouble() * 30;          // Keep within 80 height
      double angle = (random.nextDouble() * 2 - 1) * 0.4;   // Rotation -0.4 to +0.4
      chars.add(CaptchaChar(char: code[i], offset: Offset(dx, dy), angle: angle));
    }

    for (int i = 0; i < 80; i++) {
      dots.add(Offset(random.nextDouble() * 220, random.nextDouble() * 80));
    }

    return CaptchaRenderData(characters: chars, noiseDots: dots);
  }
}

class CaptchaChar {
  final String char;
  final Offset offset;
  final double angle;

  CaptchaChar({required this.char, required this.offset, required this.angle});
}

class CaptchaWidget extends StatelessWidget {
  final CaptchaRenderData? renderData;

  CaptchaWidget({required this.renderData});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(220, 80),
      painter: renderData != null ? _CaptchaPainter(renderData!) : null,
    );
  }
}

class _CaptchaPainter extends CustomPainter {
  final CaptchaRenderData data;

  _CaptchaPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final bgPaint = Paint()..color = const Color(0xFFE0E0E9); // Light gray background
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Background
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Draw text
    for (final char in data.characters) {
      final fontSize = 30.0;
      final textSpan = TextSpan(
        text: char.char,
        style: TextStyle(fontSize: fontSize, color: Colors.black),
      );

      textPainter.text = textSpan;
      textPainter.layout();

      canvas.save();
      canvas.translate(char.offset.dx, char.offset.dy);
      canvas.rotate(char.angle);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }

    // Draw noise: squares instead of circles
    for (final dot in data.noiseDots) {
      paint.color = Colors.black.withOpacity(Random().nextDouble());
      canvas.drawRect(Rect.fromLTWH(dot.dx, dot.dy, 2, 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}