import 'package:flutter/material.dart';

class ExpenseTrendData {
  final DateTime date;
  final double amount;
  final String label;

  ExpenseTrendData({
    required this.date,
    required this.amount,
    required this.label,
  });
}

class CategoryData {
  final String category;
  final double amount;
  final double percentage;
  final Color color;

  CategoryData({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

class AnalyticsSummary {
  final double totalExpenses;
  final double averageDaily;
  final String topCategory;
  final double monthlyBalance;

  AnalyticsSummary({
    required this.totalExpenses,
    required this.averageDaily,
    required this.topCategory,
    required this.monthlyBalance,
  });
}