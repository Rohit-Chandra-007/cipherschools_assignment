import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat('#,##0', 'en_IN');
  
  /// Format amount with Indian Rupee symbol
  static String format(double amount) {
    if (amount == 0) return '₹0';
    return '₹${_formatter.format(amount.abs())}';
  }
  
  /// Format amount with sign indicator for positive/negative values
  static String formatWithSign(double amount) {
    if (amount == 0) return '₹0';
    final formattedAmount = _formatter.format(amount.abs());
    return amount >= 0 ? '+₹$formattedAmount' : '-₹$formattedAmount';
  }
  
  /// Format percentage with appropriate sign
  static String formatPercentage(double percentage) {
    if (percentage == 0) return '0%';
    final sign = percentage >= 0 ? '+' : '';
    return '$sign${percentage.toStringAsFixed(1)}%';
  }
}