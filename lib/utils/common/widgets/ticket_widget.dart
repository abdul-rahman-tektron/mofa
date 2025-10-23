import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/get_all_detail/get_all_detail_response.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/utils/common/widgets/ticket_dialog.dart';
import 'package:mofa/utils/common_utils.dart';
import 'package:mofa/utils/enum_values.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vector_math/vector_math.dart' as v_math;

class TicketCard extends StatelessWidget {
  const TicketCard({super.key, this.appointmentData});

  final GetExternalAppointmentData? appointmentData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showTicketDialog(context, appointmentData!);
      },
      child: Stack(
        children: [
          ClipPath(
            clipper: DolDurmaClipper(
              left: 101.w,
              holeRadius: 10,
              isRtl: context.lang == LanguageCode.ar.name,
            ),
            child: Container(
              height: 110.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 1,
                  color: CommonUtils.getStatusColor(appointmentData?.sApprovalStatusEn ?? ""),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // QR Code on the left
                  appointmentData?.sQRCodeValue?.isNotEmpty ?? false
                      ? Container(
                        width: 100.w,
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: QrImageView(
                            version: QrVersions.auto,
                            data: appointmentData?.sQRCodeValue ?? "",
                          ),
                        ),
                      )
                      : Container(
                        width: 100.w,
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            context.watchLang.translate(AppLanguageText.qrCodeNotGenerated),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                  // Dotted vertical line
                  CustomPaint(
                    painter: DottedLinePainter(
                      color: CommonUtils.getStatusColor(appointmentData?.sApprovalStatusEn ?? ""),
                    ),
                    child: SizedBox(
                      // height: 100,
                      width: 1,
                    ),
                  ),

                  // Title and subtitle on the right
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            appointmentData?.sVisitorName ?? "",
                            overflow: TextOverflow.ellipsis,
                            style:
                                MediaQuery.of(context).size.width > 360
                                    ? AppFonts.textRegular20
                                    : AppFonts.textRegular16,
                          ),
                          Text(
                            formatAppointmentRangeFromString(
                              appointmentData?.dtAppointmentStartTime,
                              appointmentData?.dtAppointmentEndTime,
                            ),
                            style:
                                MediaQuery.of(context).size.width > 360
                                    ? AppFonts.textRegular12
                                    : AppFonts.textRegular10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_pin,
                                    color: AppColors.buttonBgColor,
                                    size: 15,
                                  ),
                                  2.horizontalSpace,
                                  Text(
                                    getFormattedLocation(
                                      context.lang == LanguageCode.ar.name
                                          ? appointmentData?.sLocationNameAr ?? ""
                                          : appointmentData?.sLocationNameEn ?? "",
                                    ),
                                    style: AppFonts.textBold14,
                                  ),
                                ],
                              ),
                              5.horizontalSpace,
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: CommonUtils.getStatusColor(
                                    appointmentData?.sApprovalStatusEn ?? "",
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  getFormattedLocation(
                                    CommonUtils.getTranslatedStatus(
                                      context,
                                      appointmentData?.sApprovalStatusEn ?? "",
                                    ),
                                  ),
                                  style: AppFonts.textBoldWhite14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Positioned to cover the entire container to paint arcs
          Positioned.fill(
            child: CustomPaint(
              painter: ArcBorderPainter(
                left: 101.w,
                holeRadius: 10,
                strokeWidth: 1,
                color: CommonUtils.getStatusColor(appointmentData?.sApprovalStatusEn ?? ""),
                isRtl: context.lang == LanguageCode.ar.name,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getFormattedLocation(String location) {
    final lowerLocation = location.toLowerCase();

    if (lowerLocation.contains("makkah")) {
      return "Makkah";
    } else if (lowerLocation.contains("jeddah")) {
      return "Jeddah";
    } else if (lowerLocation.contains("madina") || lowerLocation.contains("medina")) {
      return "Al Madina";
    } else if (lowerLocation.contains("riyadh")) {
      return "Riyadh";
    }

    // Fallback: Capitalize first letter of each word (optional)
    return location
        .split(' ')
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }

  String formatAppointmentRangeFromString(String? startStr, String? endStr) {
    if (startStr == null || endStr == null) return '';

    try {
      final inputFormat = DateFormat('M/d/yyyy h:mm:ss a');
      final start = inputFormat.parse(startStr);
      final end = inputFormat.parse(endStr);

      final dateFormat = DateFormat('MMM d, yyyy');
      final timeFormat = DateFormat('h:mm a');

      final startDateStr = dateFormat.format(start);
      final endDateStr = dateFormat.format(end);
      final startTimeStr = timeFormat.format(start);
      final endTimeStr = timeFormat.format(end);

      if (startDateStr == endDateStr) {
        return '$startDateStr, $startTimeStr - $endTimeStr';
      } else {
        return '$startDateStr, $startTimeStr - $endDateStr, $endTimeStr';
      }
    } catch (e) {
      return '';
    }
  }
}

class DolDurmaClipper extends CustomClipper<Path> {
  DolDurmaClipper({required this.left, required this.holeRadius, this.isRtl = false});

  final double left;
  final double holeRadius;
  final bool isRtl;

  @override
  Path getClip(Size size) {
    final path = Path();

    if (!isRtl) {
      // Left side arc (LTR)
      path
        ..moveTo(0, 0)
        ..lineTo(left - holeRadius, 0)
        ..arcToPoint(
          Offset(left + holeRadius, 0),
          radius: Radius.circular(holeRadius),
          clockwise: false,
        )
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(left + holeRadius, size.height)
        ..arcToPoint(
          Offset(left - holeRadius, size.height),
          radius: Radius.circular(holeRadius),
          clockwise: false,
        )
        ..lineTo(0, size.height)
        ..close();
    } else {
      // Right side arc (RTL) — mirrored LTR
      final arcCenterX = size.width - left;
      path
        ..moveTo(size.width, 0)
        ..lineTo(arcCenterX + holeRadius, 0)
        ..arcToPoint(
          Offset(arcCenterX - holeRadius, 0),
          radius: Radius.circular(holeRadius),
          clockwise: true,
        )
        ..lineTo(0, 0)
        ..lineTo(0, size.height)
        ..lineTo(arcCenterX - holeRadius, size.height)
        ..arcToPoint(
          Offset(arcCenterX + holeRadius, size.height),
          radius: Radius.circular(holeRadius),
          clockwise: true,
        )
        ..lineTo(size.width, size.height)
        ..close();
    }

    return path;
  }

  @override
  bool shouldReclip(DolDurmaClipper oldClipper) => true;
}

class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter({this.color = Colors.grey});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 4, startY = 0;
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 1;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ArcBorderPainter extends CustomPainter {
  final double left;
  final double holeRadius;
  final Color color;
  final double strokeWidth;
  final bool isRtl;

  ArcBorderPainter({
    required this.left,
    required this.holeRadius,
    this.color = Colors.grey,
    this.strokeWidth = 1.5,
    this.isRtl = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

    final arcInset = strokeWidth / 2;

    final arcCenterX = isRtl ? (size.width - left) : left;

    // Inner top arc
    final topArcRect = Rect.fromCircle(
      center: Offset(arcCenterX, arcInset),
      radius: holeRadius - arcInset,
    );
    canvas.drawArc(
      topArcRect,
      v_math.radians(0), // start from right (clockwise)
      -v_math.radians(-180), // draw to the left (clockwise inside)
      false,
      paint,
    );

    // Inner bottom arc
    final bottomArcRect = Rect.fromCircle(
      center: Offset(arcCenterX, size.height - arcInset),
      radius: holeRadius - arcInset,
    );
    canvas.drawArc(
      bottomArcRect,
      v_math.radians(180), // start from left
      -v_math.radians(-180), // draw to the right (clockwise inside)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
