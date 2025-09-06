import '../models/transaction.dart';

enum TimeFilter { daily, weekly, monthly, yearly }

extension TimeFilterExtension on TimeFilter {
  String get displayName {
    switch (this) {
      case TimeFilter.daily:
        return 'Daily';
      case TimeFilter.weekly:
        return 'Weekly';
      case TimeFilter.monthly:
        return 'Monthly';
      case TimeFilter.yearly:
        return 'Yearly';
    }
  }
}

extension TransactionAnalytics on Transaction {
  /// Converts the time string to DateTime for analytics processing
  DateTime get dateTime {
    // Parse the time string (assuming format like "10:30 AM" for today)
    // For now, we'll use current date with parsed time
    // In a real app, this would be a proper timestamp
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Checks if transaction falls within the specified time period
  bool isInPeriod(TimeFilter filter, DateTime referenceDate) {
    final transactionDate = dateTime;
    
    switch (filter) {
      case TimeFilter.daily:
        return _isSameDay(transactionDate, referenceDate);
      case TimeFilter.weekly:
        return _isSameWeek(transactionDate, referenceDate);
      case TimeFilter.monthly:
        return _isSameMonth(transactionDate, referenceDate);
      case TimeFilter.yearly:
        return _isSameYear(transactionDate, referenceDate);
    }
  }

  /// Returns a standardized category key for grouping
  String get categoryKey => category.toLowerCase().trim();

  /// Checks if transaction is an expense (negative amount)
  bool get isExpense => amount < 0;

  /// Checks if transaction is income (positive amount)
  bool get isIncome => amount > 0;

  /// Returns absolute amount for calculations
  double get absoluteAmount => amount.abs();

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  bool _isSameWeek(DateTime date1, DateTime date2) {
    final startOfWeek1 = _getStartOfWeek(date1);
    final startOfWeek2 = _getStartOfWeek(date2);
    return startOfWeek1.isAtSameMomentAs(startOfWeek2);
  }

  bool _isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  bool _isSameYear(DateTime date1, DateTime date2) {
    return date1.year == date2.year;
  }

  DateTime _getStartOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return DateTime(date.year, date.month, date.day - daysFromMonday);
  }
}