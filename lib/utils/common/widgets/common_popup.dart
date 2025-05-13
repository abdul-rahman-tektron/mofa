import 'package:flutter/material.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/screens/login/login_screen.dart';

registerSuccessPopup(BuildContext context, String heading, String subHeading) {
  return showDialog(
    context: context,
    barrierColor: AppColors.primaryColor.withOpacity(0.4),
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);

                        // Then navigate to the login screen
                        Future.delayed(Duration.zero, () {
                          Navigator.pop(context);
                        });
                      },
                      child: const Icon(Icons.close)
                  )
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_box, color: Colors.green, size: 30,),
                  SizedBox(width: 10),
                  Text(heading, style: AppFonts.textBold24),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                subHeading,
                style: AppFonts.textMedium18,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      );
    },
  );
}
