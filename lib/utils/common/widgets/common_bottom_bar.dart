import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/res/app_colors.dart';

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
    LucideIcons.search,
    LucideIcons.creditCard,
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
            ),
          ],
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
                      width: 30,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.buttonBgColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Container(
                          height: 30,
                          width: 50,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.buttonBgColor.withOpacity(0.2) : null,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _icons[index],
                            size: isSelected ? 20 : 25,
                            color: isSelected
                                ? AppColors.buttonBgColor
                                : AppColors.buttonBgColor,
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
      ),
    );
  }
}
