import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/base/loading_state.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:provider/provider.dart';

class LoadingOverlay<T extends BaseChangeNotifier> extends StatelessWidget {
  final Widget child;
  const LoadingOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (_, notifier, __) {
        return Stack(
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
                              children: const [
                                SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: DoubleRingSpinner(),
                                ),
                                SizedBox(height: 18),
                                Text(
                                  'Loading...',
                                  style: AppFonts.textRegular24White,
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
        );
      },
    );
  }
}


class DoubleRingSpinner extends StatefulWidget {
  const DoubleRingSpinner({super.key});

  @override
  State<DoubleRingSpinner> createState() => _DoubleRingSpinnerState();
}

class _DoubleRingSpinnerState extends State<DoubleRingSpinner> with TickerProviderStateMixin {
  late final AnimationController _outer;
  late final AnimationController _inner;

  @override
  void initState() {
    super.initState();
    _outer = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _inner = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
  }

  @override
  void dispose() {
    _outer.dispose();
    _inner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: _outer,
            child: CustomPaint(
              size: const Size(60, 60),
              painter: RingPainter(color: Colors.white.withOpacity(0.4), strokeWidth: 5),
            ),
          ),
          RotationTransition(
            turns: _inner,
            child: CustomPaint(
              size: const Size(34, 34),
              painter: RingPainter(color: Colors.white, strokeWidth: 4),
            ),
          ),
        ],
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  RingPainter({required this.color, this.strokeWidth = 4});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final rect = Offset.zero & size;
    final start = -90.0;
    final sweep = 270.0;

    canvas.drawArc(rect.deflate(strokeWidth / 2), radians(start), radians(sweep), false, paint);
  }

  double radians(double degrees) => degrees * 3.1415926535 / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
