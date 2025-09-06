import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:cipherschools_assignment/shared/extensions/transaction_analytics.dart';
import 'package:cipherschools_assignment/shared/models/chart_data_models.dart';

void main() {
  group('BudgetAnalyticsController Simple Tests', () {
    group('TimeFilter Extension Tests', () {
      test('should have correct display names', () {
        expect(TimeFilter.daily.displayName, equals('Daily'));
        expect(TimeFilter.weekly.displayName, equals('Weekly'));
        expect(TimeFilter.monthly.displayName, equals('Monthly'));
        expect(TimeFilter.yearly.displayName, equals('Yearly'));
      });

      test('should have all enum values', () {
        expect(TimeFilter.values.length, equals(4));
        expect(TimeFilter.values, contains(TimeFilter.daily));
        expect(TimeFilter.values, contains(TimeFilter.weekly));
        expect(TimeFilter.values, contains(TimeFilter.monthly));
        expect(TimeFilter.values, contains(TimeFilter.yearly));
      });
    });

    group('AnalyticsSummary Model Tests', () {
      test('should calculate deficit correctly', () {
        final summary = AnalyticsSummary(
          totalExpenses: 5000.0,
          averageDaily: 166.67,
          topCategory: 'Food',
          monthlyBalance: -1000.0, // Negative balance
          totalIncome: 4000.0,
          transactionCount: 30,
        );

        expect(summary.hasDeficit, isTrue);
        expect(summary.hasSurplus, isFalse);
        expect(summary.expenseRatio, equals(125.0)); // 5000/4000 * 100
      });

      test('should calculate surplus correctly', () {
        final summary = AnalyticsSummary(
          totalExpenses: 1500.0,
          averageDaily: 50.0,
          topCategory: 'Food',
          monthlyBalance: 2500.0, // Positive balance
          totalIncome: 4000.0,
          transactionCount: 30,
        );

        expect(summary.hasDeficit, isFalse);
        expect(summary.hasSurplus, isTrue);
        expect(summary.expenseRatio, equals(37.5)); // 1500/4000 * 100
      });

      test('should handle zero income', () {
        final summary = AnalyticsSummary(
          totalExpenses: 1000.0,
          averageDaily: 33.33,
          topCategory: 'Food',
          monthlyBalance: -1000.0,
          totalIncome: 0.0,
          transactionCount: 10,
        );

        expect(summary.expenseRatio, equals(0.0)); // Should handle division by zero
        expect(summary.hasDeficit, isTrue);
      });

      test('should handle equal income and expenses', () {
        final summary = AnalyticsSummary(
          totalExpenses: 3000.0,
          averageDaily: 100.0,
          topCategory: 'Food',
          monthlyBalance: 0.0, // Exactly balanced
          totalIncome: 3000.0,
          transactionCount: 30,
        );

        expect(summary.hasDeficit, isFalse);
        expect(summary.hasSurplus, isFalse);
        expect(summary.expenseRatio, equals(100.0)); // 3000/3000 * 100
      });
    });

    group('ExpenseTrendData Model Tests', () {
      test('should create with correct properties', () {
        final trendData = ExpenseTrendData(
          date: DateTime(2024, 1, 15),
          amount: 150.0,
          label: 'Jan 15',
        );

        expect(trendData.date, equals(DateTime(2024, 1, 15)));
        expect(trendData.amount, equals(150.0));
        expect(trendData.label, equals('Jan 15'));
      });

      test('should implement equality correctly', () {
        final data1 = ExpenseTrendData(
          date: DateTime(2024, 1, 15),
          amount: 150.0,
          label: 'Jan 15',
        );

        final data2 = ExpenseTrendData(
          date: DateTime(2024, 1, 15),
          amount: 150.0,
          label: 'Jan 15',
        );

        final data3 = ExpenseTrendData(
          date: DateTime(2024, 1, 16),
          amount: 200.0,
          label: 'Jan 16',
        );

        expect(data1, equals(data2));
        expect(data1, isNot(equals(data3)));
        expect(data1.hashCode, equals(data2.hashCode));
        expect(data1.hashCode, isNot(equals(data3.hashCode)));
      });
    });

    group('CategoryData Model Tests', () {
      test('should create with correct properties', () {
        final categoryData = CategoryData(
          category: 'Food',
          amount: 500.0,
          percentage: 25.0,
          color: Colors.red,
        );

        expect(categoryData.category, equals('Food'));
        expect(categoryData.amount, equals(500.0));
        expect(categoryData.percentage, equals(25.0));
        expect(categoryData.color, equals(Colors.red));
      });

      test('should implement equality correctly', () {
        final data1 = CategoryData(
          category: 'Food',
          amount: 500.0,
          percentage: 25.0,
          color: Colors.red,
        );

        final data2 = CategoryData(
          category: 'Food',
          amount: 500.0,
          percentage: 25.0,
          color: Colors.red,
        );

        final data3 = CategoryData(
          category: 'Transport',
          amount: 300.0,
          percentage: 15.0,
          color: Colors.blue,
        );

        expect(data1, equals(data2));
        expect(data1, isNot(equals(data3)));
        expect(data1.hashCode, equals(data2.hashCode));
        expect(data1.hashCode, isNot(equals(data3.hashCode)));
      });
    });

    group('Data Processing Logic Tests', () {
      test('should handle empty data gracefully', () {
        final emptyTrendData = <ExpenseTrendData>[];
        final emptyCategoryData = <CategoryData>[];

        expect(emptyTrendData.isEmpty, isTrue);
        expect(emptyCategoryData.isEmpty, isTrue);

        // Should be able to safely iterate over empty lists
        var count = 0;
        for (final _ in emptyTrendData) {
          count++;
        }
        expect(count, equals(0));

        count = 0;
        for (final _ in emptyCategoryData) {
          count++;
        }
        expect(count, equals(0));
      });

      test('should handle large datasets efficiently', () {
        final stopwatch = Stopwatch()..start();
        
        // Create large dataset
        final largeTrendData = List.generate(1000, (index) => ExpenseTrendData(
          date: DateTime(2024, 1, 1).add(Duration(days: index)),
          amount: 100.0 + index,
          label: 'Day $index',
        ));

        final largeCategoryData = List.generate(100, (index) => CategoryData(
          category: 'Category $index',
          amount: 100.0 + index,
          percentage: 1.0,
          color: Colors.primaries[index % Colors.primaries.length],
        ));

        // Perform operations on large datasets
        final trendSum = largeTrendData.fold(0.0, (sum, data) => sum + data.amount);
        final categorySum = largeCategoryData.fold(0.0, (sum, data) => sum + data.amount);

        stopwatch.stop();

        expect(trendSum, greaterThan(0));
        expect(categorySum, greaterThan(0));
        expect(stopwatch.elapsedMilliseconds, lessThan(1000)); // Should be fast
      });

      test('should sort data correctly', () {
        final unsortedTrendData = [
          ExpenseTrendData(
            date: DateTime(2024, 1, 3),
            amount: 300.0,
            label: 'Jan 3',
          ),
          ExpenseTrendData(
            date: DateTime(2024, 1, 1),
            amount: 100.0,
            label: 'Jan 1',
          ),
          ExpenseTrendData(
            date: DateTime(2024, 1, 2),
            amount: 200.0,
            label: 'Jan 2',
          ),
        ];

        unsortedTrendData.sort((a, b) => a.date.compareTo(b.date));

        expect(unsortedTrendData[0].label, equals('Jan 1'));
        expect(unsortedTrendData[1].label, equals('Jan 2'));
        expect(unsortedTrendData[2].label, equals('Jan 3'));
      });

      test('should filter data by amount', () {
        final mixedAmountData = [
          ExpenseTrendData(
            date: DateTime(2024, 1, 1),
            amount: 0.0,
            label: 'Zero',
          ),
          ExpenseTrendData(
            date: DateTime(2024, 1, 2),
            amount: 100.0,
            label: 'Hundred',
          ),
          ExpenseTrendData(
            date: DateTime(2024, 1, 3),
            amount: 50.0,
            label: 'Fifty',
          ),
        ];

        final nonZeroData = mixedAmountData.where((data) => data.amount > 0).toList();
        final highAmountData = mixedAmountData.where((data) => data.amount >= 100).toList();

        expect(nonZeroData.length, equals(2));
        expect(highAmountData.length, equals(1));
        expect(highAmountData.first.label, equals('Hundred'));
      });
    });

    group('Edge Cases and Validation Tests', () {
      test('should handle extreme values', () {
        final extremeData = [
          ExpenseTrendData(
            date: DateTime(1900, 1, 1), // Very old date
            amount: 0.01, // Very small amount
            label: 'Extreme 1',
          ),
          ExpenseTrendData(
            date: DateTime(2100, 12, 31), // Future date
            amount: 1000000000.0, // Very large amount
            label: 'Extreme 2',
          ),
        ];

        expect(extremeData.length, equals(2));
        expect(extremeData[0].amount, equals(0.01));
        expect(extremeData[1].amount, equals(1000000000.0));
      });

      test('should handle special characters in labels', () {
        final specialCharData = ExpenseTrendData(
          date: DateTime(2024, 1, 1),
          amount: 100.0,
          label: 'Special & Characters! @#\$%^&*()',
        );

        expect(specialCharData.label, equals('Special & Characters! @#\$%^&*()'));
      });

      test('should handle unicode characters', () {
        final unicodeData = CategoryData(
          category: '食物 🍕🍔🍟', // Food in Chinese with emojis
          amount: 100.0,
          percentage: 50.0,
          color: Colors.red,
        );

        expect(unicodeData.category, equals('食物 🍕🍔🍟'));
      });

      test('should maintain precision with decimal values', () {
        final preciseData = CategoryData(
          category: 'Precise',
          amount: 123.456789,
          percentage: 12.3456789,
          color: Colors.blue,
        );

        expect(preciseData.amount, equals(123.456789));
        expect(preciseData.percentage, equals(12.3456789));
      });
    });

    group('Performance and Memory Tests', () {
      test('should handle rapid object creation and destruction', () {
        final stopwatch = Stopwatch()..start();
        
        // Create and destroy many objects rapidly
        for (int i = 0; i < 10000; i++) {
          final data = ExpenseTrendData(
            date: DateTime.now(),
            amount: i.toDouble(),
            label: 'Item $i',
          );
          
          // Use the data to prevent optimization
          expect(data.amount, equals(i.toDouble()));
        }
        
        stopwatch.stop();
        
        // Should complete quickly
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
      });

      test('should handle concurrent access patterns', () {
        final sharedData = <ExpenseTrendData>[];
        
        // Simulate concurrent access (single-threaded simulation)
        for (int i = 0; i < 100; i++) {
          sharedData.add(ExpenseTrendData(
            date: DateTime(2024, 1, i + 1),
            amount: i.toDouble(),
            label: 'Day $i',
          ));
          
          // Read while writing
          if (sharedData.isNotEmpty) {
            final lastItem = sharedData.last;
            expect(lastItem.amount, equals(i.toDouble()));
          }
        }
        
        expect(sharedData.length, equals(100));
      });
    });
  });
}