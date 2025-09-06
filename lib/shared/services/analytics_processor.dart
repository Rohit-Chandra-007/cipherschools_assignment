import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/chart_data_models.dart';
import '../extensions/transaction_analytics.dart';
import '../../core/theme/app_colors.dart';

/// Service class for processing transaction data into analytics-ready formats
class AnalyticsProcessor {
  /// Processes transactions into expense trend data for line charts
  static List<ExpenseTrendData> processExpenseTrend(
    List<Transaction> transactions,
    TimeFilter filter, {
    DateTime? referenceDate,
  }) {
    final reference = referenceDate ?? DateTime.now();
    final filteredTransactions = transactions
        .where((t) => t.isExpense && t.isInPeriod(filter, reference))
        .toList();

    // Group transactions by date periods based on filter
    final Map<DateTime, double> groupedData = {};

    for (final transaction in filteredTransactions) {
      final periodKey = _getPeriodKey(transaction.dateTime, filter);
      groupedData[periodKey] = (groupedData[periodKey] ?? 0) + transaction.absoluteAmount;
    }

    // Convert to ExpenseTrendData list and sort by date
    final trendData = groupedData.entries
        .map((entry) => ExpenseTrendData(
              date: entry.key,
              amount: entry.value,
              label: _formatPeriodLabel(entry.key, filter),
            ))
        .toList();

    trendData.sort((a, b) => a.date.compareTo(b.date));

    // Fill in missing periods with zero values for better visualization
    return _fillMissingPeriods(trendData, filter, reference);
  }

  /// Processes transactions into category breakdown data for pie charts
  static List<CategoryData> processCategoryBreakdown(
    List<Transaction> transactions, {
    DateTime? referenceDate,
    TimeFilter? filter,
    double othersThreshold = 5.0, // Minimum percentage to show as separate category
  }) {
    final reference = referenceDate ?? DateTime.now();
    
    // Filter transactions based on time period if specified
    List<Transaction> filteredTransactions = transactions.where((t) => t.isExpense).toList();
    
    if (filter != null) {
      filteredTransactions = filteredTransactions
          .where((t) => t.isInPeriod(filter, reference))
          .toList();
    }

    if (filteredTransactions.isEmpty) {
      return [];
    }

    // Group by category and calculate totals
    final Map<String, double> categoryTotals = {};
    for (final transaction in filteredTransactions) {
      final categoryKey = transaction.categoryKey;
      categoryTotals[categoryKey] = (categoryTotals[categoryKey] ?? 0) + transaction.absoluteAmount;
    }

    final totalAmount = categoryTotals.values.fold(0.0, (sum, amount) => sum + amount);
    
    if (totalAmount == 0) {
      return [];
    }

    // Convert to CategoryData with colors and percentages
    final categoryColors = _getCategoryColors();
    final categoryDataList = <CategoryData>[];
    final smallCategories = <MapEntry<String, double>>[];
    
    int colorIndex = 0;
    
    // Sort categories by amount descending first
    final sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    for (final entry in sortedEntries) {
      final percentage = (entry.value / totalAmount) * 100;
      
      // Group small categories (less than threshold%) into "Others"
      if (percentage >= othersThreshold) {
        categoryDataList.add(CategoryData(
          category: _formatCategoryName(entry.key),
          amount: entry.value,
          percentage: percentage,
          color: categoryColors[colorIndex % categoryColors.length],
        ));
        colorIndex++;
      } else {
        smallCategories.add(entry);
      }
    }

    // Add "Others" category if there are small categories
    if (smallCategories.isNotEmpty) {
      final othersAmount = smallCategories.fold(0.0, (sum, entry) => sum + entry.value);
      final othersPercentage = (othersAmount / totalAmount) * 100;
      
      categoryDataList.add(CategoryData(
        category: 'Others',
        amount: othersAmount,
        percentage: othersPercentage,
        color: AppColors.dark25,
      ));
    }

    // Ensure we don't exceed maximum recommended pie chart sections (6-8 max)
    if (categoryDataList.length > 8) {
      // Combine smallest categories into "Others"
      final mainCategories = categoryDataList.take(7).toList();
      final combinedOthers = categoryDataList.skip(7).toList();
      
      final othersAmount = combinedOthers.fold(0.0, (sum, cat) => sum + cat.amount);
      final othersPercentage = (othersAmount / totalAmount) * 100;
      
      mainCategories.add(CategoryData(
        category: 'Others',
        amount: othersAmount,
        percentage: othersPercentage,
        color: AppColors.dark25,
      ));
      
      return mainCategories;
    }
    
    return categoryDataList;
  }

