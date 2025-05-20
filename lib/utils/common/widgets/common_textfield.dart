import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:provider/provider.dart';

import '../common_validation.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String fieldName;
  final String? hintText;
  final bool isPassword;
  final bool skipValidation;
  final bool? isMaxLines;
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
  final bool isDisable;
  final String? toolTipContent;
  final DateTime? startDate;
  final DateTime? endDate;

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
    this.isMaxLines,
    this.skipValidation = false,
    this.borderColor,
    this.textInputAction = TextInputAction.done,
    this.backgroundColor,
    this.hidePassIcon = false,
    this.isEditable = true,
    this.isDisable = false,
    this.isSmallFieldFont = false,
    this.toolTipContent,
    this.startDate,
    this.endDate,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  DateTime? _selectedDate;


  // Toggle password visibility
  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Format date to dd/mm/yyyy
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Display date picker and update text field with selected date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate = _selectedDate ?? widget.startDate ?? DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.buttonBgColor, // header background color
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.buttonBgColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
      initialDate: initialDate.isBefore(widget.startDate ?? DateTime(1900))
          ? (widget.startDate ?? DateTime.now())
          : initialDate,
      firstDate: widget.startDate ?? DateTime(1900),
      lastDate: widget.endDate ?? DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.controller.text = _formatDate(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(widget.fieldName, style: widget.isSmallFieldFont
                    ? AppFonts.textRegular14
                    : AppFonts.textRegular18,),
                SizedBox(width: 3,),
                if(!widget.skipValidation) Text("*",
                  style: TextStyle(
                    fontSize: 15, color: AppColors.textRedColor,
                  ),
                ),
                if(widget.toolTipContent != null) SizedBox(width: 3,),
                if(widget.toolTipContent != null) Tooltip(
                  message: widget.toolTipContent,
                  textAlign: TextAlign.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(Icons.info_outline, size: 20,
                    color: AppColors.primaryColor,),
                ),
              ],
            ),
            if(widget.isPassword) Row(
              children: [
                 GestureDetector(
                  onTap: _toggleVisibility,
                  child:
                  widget.isPassword && _obscureText
                      ? Icon(Icons.visibility_outlined, size: 24,)
                      : Icon(Icons.visibility_off_outlined, size: 24,),
                ),
                  SizedBox(width: 5,),
                  GestureDetector(
                    onTap: _toggleVisibility,
                    child:
                    widget.isPassword && _obscureText
                        ? Text(
                      context.watchLang.translate(AppLanguageText.show),
                      style: AppFonts.textRegular18,)
                        : Text(
                      context.watchLang.translate(AppLanguageText.hide),
                      style: AppFonts.textRegular18,),
                  )
              ],
            )
          ],
        ),
        SizedBox(height: 5,),
        TextFormField(
          controller: widget.controller,
          textInputAction: widget.textInputAction,
          obscureText: widget.isPassword && _obscureText,
          obscuringCharacter: "*",
          readOnly: !widget.isEditable,
          // Disable editing directly in the text field
          enableInteractiveSelection:
          widget.keyboardType == TextInputType.datetime ? false : null,
          enableSuggestions: false,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          onTap: () {
            if (widget.keyboardType == TextInputType.datetime) {
              _selectDate(context); // Only call the date picker function
            }
          },
          maxLines: widget.isMaxLines ?? false ? 4 : 1,
          style: widget.isDisable ? AppFonts.textRegular17Disable : widget
              .isSmallFieldFont ? AppFonts.textRegular14 : AppFonts
              .textRegular17,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            fillColor: widget.backgroundColor ?? AppColors.whiteColor,
            filled: true,
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color:  widget.borderColor ?? AppColors.fieldBorderColor,
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.isDisable ? AppColors.greyColor :widget.borderColor ?? AppColors.fieldBorderColor,
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.isDisable ? AppColors.greyColor : widget
                    .borderColor ?? AppColors.fieldBorderColor,
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.isDisable ? AppColors.greyColor :widget.borderColor ?? AppColors.fieldBorderColor,
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.isDisable ? AppColors.greyColor : widget
                    .borderColor ?? AppColors.fieldBorderColor,
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            hintStyle: widget.hintStyle ?? AppFonts.textRegularGrey16,
            labelStyle: widget.isDisable ? AppFonts.textRegularGrey16 :  AppFonts.textRegular17,
            errorStyle: TextStyle(color: AppColors.underscoreColor),
          ),
          validator: widget.skipValidation
              ? null
              : widget.validator ?? CommonValidation().commonValidator,
        ),
      ],
    );
  }
}
