import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/get_all_detail/get_all_detail_response.dart';
import 'package:mofa/model/custom_args/custom_args.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/utils/app_routes.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common_utils.dart';
import 'package:mofa/utils/enum_values.dart';
import 'package:mofa/utils/extensions.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vector_math/vector_math.dart' as v_math;

showTicketDialog(BuildContext context, GetExternalAppointmentData appointmentData) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) => Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500, // Controls dialog width on large screens (e.g. tablets)
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16), // Space around the dialog
          child: TicketDialogWrapper(appointmentData: appointmentData),
        ),
      ),
    ),
  );
}

class TicketDialogWrapper extends StatefulWidget {
  final GetExternalAppointmentData? appointmentData;
  const TicketDialogWrapper({super.key, this.appointmentData});

  @override
  State<TicketDialogWrapper> createState() => _TicketDialogWrapperState();
}

class _TicketDialogWrapperState extends State<TicketDialogWrapper> {
  final GlobalKey _dottedLineKey = GlobalKey();
   double _arcTop = 210; // Fixed top offset from your visual design

  @override
  void initState() {
    super.initState();
    // Delay to allow build to complete
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateArcPosition());
  }

  void _calculateArcPosition() {
    final RenderBox? box = _dottedLineKey.currentContext?.findRenderObject() as RenderBox?;
    final offset = box?.localToGlobal(Offset.zero);
    final dialogTop = context.findRenderObject() is RenderBox
        ? (context.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dy
        : 0;

    if (offset != null) {
      setState(() {
        _arcTop = offset.dy - dialogTop + 15.h; // Add 1px buffer to avoid clipping
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipPath(
            clipper: DolDurmaClipper(top: _arcTop, holeRadius: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 2,
                  color: CommonUtils.getStatusColor(widget.appointmentData?.sApprovalStatusEn ?? ""),
                ),
              ),
              padding: EdgeInsets.only(top: 20.w),
              child: TicketDialogContent(
                appointmentData: widget.appointmentData,
                dottedLineKey: _dottedLineKey,
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: ArcBorderPainter(
                  top: _arcTop,
                  holeRadius: 15,
                  color: CommonUtils.getStatusColor(widget.appointmentData?.sApprovalStatusEn ?? ""),
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class TicketDialogContent extends StatelessWidget {
  final GetExternalAppointmentData? appointmentData;
  final GlobalKey? dottedLineKey;

  const TicketDialogContent({super.key, required this.appointmentData, this.dottedLineKey});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250, minWidth: 150, maxHeight: 200),
          child: appointmentData?.sQRCodeValue?.isNotEmpty ?? false ? QrImageView(
            data: appointmentData?.sQRCodeValue ?? "",
            // size: 150.w,
            backgroundColor: Colors.white,
          ) : Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                context.watchLang.translate(AppLanguageText.qrCodeNotGenerated), style: AppFonts.textRegularGrey17,
                textAlign: TextAlign.center,),
            ),
          ),
        ),
        _dottedLineWithKey(context),
        _visitorDetails(context, appointmentData),
        _dottedLine(context),
        _dateDetails(context, appointmentData),
        15.verticalSpace,
        _actionButtons(context, appointmentData),
        10.verticalSpace,
      ],
    );
  }

// With GlobalKey — for arc positioning
  Widget _dottedLineWithKey(BuildContext context) => Column(
    key: dottedLineKey, // ✅ key added here
    children: [
      15.verticalSpace,
      SizedBox(
        height: 1,
        child: CustomPaint(
          size: const Size(double.infinity, 1),
          painter: HorizontalDottedLinePainter(
            color: CommonUtils.getStatusColor(appointmentData?.sApprovalStatusEn ?? ""),
          ),
        ),
      ),
      15.verticalSpace,
    ],
  );


