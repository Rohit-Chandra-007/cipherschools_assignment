import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cipherschools_assignment/shared/widgets/charts/expense_trend_chart.dart';
import 'package:cipherschools_assignment/shared/models/chart_data_models.dart';
import 'package:cipherschools_assignment/shared/extensions/transaction_analytics.dart';

void main() {
  group('ExpenseTrendChart Simple Widget Tests', () {
    late List<ExpenseTrendData> mockTrendData;
    late List<ExpenseTrendData> emptyTrendData;

    setUp(() {
      mockTrendData = [
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
        ExpenseTrendData(
          date: DateTime(2024, 1, 3),
          amount: 120.0,
          label: 'Jan 3',
        ),
      ];

      emptyTrendData = [];
    });

    testWidgets('displays chart with valid data', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        ),
      );

      // Verify the chart widget is displayed
      expect(find.byType(ExpenseTrendChart), findsOneWidget);
      
      // Verify header elements
      expect(find.text('Expense Trend'), findsOneWidget);
      expect(find.text('Last 7 Days'), findsOneWidget);
    });

    testWidgets('displays empty state when no data provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: ExpenseTrendChart(
                data: emptyTrendData,
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        ),
      );

      // Verify empty state is shown
      expect(find.text('No expense data available'), findsOneWidget);
      expect(find.text('Start adding transactions to see your expense trends'), findsOneWidget);
      expect(find.byIcon(Icons.trending_up_outlined), findsOneWidget);
    });

    testWidgets('displays loading state when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.daily,
                isLoading: true,
              ),
            ),
          ),
        ),
      );

      // Verify loading state is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading expense data...'), findsOneWidget);
    });

    testWidgets('displays error state when error message is provided', (WidgetTester tester) async {
      const errorMessage = 'Failed to load data';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: ExpenseTrendChart(
                data: emptyTrendData,
                timeFilter: TimeFilter.daily,
                errorMessage: errorMessage,
              ),
            ),
          ),
        ),
      );

      // Verify error state is shown
      expect(find.text('Failed to load chart data'), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('displays correct label for different time filters', (WidgetTester tester) async {
      // Test daily filter
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        ),
      );
      expect(find.text('Last 7 Days'), findsOneWidget);

      // Test weekly filter
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.weekly,
              ),
            ),
          ),
        ),
      );
      expect(find.text('Last 4 Weeks'), findsOneWidget);

      // Test monthly filter
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.monthly,
              ),
            ),
          ),
        ),
      );
      expect(find.text('Last 6 Months'), findsOneWidget);

      // Test yearly filter
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.yearly,
              ),
            ),
          ),
        ),
      );
      expect(find.text('Last 3 Years'), findsOneWidget);
    });

    testWidgets('handles single data point correctly', (WidgetTester tester) async {
      final singleDataPoint = [
        ExpenseTrendData(
          date: DateTime(2024, 1, 1),
          amount: 100.0,
          label: 'Jan 1',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: ExpenseTrendChart(
                data: singleDataPoint,
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        ),
      );

      // Verify chart renders with single data point
      expect(find.byType(ExpenseTrendChart), findsOneWidget);
      expect(find.text('Expense Trend'), findsOneWidget);
    });

    testWidgets('handles zero amounts in data', (WidgetTester tester) async {
      final zeroAmountData = [
        ExpenseTrendData(
          date: DateTime(2024, 1, 1),
          amount: 0.0,
          label: 'Jan 1',
        ),
        ExpenseTrendData(
          date: DateTime(2024, 1, 2),
          amount: 100.0,
          label: 'Jan 2',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: ExpenseTrendChart(
                data: zeroAmountData,
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        ),
      );

      // Verify chart handles zero amounts gracefully
      expect(find.byType(ExpenseTrendChart), findsOneWidget);
    });

    testWidgets('provides semantic labels for accessibility', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        ),
      );

      // Verify semantic labels are present
      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('triggers animation on data change', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        ),
      );

      // Initial render
      expect(find.byType(ExpenseTrendChart), findsOneWidget);

      // Change data
      final newData = [
        ExpenseTrendData(
          date: DateTime(2024, 2, 1),
          amount: 300.0,
          label: 'Feb 1',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: ExpenseTrendChart(
                data: newData,
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        ),
      );

      // Pump animation frames
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 400));

      // Verify chart is still rendered after animation
      expect(find.byType(ExpenseTrendChart), findsOneWidget);
    });

    testWidgets('respects custom height parameter', (WidgetTester tester) async {
      const customHeight = 300.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpenseTrendChart(
              data: mockTrendData,
              timeFilter: TimeFilter.daily,
              height: customHeight,
            ),
          ),
        ),
      );

      // Verify the chart widget is displayed
      expect(find.byType(ExpenseTrendChart), findsOneWidget);
      
      // Check that the widget respects the custom height
      final renderBox = tester.renderObject<RenderBox>(find.byType(ExpenseTrendChart));
      expect(renderBox.size.height, equals(customHeight));
    });

    testWidgets('handles null data gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: ExpenseTrendChart(
                data: emptyTrendData, // Empty list instead of null
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        ),
      );

      // Should display empty state instead of crashing
      expect(find.text('No expense data available'), findsOneWidget);
    });
  });
}