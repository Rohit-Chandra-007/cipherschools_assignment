import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:cipherschools_assignment/shared/models/transaction.dart';
import 'package:cipherschools_assignment/shared/services/analytics_processor.dart';
import 'package:cipherschools_assignment/shared/extensions/transaction_analytics.dart';

void main() {
  group('AnalyticsProcessor Tests', () {
    late List<Transaction> testTransactions;

    setUp(() {
      testTransactions = [
        Transaction(
          title: 'Groceries',
          subtitle: 'Weekly shopping',
          amount: -120.0, // Expense
          time: '10:00 AM',
          icon: Icons.shopping_bag,
          iconBackgroundColor: Colors.amber,
          category: 'Food',
        ),
        Transaction(
          title: 'Salary',
          subtitle: 'Monthly salary',
          amount: 5000.0, // Income
          time: '09:00 AM',
          icon: Icons.money,
          iconBackgroundColor: Colors.green,
          category: 'Income',
        ),
        Transaction(
          title: 'Gas',
          subtitle: 'Fuel for car',
          amount: -50.0, // Expense
          time: '02:00 PM',
          icon: Icons.local_gas_station,
          iconBackgroundColor: Colors.red,
          category: 'Transportation',
        ),
        Transaction(
          title: 'Coffee',
          subtitle: 'Morning coffee',
          amount: -5.0, // Expense
          time: '08:00 AM',
          icon: Icons.coffee,
          iconBackgroundColor: Colors.brown,
          category: 'Food',
        ),
      ];
    });

    test('processExpenseTrend should return correct trend data', () {
      final trendData = AnalyticsProcessor.processExpenseTrend(
        testTransactions,
        TimeFilter.daily,
      );

      expect(trendData, isNotEmpty);
      // Should have data for today with total expenses
      final todayExpenses = trendData.where((data) {
        final today = DateTime.now();
        return data.date.year == today.year &&
               data.date.month == today.month &&
               data.date.day == today.day;
      }).toList();

      if (todayExpenses.isNotEmpty) {
        expect(todayExpenses.first.amount, equals(175.0)); // 120 + 50 + 5
      }
    });

    test('processCategoryBreakdown should group expenses by category', () {
      final categoryData = AnalyticsProcessor.processCategoryBreakdown(
        testTransactions,
      );

      expect(categoryData, isNotEmpty);
      
      // Should have Food and Transportation categories
      final foodCategory = categoryData.where((cat) => cat.category == 'Food').toList();
      final transportCategory = categoryData.where((cat) => cat.category == 'Transportation').toList();

      expect(foodCategory, isNotEmpty);
      expect(transportCategory, isNotEmpty);

      if (foodCategory.isNotEmpty) {
        expect(foodCategory.first.amount, equals(125.0)); // 120 + 5
      }
      
      if (transportCategory.isNotEmpty) {
        expect(transportCategory.first.amount, equals(50.0));
      }
    });

    test('calculateSummary should return correct statistics', () {
      const monthlySalary = 3000.0;
      final summary = AnalyticsProcessor.calculateSummary(
        testTransactions,
        monthlySalary,
      );

      expect(summary.totalExpenses, equals(175.0)); // 120 + 50 + 5
      expect(summary.totalIncome, equals(8000.0)); // 5000 + 3000
      expect(summary.monthlyBalance, equals(7825.0)); // 8000 - 175
      expect(summary.topCategory, equals('Food')); // Highest expense category
      expect(summary.transactionCount, equals(4));
      expect(summary.hasSurplus, isTrue);
      expect(summary.hasDeficit, isFalse);
    });

    test('calculateSummary should handle deficit scenario', () {
      // Create transactions with high expenses and low income
      final deficitTransactions = [
        Transaction(
          title: 'Expensive Purchase',
          subtitle: 'Big expense',
          amount: -3000.0, // Large expense
          time: '10:00 AM',
          icon: Icons.shopping_bag,
          iconBackgroundColor: Colors.red,
          category: 'Shopping',
        ),
        Transaction(
          title: 'Rent',
          subtitle: 'Monthly rent',
          amount: -2000.0, // Another large expense
          time: '09:00 AM',
          icon: Icons.home,
          iconBackgroundColor: Colors.blue,
          category: 'Housing',
        ),
      ];

      const monthlySalary = 1000.0; // Low salary
      final summary = AnalyticsProcessor.calculateSummary(
        deficitTransactions,
        monthlySalary,
      );

      expect(summary.monthlyBalance, lessThan(0)); // Should be negative (1000 - 5000 = -4000)
      expect(summary.hasDeficit, isTrue);
      expect(summary.hasSurplus, isFalse);
    });

    test('processCategoryBreakdown should handle empty transactions', () {
      final categoryData = AnalyticsProcessor.processCategoryBreakdown([]);
      expect(categoryData, isEmpty);
    });

    test('processExpenseTrend should handle empty transactions', () {
      final trendData = AnalyticsProcessor.processExpenseTrend(
        [],
        TimeFilter.daily,
      );
      
      expect(trendData, isNotEmpty); // Should return empty periods with zero values
      expect(trendData.every((data) => data.amount == 0.0), isTrue);
    });

    test('calculateSummary should handle no expenses', () {
      final incomeOnlyTransactions = [
        Transaction(
          title: 'Salary',
          subtitle: 'Monthly salary',
          amount: 5000.0,
          time: '09:00 AM',
          icon: Icons.money,
          iconBackgroundColor: Colors.green,
          category: 'Income',
        ),
      ];

      const monthlySalary = 3000.0;
      final summary = AnalyticsProcessor.calculateSummary(
        incomeOnlyTransactions,
        monthlySalary,
      );

      expect(summary.totalExpenses, equals(0.0));
      expect(summary.topCategory, equals('None'));
      expect(summary.monthlyBalance, equals(8000.0)); // 5000 + 3000
    });
  });
}