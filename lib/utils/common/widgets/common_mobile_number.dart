import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';

import '../../common_validation.dart';

class MobileNumberField extends StatelessWidget {
  final TextEditingController mobileController;
  final String countryCode;
  final String fieldName;
  final String? toolTipContent;
  final bool isEditable;
  final bool isEnable;
  final bool isSmallFieldFont;
  final bool skipValidation;
  final bool showAsterisk;

  const MobileNumberField({
    super.key,
    required this.mobileController,
    this.countryCode = "+966",
    required this.fieldName,
    this.toolTipContent,
    this.isEditable = true,
    this.isEnable = true,
    this.isSmallFieldFont = false,
    this.skipValidation = false,
    this.showAsterisk = true,
  });

  OutlineInputBorder _buildBorder(Color color) =>
      OutlineInputBorder(borderSide: BorderSide(color: color, width: 2.5), borderRadius: BorderRadius.circular(15.0));

  @override
  Widget build(BuildContext context) {
    final textColor =
        !isEnable
            ? (isSmallFieldFont ? AppFonts.textRegularGrey14 : AppFonts.textRegularGrey17)
            : (isSmallFieldFont ? AppFonts.textRegular14 : AppFonts.textRegular17);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(fieldName, style: (isSmallFieldFont ? AppFonts.textRegular14 : AppFonts.textRegular17),),
            if (!skipValidation && showAsterisk) 3.horizontalSpace,
            if (!skipValidation && showAsterisk)
              const Text("*", style: TextStyle(fontSize: 15, color: AppColors.textRedColor)),
            if (toolTipContent != null) ...[
              const SizedBox(width: 3),
              Tooltip(
                message: toolTipContent!,
                decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(5)),
                child: const Icon(Icons.info_outline, size: 20, color: AppColors.primaryColor),
              ),
            ],
          ],
        ),
        const SizedBox(height: 5),
        FormField<String>(
          initialValue: mobileController.text,
          validator: skipValidation ? null : (value) => CommonValidation().validateMobile(context, value),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (formFieldState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Country Code
                    Container(
                      width: 75,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isEnable ? AppColors.whiteColor : AppColors.disabledFieldColor,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: AppColors.fieldBorderColor, width: 2.5),
                      ),
                      child: Center(child: Text(countryCode, style: textColor)),
                    ),
                    const SizedBox(width: 10),
                    // Mobile Field
                    Expanded(
                      child: TextFormField(
                        controller: mobileController,
                        enabled: isEnable,
                        readOnly: !isEditable,
                        keyboardType: TextInputType.phone,
                        style: textColor,
                        onChanged: (value) => formFieldState.didChange(value),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isEnable ? AppColors.whiteColor : AppColors.disabledFieldColor,
                          hintStyle: AppFonts.textRegularGrey16,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                          errorStyle: const TextStyle(height: 0),
                          // hide default error space
                          border: _buildBorder(AppColors.fieldBorderColor),
                          enabledBorder: _buildBorder(AppColors.fieldBorderColor),
                          focusedBorder: _buildBorder(AppColors.fieldBorderColor),
                          disabledBorder: _buildBorder(AppColors.fieldBorderColor),
                        ),
                      ),
                    ),
                  ],
                ),
                if (formFieldState.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 5),
                    child: Text(
                      formFieldState.errorText ?? '',
                      style: const TextStyle(color: AppColors.underscoreColor, fontSize: 14),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