// Without key
  Widget _dottedLine(BuildContext context) => Column(
    children: [
      15.verticalSpace,
      SizedBox(
        height: 1,
        child: CustomPaint(
          size: const Size(double.infinity, 1),
          painter: HorizontalDottedLinePainter(
            color: CommonUtils.getStatusColor(appointmentData?.sApprovalStatusEn ?? ""),
          ),
        ),
      ),
      15.verticalSpace,
    ],
  );


  Widget _visitorDetails(BuildContext context, GetExternalAppointmentData? data) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(data?.sVisitorName ?? "", style: AppFonts.textRegular24),
        5.verticalSpace,
        Text(data?.sEmail ?? "", style: AppFonts.textRegular16),
        5.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "${context.watchLang.translate(AppLanguageText.host)}: ",
                      style: AppFonts.textBold16,
                    ),
                    TextSpan(
                      text: data?.sSponsor ?? "",
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                style: AppFonts.textRegular16, // base style
              ),
            ),
            10.horizontalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: CommonUtils.getStatusColor(data?.sApprovalStatusEn ?? ""),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Text(CommonUtils.getTranslatedStatus(context, data?.sApprovalStatusEn ?? ""), style: AppFonts.textRegular16White),
                ],
              ),),
          ],
        ),
      ],
    ),
  );

  Widget _dateDetails(BuildContext context, GetExternalAppointmentData? data) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(child: Text(context.watchLang.translate(AppLanguageText.startDate), style: AppFonts.textBold14)),
            15.horizontalSpace,
            Expanded(child: Text(context.watchLang.translate(AppLanguageText.endDate), style: AppFonts.textBold14)),
          ],
        ),
        3.verticalSpace,
        Row(
          children: [
            Expanded(child: Text(data?.dtAppointmentStartTime?.toDisplayDateTime() ?? "", style: AppFonts.textRegular14,)),
            15.horizontalSpace,
            Expanded(child: Text(data?.dtAppointmentEndTime?.toDisplayDateTime() ?? "", style: AppFonts.textRegular14,)),
          ],
        ),
      ],
    ),
  );

  Widget _actionButtons(BuildContext context, GetExternalAppointmentData? appointment) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CustomButton(
        text: context.watchLang.translate(AppLanguageText.viewDetails),
        height: 40,
        // backgroundColor: AppColors.whiteColor,
        // borderColor: AppColors.buttonBgColor,
        textFont: AppFonts.textMedium14White,
        smallWidth: true,
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamed(
            context,
            AppRoutes.stepper,
            arguments: StepperScreenArgs(
                category: ApplyPassCategory.someoneElse,
                isUpdate: true,
                id: appointment?.nAppointmentId ?? 0),
          );
        }
      ),
      15.horizontalSpace,
      CustomButton(
        text: context.watchLang.translate(AppLanguageText.close),
        height: 40,
        backgroundColor: AppColors.whiteColor,
        borderColor: AppColors.buttonBgColor,
        textFont: AppFonts.textBold14,
        smallWidth: true,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}


class DolDurmaClipper extends CustomClipper<Path> {
  final double top;
  final double holeRadius;

  DolDurmaClipper({required this.top, required this.holeRadius});

  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top-left corner
    path.moveTo(0, 0);
    path.lineTo(size.width, 0); // top edge
    path.lineTo(size.width, size.height); // right edge
    path.lineTo(0, size.height); // bottom edge
    path.close(); // close the rectangle

    // Cutout: left semicircle
    final leftNotch = Path()
      ..addOval(Rect.fromCircle(center: Offset(0, top), radius: holeRadius));

    // Cutout: right semicircle
    final rightNotch = Path()
      ..addOval(Rect.fromCircle(center: Offset(size.width, top), radius: holeRadius));

    // Combine everything and subtract notches
    return Path.combine(
      PathOperation.difference,
      path,
      Path.combine(PathOperation.union, leftNotch, rightNotch),
    );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class HorizontalDottedLinePainter extends CustomPainter {
  final Color color;

  HorizontalDottedLinePainter({
    this.color = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 4, startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


class ArcBorderPainter extends CustomPainter {
  final double top;
  final double holeRadius;
  final Color color;
  final double strokeWidth;

  ArcBorderPainter({
    required this.top,
    required this.holeRadius,
    this.color = AppColors.buttonBgColor,
    this.strokeWidth = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final arcInset = strokeWidth / 2;

    // Left side arc
    final leftArc = Rect.fromCircle(
      center: Offset(arcInset, top),
      radius: holeRadius - arcInset,
    );
    canvas.drawArc(leftArc, v_math.radians(90), v_math.radians(-180), false, paint);

    // Right side arc
    final rightArc = Rect.fromCircle(
      center: Offset(size.width - arcInset, top),
      radius: holeRadius - arcInset,
    );
    canvas.drawArc(rightArc, v_math.radians(270), v_math.radians(-180), false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

