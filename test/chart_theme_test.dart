import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cipherschools_assignment/shared/widgets/charts/chart_theme.dart';
import 'package:cipherschools_assignment/shared/models/chart_data_models.dart';
import 'package:cipherschools_assignment/core/theme/app_colors.dart';

void main() {
  group('ChartTheme Tests', () {
    testWidgets('responsive chart height calculation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Test different screen sizes
              final smallScreenHeight = ChartTheme.getResponsiveChartHeight(context);
              expect(smallScreenHeight, greaterThanOrEqualTo(200.0));
              expect(smallScreenHeight, lessThanOrEqualTo(300.0));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('responsive pie chart radius calculation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final normalRadius = ChartTheme.getResponsivePieRadius(context);
              final selectedRadius = ChartTheme.getResponsivePieRadius(context, isSelected: true);
              
              expect(normalRadius, greaterThanOrEqualTo(50.0));
              expect(selectedRadius, greaterThan(normalRadius));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('responsive font size calculation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final fontSize = ChartTheme.getResponsiveFontSize(context, baseFontSize: 12.0);
              expect(fontSize, greaterThan(0));
              expect(fontSize, lessThanOrEqualTo(24.0)); // Reasonable upper bound
              return Container();
            },
          ),
        ),
      );
    });

    test('currency formatting', () {
      expect(ChartTheme.formatCurrency(50), equals('₹50.0'));
      expect(ChartTheme.formatCurrency(150), equals('₹150'));
      expect(ChartTheme.formatCurrency(1500), equals('₹1.5K'));
      expect(ChartTheme.formatCurrency(1500000), equals('₹1.5M'));
    });

    test('category color assignment', () {
      final color1 = ChartTheme.getCategoryColor(0);
      final color2 = ChartTheme.getCategoryColor(1);
      final color6 = ChartTheme.getCategoryColor(5); // Should wrap around
      
      expect(color1, equals(AppColors.red100));
      expect(color2, equals(AppColors.blue100));
      expect(color6, equals(AppColors.red100)); // Wraps around to first color
    });

    test('semantic label generation', () {
      final label = ChartTheme.getChartSemanticLabel(
        chartType: 'Line chart',
        dataPointCount: 5,
        additionalInfo: 'Showing expense trends',
      );
      
      expect(label, contains('Line chart'));
      expect(label, contains('5 data points'));
      expect(label, contains('Showing expense trends'));
    });

    testWidgets('category section creation with responsive design', (WidgetTester tester) async {
      final categoryData = CategoryData(
        category: 'Food',
        amount: 100.0,
        percentage: 25.0,
        color: AppColors.red100,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final section = ChartTheme.createCategorySection(
                categoryData,
                isSelected: true,
                context: context,
              );
              
              expect(section.color, equals(AppColors.red100));
              expect(section.value, equals(100.0));
              expect(section.title, contains('25.0%'));
              return Container();
            },
          ),
        ),
      );
    });

    test('optimal interval calculation', () {
      // Test private method through public interface
      final shortData = List.generate(5, (i) => ExpenseTrendData(
        date: DateTime.now().add(Duration(days: i)),
        amount: 100.0,
        label: 'Day $i',
      ));
      
      final longData = List.generate(35, (i) => ExpenseTrendData(
        date: DateTime.now().add(Duration(days: i)),
        amount: 100.0,
        label: 'Day $i',
      ));

      // Verify that the bottom titles are created without errors
      expect(() => ChartTheme.createTimeBottomTitles(shortData), returnsNormally);
      expect(() => ChartTheme.createTimeBottomTitles(longData), returnsNormally);
    });

    testWidgets('accessible touch data creation', (WidgetTester tester) async {
      final testData = [
        ExpenseTrendData(
          date: DateTime.now(),
          amount: 100.0,
          label: 'Today',
        ),
      ];
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final touchData = ChartTheme.createAccessibleLineTouchData(
                onSpotTouched: (index) {
                  // Touch callback for testing
                },
                data: testData,
                context: context,
              );
              
              expect(touchData.enabled, isTrue);
              expect(touchData.touchTooltipData, isNotNull);
              return Container();
            },
          ),
        ),
      );
    });
  });
}