import 'package:cipherschools_assignment/shared/models/transaction.dart';
import 'package:cipherschools_assignment/features/budget/data/models/time_filter.dart';

extension TransactionAnalytics on Transaction {
  /// Convert time string to DateTime for analytics
  /// Note: This is a simplified implementation since the current Transaction model
  /// only has a time string. In a real app, this would be a proper DateTime field.
  DateTime get dateTime {
    // For now, we'll use today's date with the time from the transaction
    final now = DateTime.now();
    // Parse time string (e.g., "10:00 AM")
    try {
      final timeParts = time.split(' ');
      final hourMinute = timeParts[0].split(':');
      int hour = int.parse(hourMinute[0]);
      final minute = int.parse(hourMinute[1]);
      
      if (timeParts.length > 1 && timeParts[1].toUpperCase() == 'PM' && hour != 12) {
        hour += 12;
      } else if (timeParts.length > 1 && timeParts[1].toUpperCase() == 'AM' && hour == 12) {
        hour = 0;
      }
      
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (e) {
      // Fallback to current time if parsing fails
      return now;
    }
  }

  /// Check if transaction falls within a specific time period
  bool isInPeriod(TimeFilter filter, DateTime referenceDate) {
    final transactionDate = dateTime;
    
    switch (filter) {
      case TimeFilter.daily:
        return transactionDate.year == referenceDate.year &&
               transactionDate.month == referenceDate.month &&
               transactionDate.day == referenceDate.day;
      
      case TimeFilter.weekly:
        final startOfWeek = referenceDate.subtract(Duration(days: referenceDate.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return transactionDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
               transactionDate.isBefore(endOfWeek.add(const Duration(days: 1)));
      
      case TimeFilter.monthly:
        return transactionDate.year == referenceDate.year &&
               transactionDate.month == referenceDate.month;
      
      case TimeFilter.yearly:
        return transactionDate.year == referenceDate.year;
    }
  }

  /// Get category key for grouping
  String get categoryKey => category.toLowerCase();

  /// Check if transaction is an expense
  bool get isExpense => category.toLowerCase() == 'expense';

  /// Check if transaction is income
  bool get isIncome => category.toLowerCase() == 'income';
}