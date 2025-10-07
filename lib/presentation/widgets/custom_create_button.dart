import 'package:check_in/core/constants/app_colors.dart';
import 'package:check_in/core/constants/text_styles.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Icon? icon;
  final String text;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  const CustomIconButton({
    super.key,
    this.onTap,
    this.icon,
    required this.text,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 220,
        height: height ?? 40,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ??
                const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                ),
            const SizedBox(
              width: 8,
            ),
            Text(
              text,
              style: TextFontStyle.smallMedium,
            ),
          ],
        ),
      ),
    );
  }
}
