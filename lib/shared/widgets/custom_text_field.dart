import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final int? maxLines;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: errorText != null ? 80 : 56,
      decoration: BoxDecoration(
        border: Border.all(
          color: errorText != null 
              ? AppColors.red100 
              : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
        enabled: enabled,
        maxLines: maxLines,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          errorText: errorText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          labelStyle: TextStyle(
            color: errorText != null 
                ? AppColors.red100 
                : AppColors.dark75,
          ),
          hintStyle: TextStyle(
            color: AppColors.dark25,
          ),
          errorStyle: TextStyle(
            color: AppColors.red100,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}