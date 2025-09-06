import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String labelText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;
  final String? errorText;

  const CustomDropdown({
    super.key,
    required this.labelText,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.enabled = true,
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
      child: DropdownButtonFormField<T>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          errorText: errorText,
          labelStyle: TextStyle(
            color: errorText != null 
                ? AppColors.red100 
                : AppColors.dark75,
          ),
          errorStyle: TextStyle(
            color: AppColors.red100,
            fontSize: 12,
          ),
        ),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: enabled ? AppColors.dark75 : AppColors.dark25,
        ),
        items: items,
        onChanged: enabled ? onChanged : null,
        validator: validator,
        style: Theme.of(context).textTheme.bodyMedium,
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}