  /// Calculates summary statistics from transactions
  static AnalyticsSummary calculateSummary(
    List<Transaction> transactions,
    double monthlySalary, {
    DateTime? referenceDate,
  }) {
    final reference = referenceDate ?? DateTime.now();
    
    // Filter transactions for current month
    final monthlyTransactions = transactions
        .where((t) => t.isInPeriod(TimeFilter.monthly, reference))
        .toList();

    final expenses = monthlyTransactions.where((t) => t.isExpense).toList();
    final income = monthlyTransactions.where((t) => t.isIncome).toList();

    final totalExpenses = expenses.fold(0.0, (sum, t) => sum + t.absoluteAmount);
    final totalIncome = income.fold(0.0, (sum, t) => sum + t.absoluteAmount) + monthlySalary;

    // Calculate average daily spending for the month
    final daysInMonth = DateTime(reference.year, reference.month + 1, 0).day;
    final averageDaily = totalExpenses / daysInMonth;

    // Find top spending category
    String topCategory = 'None';
    if (expenses.isNotEmpty) {
      final categoryTotals = <String, double>{};
      for (final expense in expenses) {
        final categoryKey = expense.categoryKey;
        categoryTotals[categoryKey] = (categoryTotals[categoryKey] ?? 0) + expense.absoluteAmount;
      }
      
      if (categoryTotals.isNotEmpty) {
        final topEntry = categoryTotals.entries.reduce((a, b) => a.value > b.value ? a : b);
        topCategory = _formatCategoryName(topEntry.key);
      }
    }

    final monthlyBalance = totalIncome - totalExpenses;

    return AnalyticsSummary(
      totalExpenses: totalExpenses,
      averageDaily: averageDaily,
      topCategory: topCategory,
      monthlyBalance: monthlyBalance,
      totalIncome: totalIncome,
      transactionCount: monthlyTransactions.length,
    );
  }

  /// Gets the period key for grouping transactions based on filter
  static DateTime _getPeriodKey(DateTime date, TimeFilter filter) {
    switch (filter) {
      case TimeFilter.daily:
        return DateTime(date.year, date.month, date.day);
      case TimeFilter.weekly:
        final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
        return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
      case TimeFilter.monthly:
        return DateTime(date.year, date.month);
      case TimeFilter.yearly:
        return DateTime(date.year);
    }
  }

  /// Formats period labels for display
  static String _formatPeriodLabel(DateTime date, TimeFilter filter) {
    switch (filter) {
      case TimeFilter.daily:
        return '${date.day}/${date.month}';
      case TimeFilter.weekly:
        final endOfWeek = date.add(const Duration(days: 6));
        return '${date.day}/${date.month} - ${endOfWeek.day}/${endOfWeek.month}';
      case TimeFilter.monthly:
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        return months[date.month - 1];
      case TimeFilter.yearly:
        return date.year.toString();
    }
  }

  /// Fills missing periods with zero values for better chart visualization
  static List<ExpenseTrendData> _fillMissingPeriods(
    List<ExpenseTrendData> data,
    TimeFilter filter,
    DateTime reference,
  ) {
    if (data.isEmpty) {
      return _generateEmptyPeriods(filter, reference);
    }

    final filledData = <ExpenseTrendData>[];
    final existingDates = data.map((d) => d.date).toSet();

    // Generate expected periods based on filter
    final expectedPeriods = _generateExpectedPeriods(filter, reference);

    for (final period in expectedPeriods) {
      if (existingDates.contains(period)) {
        filledData.add(data.firstWhere((d) => d.date == period));
      } else {
        filledData.add(ExpenseTrendData(
          date: period,
          amount: 0.0,
          label: _formatPeriodLabel(period, filter),
        ));
      }
    }

    return filledData;
  }

  /// Generates expected periods for the given filter and reference date
  static List<DateTime> _generateExpectedPeriods(TimeFilter filter, DateTime reference) {
    final periods = <DateTime>[];

    switch (filter) {
      case TimeFilter.daily:
        // Last 7 days
        for (int i = 6; i >= 0; i--) {
          final date = reference.subtract(Duration(days: i));
          periods.add(DateTime(date.year, date.month, date.day));
        }
        break;
      case TimeFilter.weekly:
        // Last 4 weeks
        for (int i = 3; i >= 0; i--) {
          final date = reference.subtract(Duration(days: i * 7));
          final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
          periods.add(DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day));
        }
        break;
      case TimeFilter.monthly:
        // Last 6 months
        for (int i = 5; i >= 0; i--) {
          final date = DateTime(reference.year, reference.month - i);
          periods.add(date);
        }
        break;
      case TimeFilter.yearly:
        // Last 3 years
        for (int i = 2; i >= 0; i--) {
          periods.add(DateTime(reference.year - i));
        }
        break;
    }

    return periods;
  }

  /// Generates empty periods when no data exists
  static List<ExpenseTrendData> _generateEmptyPeriods(TimeFilter filter, DateTime reference) {
    final periods = _generateExpectedPeriods(filter, reference);
    return periods.map((period) => ExpenseTrendData(
      date: period,
      amount: 0.0,
      label: _formatPeriodLabel(period, filter),
    )).toList();
  }

  /// Gets predefined colors for categories
  static List<Color> _getCategoryColors() {
    return [
      AppColors.violet100,
      AppColors.red100,
      AppColors.green100,
      AppColors.yellow100,
      AppColors.blue100,
      AppColors.violet80,
      AppColors.red80,
      AppColors.green80,
      AppColors.yellow80,
      AppColors.blue80,
    ];
  }

  /// Formats category names for display
  static String _formatCategoryName(String categoryKey) {
    return categoryKey.split(' ')
        .map((word) => word.isNotEmpty 
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : word)
        .join(' ');
  }
}