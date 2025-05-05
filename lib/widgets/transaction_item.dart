import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: transaction.iconBackgroundColor.withAlpha(38),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(transaction.icon, color: transaction.iconBackgroundColor, size: 24),
      ),
      title: Text(
        transaction.title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        transaction.subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '- ₹${transaction.amount.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          Text(transaction.time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }
}
