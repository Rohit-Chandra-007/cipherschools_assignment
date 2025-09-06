import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:cipherschools_assignment/shared/models/transaction.dart';
import 'package:cipherschools_assignment/shared/services/analytics_processor.dart';
import 'package:cipherschools_assignment/shared/extensions/transaction_analytics.dart';
import 'package:cipherschools_assignment/shared/models/chart_data_models.dart';

void main() {
  group('AnalyticsProcessor Comprehensive Tests', () {
    late List<Transaction> testTransactions;
    late List<Transaction> emptyTransactions;
    late List<Transaction> singleTransactionList;
    late List<Transaction> multiCategoryTransactions;

    setUp(() {
      // Standard test data
      testTransactions = [
        Transaction(
          title: 'Groceries',
          subtitle: 'Weekly shopping',
          amount: -120.0,
          time: '10:00 AM',
          icon: Icons.shopping_bag,
          iconBackgroundColor: Colors.amber,
          category: 'Food',
        ),
        Transaction(
          title: 'Salary',
          subtitle: 'Monthly salary',
          amount: 5000.0,
          time: '09:00 AM',
          icon: Icons.money,
          iconBackgroundColor: Colors.green,
          category: 'Income',
        ),
        Transaction(
          title: 'Gas',
          subtitle: 'Fuel for car',
          amount: -50.0,
          time: '02:00 PM',
          icon: Icons.local_gas_station,
          iconBackgroundColor: Colors.red,
          category: 'Transportation',
        ),
        Transaction(
          title: 'Coffee',
          subtitle: 'Morning coffee',
          amount: -5.0,
          time: '08:00 AM',
          icon: Icons.coffee,
          iconBackgroundColor: Colors.brown,
          category: 'Food',
        ),
      ];

      // Empty transactions for edge case testing
      emptyTransactions = [];

      // Single transaction for minimal data testing
      singleTransactionList = [
        Transaction(
          title: 'Single Expense',
          subtitle: 'Test expense',
          amount: -100.0,
          time: '12:00 PM',
          icon: Icons.shopping_cart,
          iconBackgroundColor: Colors.blue,
          category: 'Shopping',
        ),
      ];

      // Multi-category transactions for complex scenarios
      multiCategoryTransactions = [
        Transaction(
          title: 'Restaurant',
          subtitle: 'Dinner',
          amount: -80.0,
          time: '07:00 PM',
          icon: Icons.restaurant,
          iconBackgroundColor: Colors.orange,
          category: 'Food',
        ),
        Transaction(
          title: 'Movie',
          subtitle: 'Cinema ticket',
          amount: -15.0,
          time: '08:00 PM',
          icon: Icons.movie,
          iconBackgroundColor: Colors.purple,
          category: 'Entertainment',
        ),
        Transaction(
          title: 'Uber',
          subtitle: 'Ride home',
          amount: -25.0,
          time: '11:00 PM',
          icon: Icons.directions_car,
          iconBackgroundColor: Colors.black,
          category: 'Transportation',
        ),
        Transaction(
          title: 'Freelance',
          subtitle: 'Project payment',
          amount: 500.0,
          time: '10:00 AM',
          icon: Icons.work,
          iconBackgroundColor: Colors.green,
          category: 'Income',
        ),
        Transaction(
          title: 'Gym',
          subtitle: 'Monthly membership',
          amount: -50.0,
          time: '06:00 AM',
          icon: Icons.fitness_center,
          iconBackgroundColor: Colors.red,
          category: 'Health',
        ),
        Transaction(
          title: 'Books',
          subtitle: 'Study materials',
          amount: -30.0,
          time: '03:00 PM',
          icon: Icons.book,
          iconBackgroundColor: Colors.blue,
          category: 'Education',
        ),
        Transaction(
          title: 'Snacks',
          subtitle: 'Office snacks',
          amount: -10.0,
          time: '02:00 PM',
          icon: Icons.fastfood,
          iconBackgroundColor: Colors.yellow,
          category: 'Food',
        ),
      ];
    });

    group('processExpenseTrend Tests', () {
      test('should return correct trend data for daily filter', () {
        final trendData = AnalyticsProcessor.processExpenseTrend(
          testTransactions,
          TimeFilter.daily,
        );

        expect(trendData, isNotEmpty);
        expect(trendData.length, equals(7)); // Should return 7 days of data

        // Verify data structure
        for (final data in trendData) {
          expect(data.date, isA<DateTime>());
          expect(data.amount, isA<double>());
          expect(data.label, isA<String>());
          expect(data.amount, greaterThanOrEqualTo(0));
        }
      });

      test('should return correct trend data for weekly filter', () {
        final trendData = AnalyticsProcessor.processExpenseTrend(
          testTransactions,
          TimeFilter.weekly,
        );

        expect(trendData, isNotEmpty);
        expect(trendData.length, equals(4)); // Should return 4 weeks of data
      });

      test('should return correct trend data for monthly filter', () {
        final trendData = AnalyticsProcessor.processExpenseTrend(
          testTransactions,
          TimeFilter.monthly,
        );

        expect(trendData, isNotEmpty);
        expect(trendData.length, equals(6)); // Should return 6 months of data
      });

      test('should return correct trend data for yearly filter', () {
        final trendData = AnalyticsProcessor.processExpenseTrend(
          testTransactions,
          TimeFilter.yearly,
        );

        expect(trendData, isNotEmpty);
        expect(trendData.length, equals(3)); // Should return 3 years of data
      });

      test('should handle empty transactions gracefully', () {
        final trendData = AnalyticsProcessor.processExpenseTrend(
          emptyTransactions,
          TimeFilter.daily,
        );

        expect(trendData, isNotEmpty); // Should return empty periods
        expect(trendData.every((data) => data.amount == 0.0), isTrue);
      });

      test('should handle single transaction correctly', () {
        final trendData = AnalyticsProcessor.processExpenseTrend(
          singleTransactionList,
          TimeFilter.daily,
        );

        expect(trendData, isNotEmpty);
        
        // Find today's data
        final todayData = trendData.firstWhere(
          (data) {
            final today = DateTime.now();
            return data.date.year == today.year &&
                   data.date.month == today.month &&
                   data.date.day == today.day;
          },
          orElse: () => ExpenseTrendData(date: DateTime.now(), amount: 0, label: ''),
        );

        expect(todayData.amount, equals(100.0)); // Single expense of 100
      });

      test('should filter only expenses, not income', () {
        final trendData = AnalyticsProcessor.processExpenseTrend(
          testTransactions,
          TimeFilter.daily,
        );

        // Calculate expected total (only expenses: 120 + 50 + 5 = 175)
        final todayData = trendData.firstWhere(
          (data) {
            final today = DateTime.now();
            return data.date.year == today.year &&
                   data.date.month == today.month &&
                   data.date.day == today.day;
          },
          orElse: () => ExpenseTrendData(date: DateTime.now(), amount: 0, label: ''),
        );

        expect(todayData.amount, equals(175.0));
      });

      test('should handle custom reference date', () {
        final customDate = DateTime(2024, 1, 15);
        final trendData = AnalyticsProcessor.processExpenseTrend(
          testTransactions,
          TimeFilter.daily,
          referenceDate: customDate,
        );

        expect(trendData, isNotEmpty);
        // Should generate data around the custom reference date
        expect(trendData.any((data) => data.date.year == 2024), isTrue);
      });
    });

    group('processCategoryBreakdown Tests', () {
      test('should group expenses by category correctly', () {
        final categoryData = AnalyticsProcessor.processCategoryBreakdown(
          testTransactions,
        );

        expect(categoryData, isNotEmpty);
        
        // Find Food category (should have 2 transactions: 120 + 5 = 125)
        final foodCategory = categoryData.firstWhere(
          (cat) => cat.category == 'Food',
          orElse: () => CategoryData(category: '', amount: 0, percentage: 0, color: Colors.black),
        );
        
        expect(foodCategory.amount, equals(125.0));
        expect(foodCategory.percentage, closeTo(71.4, 0.1)); // 125/175 * 100

        // Find Transportation category
        final transportCategory = categoryData.firstWhere(
          (cat) => cat.category == 'Transportation',
          orElse: () => CategoryData(category: '', amount: 0, percentage: 0, color: Colors.black),
        );
        
        expect(transportCategory.amount, equals(50.0));
        expect(transportCategory.percentage, closeTo(28.6, 0.1)); // 50/175 * 100
      });

      test('should handle empty transactions', () {
        final categoryData = AnalyticsProcessor.processCategoryBreakdown(
          emptyTransactions,
        );

        expect(categoryData, isEmpty);
      });

      test('should group small categories into Others', () {
        final categoryData = AnalyticsProcessor.processCategoryBreakdown(
          multiCategoryTransactions,
          othersThreshold: 15.0, // Set threshold to 15%
        );

        expect(categoryData, isNotEmpty);
        
        // Should have "Others" category for small percentages
        final othersCategory = categoryData.where((cat) => cat.category == 'Others').toList();
        if (othersCategory.isNotEmpty) {
          expect(othersCategory.first.amount, greaterThan(0));
        }
      });

      test('should limit maximum categories to 8', () {
        // Create many categories
        final manyCategories = List.generate(15, (index) => Transaction(
          title: 'Item $index',
          subtitle: 'Category $index',
          amount: -100.0,
          time: '12:00 PM',
          icon: Icons.shopping_cart,
          iconBackgroundColor: Colors.blue,
          category: 'Category$index',
        ));

        final categoryData = AnalyticsProcessor.processCategoryBreakdown(
          manyCategories,
        );

        expect(categoryData.length, lessThanOrEqualTo(8));
      });

      test('should calculate percentages correctly', () {
        final categoryData = AnalyticsProcessor.processCategoryBreakdown(
          testTransactions,
        );

        // Sum of all percentages should be approximately 100%
        final totalPercentage = categoryData.fold(0.0, (sum, cat) => sum + cat.percentage);
        expect(totalPercentage, closeTo(100.0, 0.1));
      });

      test('should filter by time period when specified', () {
        final categoryData = AnalyticsProcessor.processCategoryBreakdown(
          testTransactions,
          filter: TimeFilter.daily,
          referenceDate: DateTime.now(),
        );

        expect(categoryData, isNotEmpty);
        // Should only include today's transactions
      });

      test('should assign different colors to categories', () {
        final categoryData = AnalyticsProcessor.processCategoryBreakdown(
          multiCategoryTransactions,
        );

        if (categoryData.length > 1) {
          // Verify that different categories have different colors (mostly)
          final colors = categoryData.map((cat) => cat.color).toSet();
          expect(colors.length, greaterThan(1));
        }
      });
    });

    group('calculateSummary Tests', () {
      test('should calculate correct summary statistics', () {
        const monthlySalary = 3000.0;
        final summary = AnalyticsProcessor.calculateSummary(
          testTransactions,
          monthlySalary,
        );

        expect(summary.totalExpenses, equals(175.0)); // 120 + 50 + 5
        expect(summary.totalIncome, equals(8000.0)); // 5000 + 3000
        expect(summary.monthlyBalance, equals(7825.0)); // 8000 - 175
        expect(summary.topCategory, equals('Food'));
        expect(summary.transactionCount, equals(4));
        expect(summary.hasSurplus, isTrue);
        expect(summary.hasDeficit, isFalse);
        expect(summary.expenseRatio, closeTo(2.19, 0.1)); // 175/8000 * 100
      });

      test('should handle deficit scenario correctly', () {
        final highExpenseTransactions = [
          Transaction(
            title: 'Expensive Item',
            subtitle: 'Big purchase',
            amount: -5000.0,
            time: '10:00 AM',
            icon: Icons.shopping_bag,
            iconBackgroundColor: Colors.red,
            category: 'Shopping',
          ),
        ];

        const lowSalary = 1000.0;
        final summary = AnalyticsProcessor.calculateSummary(
          highExpenseTransactions,
          lowSalary,
        );

        expect(summary.monthlyBalance, lessThan(0));
        expect(summary.hasDeficit, isTrue);
        expect(summary.hasSurplus, isFalse);
      });

      test('should handle zero salary', () {
        final summary = AnalyticsProcessor.calculateSummary(
          testTransactions,
          0.0,
        );

        expect(summary.totalIncome, equals(5000.0)); // Only transaction income
        expect(summary.monthlyBalance, equals(4825.0)); // 5000 - 175
      });

      test('should handle no expenses', () {
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
        expect(summary.averageDaily, equals(0.0));
      });

      test('should calculate average daily spending correctly', () {
        final summary = AnalyticsProcessor.calculateSummary(
          testTransactions,
          3000.0,
        );

        // Average daily = total expenses / days in month
        final now = DateTime.now();
        final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
        final expectedAverage = 175.0 / daysInMonth;

        expect(summary.averageDaily, closeTo(expectedAverage, 0.1));
      });

      test('should identify top spending category correctly', () {
        final summary = AnalyticsProcessor.calculateSummary(
          multiCategoryTransactions,
          3000.0,
        );

        // Food category should be top (80 + 10 = 90)
        expect(summary.topCategory, equals('Food'));
      });

      test('should handle custom reference date', () {
        final customDate = DateTime(2024, 6, 15); // June 2024
        final summary = AnalyticsProcessor.calculateSummary(
          testTransactions,
          3000.0,
          referenceDate: customDate,
        );

        expect(summary, isA<AnalyticsSummary>());
        // Should calculate based on June 2024 data
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle transactions with zero amounts', () {
        final zeroAmountTransactions = [
          Transaction(
            title: 'Zero Transaction',
            subtitle: 'Test',
            amount: 0.0,
            time: '12:00 PM',
            icon: Icons.help,
            iconBackgroundColor: Colors.grey,
            category: 'Test',
          ),
        ];

        final trendData = AnalyticsProcessor.processExpenseTrend(
          zeroAmountTransactions,
          TimeFilter.daily,
        );

        final categoryData = AnalyticsProcessor.processCategoryBreakdown(
          zeroAmountTransactions,
        );

        final summary = AnalyticsProcessor.calculateSummary(
          zeroAmountTransactions,
          1000.0,
        );

        expect(trendData, isNotEmpty);
        expect(categoryData, isEmpty); // Zero amounts shouldn't appear in categories
        expect(summary.totalExpenses, equals(0.0));
      });

      test('should handle very large amounts', () {
        final largeAmountTransactions = [
          Transaction(
            title: 'Large Expense',
            subtitle: 'Big purchase',
            amount: -1000000.0, // 1 million
            time: '12:00 PM',
            icon: Icons.attach_money,
            iconBackgroundColor: Colors.red,
            category: 'Investment',
          ),
        ];

        final summary = AnalyticsProcessor.calculateSummary(
          largeAmountTransactions,
          50000.0,
        );

        expect(summary.totalExpenses, equals(1000000.0));
        expect(summary.hasDeficit, isTrue);
      });

      test('should handle negative salary', () {
        final summary = AnalyticsProcessor.calculateSummary(
          testTransactions,
          -1000.0, // Negative salary (edge case)
        );

        expect(summary.totalIncome, equals(4000.0)); // 5000 - 1000
        expect(summary.monthlyBalance, equals(3825.0)); // 4000 - 175
      });

      test('should handle transactions with special characters in categories', () {
        final specialCharTransactions = [
          Transaction(
            title: 'Special Item',
            subtitle: 'Test',
            amount: -100.0,
            time: '12:00 PM',
            icon: Icons.star,
            iconBackgroundColor: Colors.yellow,
            category: 'Food & Drinks',
          ),
          Transaction(
            title: 'Another Item',
            subtitle: 'Test',
            amount: -50.0,
            time: '01:00 PM',
            icon: Icons.star,
            iconBackgroundColor: Colors.blue,
            category: 'Health/Fitness',
          ),
        ];

        final categoryData = AnalyticsProcessor.processCategoryBreakdown(
          specialCharTransactions,
        );

        expect(categoryData, isNotEmpty);
        // Check that categories are processed correctly (they may be formatted)
        final categoryNames = categoryData.map((cat) => cat.category).toList();
        expect(categoryNames.any((name) => name.toLowerCase().contains('food')), isTrue);
        expect(categoryNames.any((name) => name.toLowerCase().contains('health')), isTrue);
      });
    });
  });
}