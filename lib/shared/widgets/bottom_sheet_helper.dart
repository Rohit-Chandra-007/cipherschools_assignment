import 'package:flutter/material.dart';
import 'add_transaction_bottom_sheet.dart';

class BottomSheetHelper {
  static Future<void> showAddTransactionBottomSheet({
    required BuildContext context,
    required VoidCallback onIncomePressed,
    required VoidCallback onExpensePressed,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: AddTransactionBottomSheet(
            onIncomePressed: () {
              Navigator.pop(context);
              onIncomePressed();
            },
            onExpensePressed: () {
              Navigator.pop(context);
              onExpensePressed();
            },
          ),
        );
      },
    );
  }
}