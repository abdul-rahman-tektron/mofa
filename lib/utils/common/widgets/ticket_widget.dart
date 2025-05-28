import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/model/get_all_detail/get_all_detail_response.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/utils/common/widgets/ticket_dialog.dart';
import 'package:mofa/utils/common_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vector_math/vector_math.dart' as v_math;

class TicketCard extends StatelessWidget {
  const TicketCard({
    super.key,
    this.appointmentData,
  });
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
            clipper: DolDurmaClipper(left: 101.w, holeRadius: 10),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1, color: CommonUtils.getStatusColor(
                    appointmentData?.sApprovalStatusEn ?? "")),
              ),
              child: Row(
                children: [
                  // QR Code on the left
                  Container(
                    width: 100.w,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: QrImageView(
                        version: QrVersions.auto,
                        data: appointmentData?.sQRCodeValue ?? "",
                      ),
                    ),
                  ),

                  // Dotted vertical line
                  CustomPaint(
                    painter: DottedLinePainter(
                        color: CommonUtils.getStatusColor(
                            appointmentData?.sApprovalStatusEn ?? "")),
                    child: SizedBox(
                      height: double.infinity,
                      width: 1,
                    ),
                  ),

                  // Title and subtitle on the right
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w, ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(appointmentData?.sVisitorName ?? "",
                              style: AppFonts.textRegular20),
                          5.verticalSpace,
                          Text(formatAppointmentRangeFromString(appointmentData?.dtAppointmentStartTime, appointmentData?.dtAppointmentEndTime),
                              style: AppFonts.textRegular12),
                          5.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(appointmentData?.sHostName ?? "",
                                    style: AppFonts.textRegular14, overflow: TextOverflow.ellipsis,),
                              ),
                              5.horizontalSpace,
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: CommonUtils.getStatusColor(appointmentData?.sApprovalStatusEn ?? ""),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Icon(LucideIcons.mapPin, color: Colors.white,
                                      size: 15,),
                                    5.horizontalSpace,
                                    Text(getFormattedLocation(appointmentData?.sLocationNameEn ?? ""),
                                        style: AppFonts.textBoldWhite14),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Positioned to cover the entire container to paint arcs
          Positioned.fill(
            child: CustomPaint(
              painter: ArcBorderPainter(left: 101.w,
                  holeRadius: 10,
                  strokeWidth: 1,
                  color: CommonUtils.getStatusColor(
                      appointmentData?.sApprovalStatusEn ?? "")),
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
        .map((word) =>
    word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
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
        return '$startDateStr، $startTimeStr - $endTimeStr';
      } else {
        return '$startDateStr ،$startTimeStr - $endDateStr ،$endTimeStr';
      }
    } catch (e) {
      return '';
    }
  }
}

class DolDurmaClipper extends CustomClipper<Path> {
  DolDurmaClipper({required this.left, required this.holeRadius});

  final double left; // position where the arc should appear
  final double holeRadius;

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(left - holeRadius, 0)
      ..arcToPoint(
        Offset(left + holeRadius, 0),
        clockwise: false,
        radius: Radius.circular(holeRadius),
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(left + holeRadius, size.height)
      ..arcToPoint(
        Offset(left - holeRadius, size.height),
        clockwise: false,
        radius: Radius.circular(holeRadius),
      )
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(DolDurmaClipper oldClipper) => true;
}

class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter({
    this.color = Colors.grey,
  });
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 4, startY = 0;
    final paint = Paint()
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

  ArcBorderPainter({
    required this.left,
    required this.holeRadius,
    this.color = Colors.grey,
    this.strokeWidth = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final arcInset = strokeWidth / 2;

    // Inner top arc
    final topArcRect = Rect.fromCircle(
      center: Offset(left, arcInset),
      radius: holeRadius - arcInset,
    );
    canvas.drawArc(
      topArcRect,
      v_math.radians(0),         // start from right
      -v_math.radians(-180),      // draw to the left (clockwise inside)
      false,
      paint,
    );

    // Inner bottom arc
    final bottomArcRect = Rect.fromCircle(
      center: Offset(left, size.height - arcInset),
      radius: holeRadius - arcInset,
    );
    canvas.drawArc(
      bottomArcRect,
      v_math.radians(180),       // start from left
      -v_math.radians(-180),      // draw to the right (clockwise inside)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
