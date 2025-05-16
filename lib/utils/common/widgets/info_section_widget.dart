import 'package:flutter/material.dart';
import 'package:mofa/res/app_fonts.dart';

class DeclarationSection {
  final String heading;
  final List<String> items;

  DeclarationSection({required this.heading, required this.items});
}

class HealthDeclarationList extends StatelessWidget {
  final List<DeclarationSection> sections;
  final bool isRtl;

  const HealthDeclarationList({
    super.key,
    required this.sections,
    this.isRtl = false,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sections.map((section) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.heading,
                  style: AppFonts.textBold16,
                ),
                const SizedBox(height: 8),
                ...List.generate(section.items.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '${index + 1}. ${section.items[index]}',
                      style: AppFonts.textRegular14,
                    ),
                  );
                }),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
