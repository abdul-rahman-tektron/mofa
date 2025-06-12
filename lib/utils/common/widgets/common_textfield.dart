import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';

import '../../common_validation.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String fieldName;
  final String? hintText;
  final bool isPassword;
  final bool skipValidation;
  final bool? isMaxLines;
  final bool? titleVisibility;
  final TextStyle? hintStyle;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final void Function()? onTapSuffix;
  final String? Function(String?)? validator;
  final Color? borderColor;
  final TextInputAction textInputAction;
  final Color? backgroundColor;
  final bool hidePassIcon;
  final bool isEditable;
  final bool isSmallFieldFont;
  final bool isEnable;
  final String? toolTipContent;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? initialDate;
  final bool needTime;
  final bool isAutoValidate;
  final bool showAsterisk;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.fieldName,
    this.hintText,
    this.isPassword = false,
    this.keyboardType,
    this.onChanged,
    this.hintStyle,
    this.onTapSuffix,
    this.validator,
    this.titleVisibility = true,
    this.isMaxLines,
    this.skipValidation = false,
    this.borderColor,
    this.textInputAction = TextInputAction.done,
    this.backgroundColor,
    this.hidePassIcon = false,
    this.isEditable = true,
    this.isEnable = true,
    this.isSmallFieldFont = false,
    this.toolTipContent,
    this.startDate,
    this.endDate,
    this.initialDate,
    this.needTime = false,
    this.isAutoValidate = true,
    this.showAsterisk = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  DateTime? _selectedDate;

  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.dispose();
    super.dispose();
  }

  void _showOverlay() {
    _removeOverlay();
    final overlay = Overlay.of(context);
    if (overlay != null) {
      _overlayEntry = _createOverlayEntry();
      overlay.insert(_overlayEntry!);
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    // This is the rect of the TextField in global coordinates
    final fieldRect = Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);

    return OverlayEntry(
      builder: (context) => Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (event) {
          // If tap is outside the textfield rect, unfocus
          if (!fieldRect.contains(event.position)) {
            _focusNode.unfocus();
            _removeOverlay();
          }
        },
        child: const SizedBox.expand(), // fills screen and catches taps
      ),
    );
  }

  void _toggleVisibility() => setState(() => _obscureText = !_obscureText);

  String _formatDateTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat(widget.needTime ? 'dd/MM/yyyy, hh:mm a' : 'dd/MM/yyyy').format(date);
  }

  OutlineInputBorder _buildBorder(Color color) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 2.5),
    borderRadius: BorderRadius.circular(15.0),
  );

  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate = _selectedDate ?? widget.initialDate ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          datePickerTheme: DatePickerThemeData(
            headerBackgroundColor: AppColors.buttonBgColor,
            headerForegroundColor: AppColors.whiteColor,
          ),
          colorScheme: ColorScheme.light(
            primary: AppColors.buttonBgColor,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: AppColors.buttonBgColor)),
        ),
        child: child!,
      ),
      initialDate: initialDate.isBefore(widget.startDate ?? DateTime(1900))
          ? (widget.startDate ?? DateTime.now())
          : initialDate,
      firstDate: widget.startDate ?? DateTime(1900),
      lastDate: widget.endDate ?? DateTime(2100),
    );

    if (picked != null) {
      DateTime finalDateTime = picked;

      if (widget.needTime) {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(_selectedDate ?? DateTime.now()),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                backgroundColor: Colors.white,
                hourMinuteTextColor: AppColors.whiteColor,
                entryModeIconColor: AppColors.buttonBgColor,
                dayPeriodColor: AppColors.buttonBgColor.withOpacity(0.3),
                dayPeriodShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(color: AppColors.buttonBgColor, width: 1),
                ),
              ),
              colorScheme: ColorScheme.light(
                primary: AppColors.buttonBgColor,
                onPrimary: Colors.white,
                surface: AppColors.buttonBgColor.withOpacity(0.1),
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: AppColors.buttonBgColor),
              ),
            ),
            child: child!,
          ),
        );

        if (time != null) {
          finalDateTime = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
        }
      }

      if (widget.startDate != null && finalDateTime.isBefore(widget.startDate!)) {
        finalDateTime = widget.startDate!.add(const Duration(hours: 1));
      }

      setState(() {
        _selectedDate = finalDateTime;
        final formattedDate = _formatDateTime(_selectedDate);
        widget.controller.text = formattedDate;
        widget.onChanged?.call(formattedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final showTitle = widget.titleVisibility ?? true;
    final textColor = !widget.isEnable
        ? (widget.isSmallFieldFont ? AppFonts.textRegularGrey14 : AppFonts.textRegularGrey17)
        : (widget.isSmallFieldFont ? AppFonts.textRegular14 : AppFonts.textRegular17);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(widget.fieldName, style: textColor),
                  if (!widget.skipValidation) 3.horizontalSpace,
                  if (!widget.skipValidation)
                    if(!widget.showAsterisk)
                    const Text("*", style: TextStyle(fontSize: 15, color: AppColors.textRedColor)),
                  if (widget.toolTipContent != null) ...[
                    const SizedBox(width: 3),
                    Tooltip(
                      message: widget.toolTipContent!,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(Icons.info_outline, size: 20, color: AppColors.primaryColor),
                    ),
                  ],
                ],
              ),
              if (widget.isPassword && !widget.hidePassIcon)
                GestureDetector(
                  onTap: _toggleVisibility,
                  child: Row(
                    children: [
                      Icon(
                        _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        size: 24,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        context.watchLang.translate(
                          _obscureText ? AppLanguageText.show : AppLanguageText.hide,
                        ),
                        style: AppFonts.textRegular18,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        if (showTitle) const SizedBox(height: 5),
        CompositedTransformTarget(
          link: _layerLink,
          child: TextFormField(
            focusNode: _focusNode,
            controller: widget.controller,
            textInputAction: widget.textInputAction,
            obscureText: widget.isPassword && _obscureText,
            obscuringCharacter: "*",
            readOnly: !widget.isEditable || widget.keyboardType == TextInputType.datetime,
            enabled: widget.isEnable,
            enableInteractiveSelection: widget.keyboardType != TextInputType.datetime,
            enableSuggestions: false,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            onTap: widget.keyboardType == TextInputType.datetime ? () => _selectDate(context) : null,
            maxLines: widget.isMaxLines == true ? 4 : 1,
            style: textColor,
            autovalidateMode:  !widget.isAutoValidate ? null : AutovalidateMode.onUserInteraction,
            validator: widget.skipValidation ? null : widget.validator ?? (value) => CommonValidation().commonValidator(context, value),
            decoration: InputDecoration(
              fillColor: widget.isEnable ? (widget.backgroundColor ?? AppColors.whiteColor) : AppColors.disabledFieldColor,
              filled: true,
              hintText: widget.hintText,
              hintStyle: widget.hintStyle ?? AppFonts.textRegularGrey16,
              labelStyle: widget.isEnable ? AppFonts.textRegular17 : AppFonts.textRegularGrey16,
              errorStyle: const TextStyle(color: AppColors.underscoreColor),
              border: _buildBorder(widget.borderColor ?? AppColors.fieldBorderColor),
              enabledBorder: _buildBorder(widget.borderColor ?? AppColors.fieldBorderColor),
              disabledBorder: _buildBorder(widget.borderColor ?? AppColors.fieldBorderColor),
              errorBorder: _buildBorder(widget.borderColor ?? AppColors.fieldBorderColor),
              focusedBorder: _buildBorder(widget.borderColor ?? AppColors.fieldBorderColor),
              focusedErrorBorder: _buildBorder(widget.borderColor ?? AppColors.fieldBorderColor),
            ),
          ),
        ),
      ],
    );
  }
}

