import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:cipherschools_assignment/shared/models/transaction.dart';
import 'package:cipherschools_assignment/shared/extensions/transaction_analytics.dart';

void main() {
  group('TransactionAnalytics Extension Tests', () {
    late Transaction expenseTransaction;
    late Transaction incomeTransaction;
    late Transaction zeroTransaction;

    setUp(() {
      expenseTransaction = Transaction(
        title: 'Groceries',
        subtitle: 'Weekly shopping',
        amount: -120.0,
        time: '10:00 AM',
        icon: Icons.shopping_bag,
        iconBackgroundColor: Colors.amber,
        category: 'Food & Dining',
      );

      incomeTransaction = Transaction(
        title: 'Salary',
        subtitle: 'Monthly salary',
        amount: 5000.0,
        time: '09:00 AM',
        icon: Icons.money,
        iconBackgroundColor: Colors.green,
        category: 'Income',
      );

      zeroTransaction = Transaction(
        title: 'Zero Amount',
        subtitle: 'Test transaction',
        amount: 0.0,
        time: '12:00 PM',
        icon: Icons.help,
        iconBackgroundColor: Colors.grey,
        category: 'Test',
      );
    });

    group('DateTime Conversion Tests', () {
      test('dateTime should return current date with parsed time', () {
        final dateTime = expenseTransaction.dateTime;
        final now = DateTime.now();
        
        expect(dateTime.year, equals(now.year));
        expect(dateTime.month, equals(now.month));
        expect(dateTime.day, equals(now.day));
      });

      test('dateTime should be consistent across multiple calls', () {
        final dateTime1 = expenseTransaction.dateTime;
        final dateTime2 = expenseTransaction.dateTime;
        
        expect(dateTime1, equals(dateTime2));
      });
    });

    group('Time Period Filtering Tests', () {
      test('isInPeriod should correctly identify daily period', () {
        final today = DateTime.now();
        final yesterday = today.subtract(const Duration(days: 1));
        final tomorrow = today.add(const Duration(days: 1));

        expect(expenseTransaction.isInPeriod(TimeFilter.daily, today), isTrue);
        expect(expenseTransaction.isInPeriod(TimeFilter.daily, yesterday), isFalse);
        expect(expenseTransaction.isInPeriod(TimeFilter.daily, tomorrow), isFalse);
      });

      test('isInPeriod should correctly identify weekly period', () {
        final today = DateTime.now();
        final thisWeek = today;
        final lastWeek = today.subtract(const Duration(days: 7));
        final nextWeek = today.add(const Duration(days: 7));

        expect(expenseTransaction.isInPeriod(TimeFilter.weekly, thisWeek), isTrue);
        expect(expenseTransaction.isInPeriod(TimeFilter.weekly, lastWeek), isFalse);
        expect(expenseTransaction.isInPeriod(TimeFilter.weekly, nextWeek), isFalse);
      });

      test('isInPeriod should correctly identify monthly period', () {
        final today = DateTime.now();
        final thisMonth = today;
        final lastMonth = DateTime(today.year, today.month - 1, today.day);
        final nextMonth = DateTime(today.year, today.month + 1, today.day);

        expect(expenseTransaction.isInPeriod(TimeFilter.monthly, thisMonth), isTrue);
        expect(expenseTransaction.isInPeriod(TimeFilter.monthly, lastMonth), isFalse);
        expect(expenseTransaction.isInPeriod(TimeFilter.monthly, nextMonth), isFalse);
      });

      test('isInPeriod should correctly identify yearly period', () {
        final today = DateTime.now();
        final thisYear = today;
        final lastYear = DateTime(today.year - 1, today.month, today.day);
        final nextYear = DateTime(today.year + 1, today.month, today.day);

        expect(expenseTransaction.isInPeriod(TimeFilter.yearly, thisYear), isTrue);
        expect(expenseTransaction.isInPeriod(TimeFilter.yearly, lastYear), isFalse);
        expect(expenseTransaction.isInPeriod(TimeFilter.yearly, nextYear), isFalse);
      });

      test('isInPeriod should handle edge cases for week boundaries', () {
        // Since the transaction dateTime always returns current date,
        // we test with current date references
        final today = DateTime.now();
        final thisWeek = today;
        final nextWeek = today.add(const Duration(days: 7));

        expect(expenseTransaction.isInPeriod(TimeFilter.weekly, thisWeek), isTrue);
        expect(expenseTransaction.isInPeriod(TimeFilter.weekly, nextWeek), isFalse);
      });

      test('isInPeriod should handle month boundaries correctly', () {
        final endOfMonth = DateTime(2024, 1, 31);
        final startOfNextMonth = DateTime(2024, 2, 1);

        expect(expenseTransaction.isInPeriod(TimeFilter.monthly, endOfMonth), isFalse);
        expect(expenseTransaction.isInPeriod(TimeFilter.monthly, startOfNextMonth), isFalse);
      });

      test('isInPeriod should handle leap year correctly', () {
        final leapYearDate = DateTime(2024, 2, 29); // Leap year
        final nonLeapYearDate = DateTime(2023, 2, 28);

        expect(expenseTransaction.isInPeriod(TimeFilter.yearly, leapYearDate), isFalse);
        expect(expenseTransaction.isInPeriod(TimeFilter.yearly, nonLeapYearDate), isFalse);
      });
    });

    group('Category Key Tests', () {
      test('categoryKey should return lowercase trimmed category', () {
        expect(expenseTransaction.categoryKey, equals('food & dining'));
        expect(incomeTransaction.categoryKey, equals('income'));
      });

      test('categoryKey should handle categories with extra spaces', () {
        final spacedTransaction = Transaction(
          title: 'Test',
          subtitle: 'Test',
          amount: -100.0,
          time: '12:00 PM',
          icon: Icons.science,
          iconBackgroundColor: Colors.blue,
          category: '  Food & Dining  ',
        );

        expect(spacedTransaction.categoryKey, equals('food & dining'));
      });

      test('categoryKey should handle empty category', () {
        final emptyTransaction = Transaction(
          title: 'Test',
          subtitle: 'Test',
          amount: -100.0,
          time: '12:00 PM',
          icon: Icons.science,
          iconBackgroundColor: Colors.blue,
          category: '',
        );

        expect(emptyTransaction.categoryKey, equals(''));
      });

      test('categoryKey should handle special characters', () {
        final specialTransaction = Transaction(
          title: 'Test',
          subtitle: 'Test',
          amount: -100.0,
          time: '12:00 PM',
          icon: Icons.science,
          iconBackgroundColor: Colors.blue,
          category: 'Food/Drinks & Entertainment!',
        );

        expect(specialTransaction.categoryKey, equals('food/drinks & entertainment!'));
      });
    });

    group('Transaction Type Tests', () {
      test('isExpense should correctly identify expense transactions', () {
        expect(expenseTransaction.isExpense, isTrue);
        expect(incomeTransaction.isExpense, isFalse);
        expect(zeroTransaction.isExpense, isFalse);
      });

      test('isIncome should correctly identify income transactions', () {
        expect(expenseTransaction.isIncome, isFalse);
        expect(incomeTransaction.isIncome, isTrue);
        expect(zeroTransaction.isIncome, isFalse);
      });

      test('absoluteAmount should return positive values', () {
        expect(expenseTransaction.absoluteAmount, equals(120.0));
        expect(incomeTransaction.absoluteAmount, equals(5000.0));
        expect(zeroTransaction.absoluteAmount, equals(0.0));
      });

      test('should handle very large amounts', () {
        final largeExpense = Transaction(
          title: 'Large Expense',
          subtitle: 'Big purchase',
          amount: -1000000.0,
          time: '12:00 PM',
          icon: Icons.attach_money,
          iconBackgroundColor: Colors.red,
          category: 'Investment',
        );

        expect(largeExpense.isExpense, isTrue);
        expect(largeExpense.absoluteAmount, equals(1000000.0));
      });

      test('should handle very small amounts', () {
        final smallExpense = Transaction(
          title: 'Small Expense',
          subtitle: 'Tiny purchase',
          amount: -0.01,
          time: '12:00 PM',
          icon: Icons.attach_money,
          iconBackgroundColor: Colors.red,
          category: 'Misc',
        );

        expect(smallExpense.isExpense, isTrue);
        expect(smallExpense.absoluteAmount, equals(0.01));
      });
    });

    group('TimeFilter Extension Tests', () {
      test('displayName should return correct names', () {
        expect(TimeFilter.daily.displayName, equals('Daily'));
        expect(TimeFilter.weekly.displayName, equals('Weekly'));
        expect(TimeFilter.monthly.displayName, equals('Monthly'));
        expect(TimeFilter.yearly.displayName, equals('Yearly'));
      });

      test('all TimeFilter values should have display names', () {
        for (final filter in TimeFilter.values) {
          expect(filter.displayName, isNotEmpty);
          expect(filter.displayName, isA<String>());
        }
      });
    });

    group('Edge Cases and Boundary Tests', () {
      test('should handle transactions at exact period boundaries', () {
        // Test at midnight (start of day)
        final midnightDate = DateTime(2024, 1, 1, 0, 0, 0);
        
        expect(expenseTransaction.isInPeriod(TimeFilter.daily, midnightDate), isFalse);
      });

      test('should handle different time zones consistently', () {
        // Since we're using current date, time zone shouldn't affect the logic
        // but we should ensure consistency
        final date1 = expenseTransaction.dateTime;
        final date2 = incomeTransaction.dateTime;
        
        expect(date1.timeZoneOffset, equals(date2.timeZoneOffset));
      });

      test('should handle null-like scenarios gracefully', () {
        // Test with minimal transaction data
        final minimalTransaction = Transaction(
          title: '',
          subtitle: '',
          amount: 0.0,
          time: '',
          icon: Icons.help,
          iconBackgroundColor: Colors.grey,
          category: '',
        );

        expect(minimalTransaction.categoryKey, equals(''));
        expect(minimalTransaction.isExpense, isFalse);
        expect(minimalTransaction.isIncome, isFalse);
        expect(minimalTransaction.absoluteAmount, equals(0.0));
      });

      test('should handle extreme date ranges', () {
        final farFuture = DateTime(2100, 12, 31);
        final farPast = DateTime(1900, 1, 1);

        expect(expenseTransaction.isInPeriod(TimeFilter.yearly, farFuture), isFalse);
        expect(expenseTransaction.isInPeriod(TimeFilter.yearly, farPast), isFalse);
      });

      test('should maintain consistency across multiple filter checks', () {
        final referenceDate = DateTime.now();
        
        // Multiple calls should return same result
        final result1 = expenseTransaction.isInPeriod(TimeFilter.monthly, referenceDate);
        final result2 = expenseTransaction.isInPeriod(TimeFilter.monthly, referenceDate);
        final result3 = expenseTransaction.isInPeriod(TimeFilter.monthly, referenceDate);
        
        expect(result1, equals(result2));
        expect(result2, equals(result3));
      });
    });

    group('Performance and Efficiency Tests', () {
      test('should handle large number of period checks efficiently', () {
        final stopwatch = Stopwatch()..start();
        
        // Perform many period checks
        for (int i = 0; i < 1000; i++) {
          final testDate = DateTime.now().add(Duration(days: i));
          expenseTransaction.isInPeriod(TimeFilter.daily, testDate);
          expenseTransaction.isInPeriod(TimeFilter.weekly, testDate);
          expenseTransaction.isInPeriod(TimeFilter.monthly, testDate);
          expenseTransaction.isInPeriod(TimeFilter.yearly, testDate);
        }
        
        stopwatch.stop();
        
        // Should complete in reasonable time (less than 1 second)
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('categoryKey should be efficient for repeated calls', () {
        final stopwatch = Stopwatch()..start();
        
        // Call categoryKey many times
        for (int i = 0; i < 10000; i++) {
          expenseTransaction.categoryKey;
        }
        
        stopwatch.stop();
        
        // Should be very fast (less than 100ms)
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });
    });
  });
}