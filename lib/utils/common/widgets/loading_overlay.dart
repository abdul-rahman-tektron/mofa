import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/base/loading_state.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:provider/provider.dart';

class LoadingOverlay<T extends BaseChangeNotifier> extends StatelessWidget {
  final Widget child;
  const LoadingOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (_, notifier, __) {
        return Scaffold(
          body: Stack(
            children: [
              child,
              // Always absorb pointer events to block interaction beneath
              if (notifier.loadingState == LoadingState.Busy)
              Positioned.fill(
                child: AbsorbPointer(
                  absorbing: true,
                  // Use transparent container so it blocks interaction but doesn't obscure UI when not loading
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.black12,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              width: 180,
                              height: 180,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.buttonBgColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.white.withOpacity(0.2)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: DotCircleSpinner(),
                                  ),
                                  const SizedBox(height: 18),
                                  Text(
                                    '${context.watchLang.translate(AppLanguageText.loading)}...',
                                    style: AppFonts.textRegular18White,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


class DotCircleSpinner extends StatefulWidget {
  final double size;
  final Color color;
  final double dotSize;

  const DotCircleSpinner({
    super.key,
    this.size = 60,
    this.dotSize = 5,
    this.color = AppColors.whiteColor,
  });

  @override
  State<DotCircleSpinner> createState() => _DotCircleSpinnerState();
}

class _DotCircleSpinnerState extends State<DotCircleSpinner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            painter: _DotSpinnerPainter(
                animationValue: _controller.value,
                dotColor: widget.color,
                dotSize: widget.dotSize
            ),
          );
        },
      ),
    );
  }
}

class _DotSpinnerPainter extends CustomPainter {
  final double animationValue;
  final double dotSize;
  final Color dotColor;

  _DotSpinnerPainter({
    required this.animationValue,
    required this.dotColor,
    required this.dotSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const int dotCount = 12;
    final double radius = size.width / 2;
    final double dotRadius = dotSize;
    final Offset center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < dotCount; i++) {
      final double angle = 2 * pi * i / dotCount;
      final double dx = center.dx + radius * 0.7 * cos(angle);
      final double dy = center.dy + radius * 0.7 * sin(angle);

      // Create fade delay based on position
      final double progress = (animationValue + i / dotCount) % 1.0;
      final double opacity = (1.0 - progress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = dotColor.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dx, dy), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
