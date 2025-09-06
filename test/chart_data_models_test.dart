import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:cipherschools_assignment/shared/models/chart_data_models.dart';

void main() {
  group('Chart Data Models Tests', () {
    group('ExpenseTrendData Tests', () {
      late ExpenseTrendData testTrendData;
      late ExpenseTrendData identicalTrendData;
      late ExpenseTrendData differentTrendData;

      setUp(() {
        final testDate = DateTime(2024, 1, 15);
        testTrendData = ExpenseTrendData(
          date: testDate,
          amount: 150.0,
          label: 'Jan 15',
        );

        identicalTrendData = ExpenseTrendData(
          date: testDate,
          amount: 150.0,
          label: 'Jan 15',
        );

        differentTrendData = ExpenseTrendData(
          date: DateTime(2024, 1, 16),
          amount: 200.0,
          label: 'Jan 16',
        );
      });

      test('should create ExpenseTrendData with correct properties', () {
        expect(testTrendData.date, equals(DateTime(2024, 1, 15)));
        expect(testTrendData.amount, equals(150.0));
        expect(testTrendData.label, equals('Jan 15'));
      });

      test('should implement equality correctly', () {
        expect(testTrendData, equals(identicalTrendData));
        expect(testTrendData, isNot(equals(differentTrendData)));
      });

      test('should implement hashCode correctly', () {
        expect(testTrendData.hashCode, equals(identicalTrendData.hashCode));
        expect(
          testTrendData.hashCode,
          isNot(equals(differentTrendData.hashCode)),
        );
      });

      test('should implement toString correctly', () {
        final stringRepresentation = testTrendData.toString();
        expect(stringRepresentation, contains('ExpenseTrendData'));
        expect(stringRepresentation, contains('2024-01-15'));
        expect(stringRepresentation, contains('150.0'));
        expect(stringRepresentation, contains('Jan 15'));
      });

      test('should handle zero amounts', () {
        final zeroTrendData = ExpenseTrendData(
          date: DateTime.now(),
          amount: 0.0,
          label: 'Zero',
        );

        expect(zeroTrendData.amount, equals(0.0));
        expect(zeroTrendData.label, equals('Zero'));
      });

      test('should handle negative amounts', () {
        final negativeTrendData = ExpenseTrendData(
          date: DateTime.now(),
          amount: -100.0,
          label: 'Negative',
        );

        expect(negativeTrendData.amount, equals(-100.0));
      });

      test('should handle very large amounts', () {
        final largeTrendData = ExpenseTrendData(
          date: DateTime.now(),
          amount: 1000000.0,
          label: 'Large',
        );

        expect(largeTrendData.amount, equals(1000000.0));
      });

      test('should handle empty labels', () {
        final emptyLabelData = ExpenseTrendData(
          date: DateTime.now(),
          amount: 100.0,
          label: '',
        );

        expect(emptyLabelData.label, equals(''));
      });

      test('should handle special characters in labels', () {
        final specialLabelData = ExpenseTrendData(
          date: DateTime.now(),
          amount: 100.0,
          label: 'Jan 15 - Special & Characters!',
        );

        expect(
          specialLabelData.label,
          equals('Jan 15 - Special & Characters!'),
        );
      });
    });

    group('CategoryData Tests', () {
      late CategoryData testCategoryData;
      late CategoryData identicalCategoryData;
      late CategoryData differentCategoryData;

      setUp(() {
        testCategoryData = CategoryData(
          category: 'Food',
          amount: 500.0,
          percentage: 25.0,
          color: Colors.red,
        );

        identicalCategoryData = CategoryData(
          category: 'Food',
          amount: 500.0,
          percentage: 25.0,
          color: Colors.red,
        );

        differentCategoryData = CategoryData(
          category: 'Transport',
          amount: 300.0,
          percentage: 15.0,
          color: Colors.blue,
        );
      });

      test('should create CategoryData with correct properties', () {
        expect(testCategoryData.category, equals('Food'));
        expect(testCategoryData.amount, equals(500.0));
        expect(testCategoryData.percentage, equals(25.0));
        expect(testCategoryData.color, equals(Colors.red));
      });

      test('should implement equality correctly', () {
        expect(testCategoryData, equals(identicalCategoryData));
        expect(testCategoryData, isNot(equals(differentCategoryData)));
      });

      test('should implement hashCode correctly', () {
        expect(
          testCategoryData.hashCode,
          equals(identicalCategoryData.hashCode),
        );
        expect(
          testCategoryData.hashCode,
          isNot(equals(differentCategoryData.hashCode)),
        );
      });

      test('should implement toString correctly', () {
        final stringRepresentation = testCategoryData.toString();
        expect(stringRepresentation, contains('CategoryData'));
        expect(stringRepresentation, contains('Food'));
        expect(stringRepresentation, contains('500.0'));
        expect(stringRepresentation, contains('25.0'));
      });

      test('should handle zero percentage', () {
        final zeroPercentageData = CategoryData(
          category: 'Zero',
          amount: 0.0,
          percentage: 0.0,
          color: Colors.grey,
        );

        expect(zeroPercentageData.percentage, equals(0.0));
        expect(zeroPercentageData.amount, equals(0.0));
      });

      test('should handle 100% percentage', () {
        final fullPercentageData = CategoryData(
          category: 'All',
          amount: 1000.0,
          percentage: 100.0,
          color: Colors.green,
        );

        expect(fullPercentageData.percentage, equals(100.0));
      });

      test('should handle decimal percentages', () {
        final decimalPercentageData = CategoryData(
          category: 'Decimal',
          amount: 123.45,
          percentage: 12.345,
          color: Colors.orange,
        );

        expect(decimalPercentageData.percentage, equals(12.345));
        expect(decimalPercentageData.amount, equals(123.45));
      });

      test('should handle special characters in category names', () {
        final specialCategoryData = CategoryData(
          category: 'Food & Drinks',
          amount: 200.0,
          percentage: 10.0,
          color: Colors.purple,
        );

        expect(specialCategoryData.category, equals('Food & Drinks'));
      });

      test('should handle empty category names', () {
        final emptyCategoryData = CategoryData(
          category: '',
          amount: 100.0,
          percentage: 5.0,
          color: Colors.black,
        );

        expect(emptyCategoryData.category, equals(''));
      });

      test('should handle different color types', () {
        final customColorData = CategoryData(
          category: 'Custom',
          amount: 100.0,
          percentage: 5.0,
          color: const Color(0xFF123456),
        );

        expect(customColorData.color, equals(const Color(0xFF123456)));
      });
    });

    group('AnalyticsSummary Tests', () {
      late AnalyticsSummary testSummary;
      late AnalyticsSummary identicalSummary;
      late AnalyticsSummary differentSummary;

      setUp(() {
        testSummary = AnalyticsSummary(
          totalExpenses: 1500.0,
          averageDaily: 50.0,
          topCategory: 'Food',
          monthlyBalance: 2500.0,
          totalIncome: 4000.0,
          transactionCount: 30,
        );

        identicalSummary = AnalyticsSummary(
          totalExpenses: 1500.0,
          averageDaily: 50.0,
          topCategory: 'Food',
          monthlyBalance: 2500.0,
          totalIncome: 4000.0,
          transactionCount: 30,
        );

        differentSummary = AnalyticsSummary(
          totalExpenses: 2000.0,
          averageDaily: 66.67,
          topCategory: 'Transport',
          monthlyBalance: 1000.0,
          totalIncome: 3000.0,
          transactionCount: 25,
        );
      });

      test('should create AnalyticsSummary with correct properties', () {
        expect(testSummary.totalExpenses, equals(1500.0));
        expect(testSummary.averageDaily, equals(50.0));
        expect(testSummary.topCategory, equals('Food'));
        expect(testSummary.monthlyBalance, equals(2500.0));
        expect(testSummary.totalIncome, equals(4000.0));
        expect(testSummary.transactionCount, equals(30));
      });

      test('should implement equality correctly', () {
        expect(testSummary, equals(identicalSummary));
        expect(testSummary, isNot(equals(differentSummary)));
      });

      test('should implement hashCode correctly', () {
        expect(testSummary.hashCode, equals(identicalSummary.hashCode));
        expect(testSummary.hashCode, isNot(equals(differentSummary.hashCode)));
      });

      test('should implement toString correctly', () {
        final stringRepresentation = testSummary.toString();
        expect(stringRepresentation, contains('AnalyticsSummary'));
        expect(stringRepresentation, contains('1500.0'));
        expect(stringRepresentation, contains('50.0'));
        expect(stringRepresentation, contains('Food'));
        expect(stringRepresentation, contains('2500.0'));
        expect(stringRepresentation, contains('4000.0'));
        expect(stringRepresentation, contains('30'));
      });

      test('hasDeficit should return correct values', () {
        expect(testSummary.hasDeficit, isFalse); // Positive balance

        final deficitSummary = AnalyticsSummary(
          totalExpenses: 5000.0,
          averageDaily: 166.67,
          topCategory: 'Shopping',
          monthlyBalance: -1000.0, // Negative balance
          totalIncome: 4000.0,
          transactionCount: 20,
        );

        expect(deficitSummary.hasDeficit, isTrue);
      });

      test('hasSurplus should return correct values', () {
        expect(testSummary.hasSurplus, isTrue); // Positive balance

        final deficitSummary = AnalyticsSummary(
          totalExpenses: 5000.0,
          averageDaily: 166.67,
          topCategory: 'Shopping',
          monthlyBalance: -1000.0, // Negative balance
          totalIncome: 4000.0,
          transactionCount: 20,
        );

        expect(deficitSummary.hasSurplus, isFalse);
      });

      test('expenseRatio should calculate correctly', () {
        expect(testSummary.expenseRatio, equals(37.5)); // 1500/4000 * 100

        final zeroIncomeSummary = AnalyticsSummary(
          totalExpenses: 1000.0,
          averageDaily: 33.33,
          topCategory: 'Food',
          monthlyBalance: -1000.0,
          totalIncome: 0.0,
          transactionCount: 10,
        );

        expect(
          zeroIncomeSummary.expenseRatio,
          equals(0.0),
        ); // Should handle division by zero
      });

      test('should handle zero values correctly', () {
        final zeroSummary = AnalyticsSummary(
          totalExpenses: 0.0,
          averageDaily: 0.0,
          topCategory: 'None',
          monthlyBalance: 0.0,
          totalIncome: 0.0,
          transactionCount: 0,
        );

        expect(zeroSummary.hasDeficit, isFalse);
        expect(zeroSummary.hasSurplus, isFalse);
        expect(zeroSummary.expenseRatio, equals(0.0));
      });

      test('should handle negative expenses (edge case)', () {
        final negativeSummary = AnalyticsSummary(
          totalExpenses: -100.0, // Unusual but possible edge case
          averageDaily: -3.33,
          topCategory: 'Refund',
          monthlyBalance: 4100.0,
          totalIncome: 4000.0,
          transactionCount: 5,
        );

        expect(negativeSummary.monthlyBalance, equals(4100.0));
        expect(negativeSummary.expenseRatio, equals(-2.5)); // -100/4000 * 100
      });

      test('should handle very large numbers', () {
        final largeSummary = AnalyticsSummary(
          totalExpenses: 1000000.0,
          averageDaily: 33333.33,
          topCategory: 'Investment',
          monthlyBalance: -500000.0,
          totalIncome: 500000.0,
          transactionCount: 1000,
        );

        expect(largeSummary.hasDeficit, isTrue);
        expect(
          largeSummary.expenseRatio,
          equals(200.0),
        ); // 1000000/500000 * 100
      });

      test('should handle decimal precision correctly', () {
        final precisionSummary = AnalyticsSummary(
          totalExpenses: 123.456,
          averageDaily: 4.115,
          topCategory: 'Precision',
          monthlyBalance: 876.544,
          totalIncome: 1000.0,
          transactionCount: 30,
        );

        expect(precisionSummary.expenseRatio, closeTo(12.3456, 0.0001));
      });

      test('should handle empty category names', () {
        final emptyCategorySummary = AnalyticsSummary(
          totalExpenses: 100.0,
          averageDaily: 3.33,
          topCategory: '',
          monthlyBalance: 900.0,
          totalIncome: 1000.0,
          transactionCount: 5,
        );

        expect(emptyCategorySummary.topCategory, equals(''));
      });

      test('should handle special characters in category names', () {
        final specialCategorySummary = AnalyticsSummary(
          totalExpenses: 100.0,
          averageDaily: 3.33,
          topCategory: 'Food & Drinks',
          monthlyBalance: 900.0,
          totalIncome: 1000.0,
          transactionCount: 5,
        );

        expect(specialCategorySummary.topCategory, equals('Food & Drinks'));
      });
    });

    group('Model Integration Tests', () {
      test('models should work together in collections', () {
        final trendDataList = [
          ExpenseTrendData(
            date: DateTime(2024, 1, 1),
            amount: 100.0,
            label: 'Jan 1',
          ),
          ExpenseTrendData(
            date: DateTime(2024, 1, 2),
            amount: 150.0,
            label: 'Jan 2',
          ),
        ];

        final categoryDataList = [
          CategoryData(
            category: 'Food',
            amount: 200.0,
            percentage: 80.0,
            color: Colors.red,
          ),
          CategoryData(
            category: 'Transport',
            amount: 50.0,
            percentage: 20.0,
            color: Colors.blue,
          ),
        ];

        final summary = AnalyticsSummary(
          totalExpenses: 250.0,
          averageDaily: 125.0,
          topCategory: 'Food',
          monthlyBalance: 750.0,
          totalIncome: 1000.0,
          transactionCount: 2,
        );

        // Verify collections work correctly
        expect(trendDataList.length, equals(2));
        expect(categoryDataList.length, equals(2));
        expect(summary.totalExpenses, equals(250.0));

        // Verify sorting works
        trendDataList.sort((a, b) => a.date.compareTo(b.date));
        expect(trendDataList.first.label, equals('Jan 1'));

        categoryDataList.sort((a, b) => b.amount.compareTo(a.amount));
        expect(categoryDataList.first.category, equals('Food'));
      });

      test('models should handle null-safe operations', () {
        final emptyTrendList = <ExpenseTrendData>[];
        final emptyCategoryList = <CategoryData>[];

        expect(emptyTrendList.isEmpty, isTrue);
        expect(emptyCategoryList.isEmpty, isTrue);

        // Should be able to safely iterate over empty lists
        for (final _ in emptyTrendList) {
          fail('Should not iterate over empty list');
        }

        for (final _ in emptyCategoryList) {
          fail('Should not iterate over empty list');
        }
      });
    });
  });
}
