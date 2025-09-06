import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AmountInput extends StatelessWidget {
  final TextEditingController controller;
  final String currency;
  final Color textColor;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const AmountInput({
    super.key,
    required this.controller,
    this.currency = '₹',
    this.textColor = Colors.white,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currency,
          style: TextStyle(
            color: textColor,
            fontSize: 64,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            style: TextStyle(
              color: textColor,
              fontSize: 64,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '0',
              hintStyle: TextStyle(
                color: textColor.withValues(alpha: 0.5),
                fontSize: 64,
                fontWeight: FontWeight.w600,
              ),
              contentPadding: EdgeInsets.zero,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            validator: validator,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}