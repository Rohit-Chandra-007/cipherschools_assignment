enum TimeFilter {
  daily,
  weekly,
  monthly,
  yearly;

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