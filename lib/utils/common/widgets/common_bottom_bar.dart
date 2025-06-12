import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final List<IconData> _icons = [
    LucideIcons.layoutDashboard,
    LucideIcons.creditCard,
    LucideIcons.search,
  ];

  final List<String> _labels = [
    'Dashboard',
    'Apply Pass',
    'Search Pass',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_icons.length, (index) {
          final bool isSelected = index == currentIndex;
          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 3,
                    width: 40,
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.buttonBgColor
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: isSelected ?AppColors.buttonBgColor.withOpacity(0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _icons[index],
                              size: 20,
                              color: AppColors.buttonBgColor,
                            ),
                            5.verticalSpace,
                            Text(_labels[index], style: isSelected ? AppFonts.textRegular10 : AppFonts.textRegular10,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
