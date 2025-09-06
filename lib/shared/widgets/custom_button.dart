import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum ButtonType { primary, secondary, outline }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? icon;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.width,
    this.height = 56,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      if (backgroundColor != null) return backgroundColor!;
      switch (type) {
        case ButtonType.primary:
          return AppColors.violet100;
        case ButtonType.secondary:
          return AppColors.violet20;
        case ButtonType.outline:
          return Colors.transparent;
      }
    }

    Color getTextColor() {
      if (textColor != null) return textColor!;
      switch (type) {
        case ButtonType.primary:
          return Colors.white;
        case ButtonType.secondary:
          return AppColors.violet100;
        case ButtonType.outline:
          return AppColors.violet100;
      }
    }

    BorderSide? getBorder() {
      if (type == ButtonType.outline) {
        return BorderSide(color: AppColors.violet100, width: 1);
      }
      return null;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: getBackgroundColor(),
          foregroundColor: getTextColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: getBorder() ?? BorderSide.none,
          ),
          elevation: type == ButtonType.outline ? 0 : 2,
          shadowColor: AppColors.violet100.withValues(alpha: 0.3),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(getTextColor()),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: getTextColor(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}