import 'package:flutter/material.dart';

/// Data model for expense trend visualization in line charts
class ExpenseTrendData {
  final DateTime date;
  final double amount;
  final String label;

  const ExpenseTrendData({
    required this.date,
    required this.amount,
    required this.label,
  });

  @override
  String toString() => 'ExpenseTrendData(date: $date, amount: $amount, label: $label)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseTrendData &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          amount == other.amount &&
          label == other.label;

  @override
  int get hashCode => date.hashCode ^ amount.hashCode ^ label.hashCode;
}

/// Data model for category breakdown in pie charts
class CategoryData {
  final String category;
  final double amount;
  final double percentage;
  final Color color;

  const CategoryData({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  @override
  String toString() => 
      'CategoryData(category: $category, amount: $amount, percentage: $percentage, color: $color)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryData &&
          runtimeType == other.runtimeType &&
          category == other.category &&
          amount == other.amount &&
          percentage == other.percentage &&
          color == other.color;

  @override
  int get hashCode =>
      category.hashCode ^ amount.hashCode ^ percentage.hashCode ^ color.hashCode;
}

/// Summary statistics for analytics dashboard
class AnalyticsSummary {
  final double totalExpenses;
  final double averageDaily;
  final String topCategory;
  final double monthlyBalance;
  final double totalIncome;
  final int transactionCount;

  const AnalyticsSummary({
    required this.totalExpenses,
    required this.averageDaily,
    required this.topCategory,
    required this.monthlyBalance,
    required this.totalIncome,
    required this.transactionCount,
  });

  /// Returns true if expenses exceed income
  bool get hasDeficit => monthlyBalance < 0;

  /// Returns true if there's a surplus
  bool get hasSurplus => monthlyBalance > 0;

  /// Returns formatted percentage of expenses vs income
  double get expenseRatio => totalIncome > 0 ? (totalExpenses / totalIncome) * 100 : 0;

  @override
  String toString() => 
      'AnalyticsSummary(totalExpenses: $totalExpenses, averageDaily: $averageDaily, '
      'topCategory: $topCategory, monthlyBalance: $monthlyBalance, totalIncome: $totalIncome, '
      'transactionCount: $transactionCount)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsSummary &&
          runtimeType == other.runtimeType &&
          totalExpenses == other.totalExpenses &&
          averageDaily == other.averageDaily &&
          topCategory == other.topCategory &&
          monthlyBalance == other.monthlyBalance &&
          totalIncome == other.totalIncome &&
          transactionCount == other.transactionCount;

  @override
  int get hashCode =>
      totalExpenses.hashCode ^
      averageDaily.hashCode ^
      topCategory.hashCode ^
      monthlyBalance.hashCode ^
      totalIncome.hashCode ^
      transactionCount.hashCode;
}