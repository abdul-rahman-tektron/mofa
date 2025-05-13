import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mofa/res/app_colors.dart';

class CaptchaWidget extends StatefulWidget {
  final String userCaptchaInput;
  final String recaptchaError;
  final Function(String) setUserCaptchaInput;
  final Function(String) setCaptchaText;

  const CaptchaWidget({
    required this.userCaptchaInput,
    required this.recaptchaError,
    required this.setUserCaptchaInput,
    required this.setCaptchaText,
    super.key,
  });

  @override
  State<CaptchaWidget> createState() => _CaptchaWidgetState();
}

class _CaptchaWidgetState extends State<CaptchaWidget> {
  late String captchaText;

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  void _generateCaptcha() {
    final random = Random();
    captchaText = List.generate(6, (_) => random.nextInt(10).toString()).join();
    widget.setCaptchaText(captchaText);
  }

  void _refreshCaptcha() {
    setState(() {
      _generateCaptcha();
      widget.setUserCaptchaInput('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomPaint(
              size: const Size(200, 70),
              painter: CaptchaPainter(captchaText),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshCaptcha,
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 200,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter Captcha',
              hintStyle: TextStyle(color: AppColors.fieldBorderColor),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.fieldBorderColor,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.fieldBorderColor,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.fieldBorderColor,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            onChanged: widget.setUserCaptchaInput,
            controller: TextEditingController(text: widget.userCaptchaInput),
          ),
        ),
        if (widget.recaptchaError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.recaptchaError,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
}

class CaptchaPainter extends CustomPainter {
  final String text;

  CaptchaPainter(this.text);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final bgPaint = Paint()..color = const Color(0xFFE0E0E9);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final random = Random();

    // Draw background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Draw text
    for (int i = 0; i < text.length; i++) {
      final fontSize = 30.0;
      final angle = (random.nextDouble() - 0.5) * 0.4;
      final textSpan = TextSpan(
        text: text[i],
        style: TextStyle(fontSize: fontSize, color: Colors.black),
      );
      textPainter.text = textSpan;
      textPainter.layout();

      final x = 20 + i * 30;
      final y = 20 + random.nextDouble() * 20;
      canvas.save();
      canvas.translate(x.toDouble(), y);
      canvas.rotate(angle);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }

    // Draw noise
    for (int i = 0; i < 100; i++) {
      paint.color = Colors.black.withOpacity(random.nextDouble());
      canvas.drawRect(
        Rect.fromLTWH(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
          2,
          2,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CaptchaPainter oldDelegate) {
    return oldDelegate.text != text;
  }
}