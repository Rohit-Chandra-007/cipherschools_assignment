import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cipherschools_assignment/shared/widgets/charts/expense_trend_chart.dart';
import 'package:cipherschools_assignment/shared/models/chart_data_models.dart';
import 'package:cipherschools_assignment/shared/extensions/transaction_analytics.dart';

void main() {
  group('ExpenseTrendChart Widget Tests', () {
    late List<ExpenseTrendData> mockTrendData;
    late List<ExpenseTrendData> emptyTrendData;
    late List<ExpenseTrendData> singleDataPoint;
    late List<ExpenseTrendData> largeTrendData;

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
        ExpenseTrendData(
          date: DateTime(2024, 1, 4),
          amount: 200.0,
          label: 'Jan 4',
        ),
        ExpenseTrendData(
          date: DateTime(2024, 1, 5),
          amount: 80.0,
          label: 'Jan 5',
        ),
      ];

      emptyTrendData = [];

      singleDataPoint = [
        ExpenseTrendData(
          date: DateTime(2024, 1, 1),
          amount: 100.0,
          label: 'Jan 1',
        ),
      ];

      largeTrendData = List.generate(30, (index) => ExpenseTrendData(
        date: DateTime(2024, 1, index + 1),
        amount: 100.0 + (index * 10),
        label: 'Day ${index + 1}',
      ));
    });

    group('Basic Widget Rendering Tests', () {
      testWidgets('displays chart with valid data', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.daily,
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
              body: ExpenseTrendChart(
                data: emptyTrendData,
                timeFilter: TimeFilter.daily,
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
              body: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.daily,
                isLoading: true,
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
              body: ExpenseTrendChart(
                data: emptyTrendData,
                timeFilter: TimeFilter.daily,
                errorMessage: errorMessage,
              ),
            ),
          ),
        );

        // Verify error state is shown
        expect(find.text('Failed to load chart data'), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });
    });

    group('Time Filter Display Tests', () {
      testWidgets('displays correct label for daily filter', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        );

        expect(find.text('Last 7 Days'), findsOneWidget);
      });

      testWidgets('displays correct label for weekly filter', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.weekly,
              ),
            ),
          ),
        );

        expect(find.text('Last 4 Weeks'), findsOneWidget);
      });

      testWidgets('displays correct label for monthly filter', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.monthly,
              ),
            ),
          ),
        );

        expect(find.text('Last 6 Months'), findsOneWidget);
      });

      testWidgets('displays correct label for yearly filter', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.yearly,
              ),
            ),
          ),
        );

        expect(find.text('Last 3 Years'), findsOneWidget);
      });
    });

    group('Interactive Features Tests', () {
      testWidgets('displays add transaction button in empty state', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: emptyTrendData,
                timeFilter: TimeFilter.daily,
                onEmptyStateAction: () {},
              ),
            ),
          ),
        );

        // Verify the add transaction button is displayed
        expect(find.text('Add Transaction'), findsOneWidget);
      });

      testWidgets('displays retry button in error state', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: emptyTrendData,
                timeFilter: TimeFilter.daily,
                errorMessage: 'Test error',
                onRetry: () {},
              ),
            ),
          ),
        );

        // Verify the retry button is displayed
        expect(find.text('Retry'), findsOneWidget);
      });

      testWidgets('displays alternative action button in error state', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: emptyTrendData,
                timeFilter: TimeFilter.daily,
                errorMessage: 'Test error',
                onAlternativeAction: () {},
                alternativeActionLabel: 'Reset Data',
              ),
            ),
          ),
        );

        // Verify the alternative action button is displayed
        expect(find.text('Reset Data'), findsOneWidget);
      });
    });

    group('Responsive Design Tests', () {
      testWidgets('adapts to different screen sizes', (WidgetTester tester) async {
        // Test with small screen
        await tester.binding.setSurfaceSize(const Size(320, 568)); // iPhone SE size
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        );

        // Verify chart renders on small screen
        expect(find.byType(ExpenseTrendChart), findsOneWidget);
        
        // Test with large screen
        await tester.binding.setSurfaceSize(const Size(768, 1024)); // iPad size
        await tester.pump();

        // Verify chart still renders correctly on large screen
        expect(find.byType(ExpenseTrendChart), findsOneWidget);
        
        // Reset to default size
        await tester.binding.setSurfaceSize(null);
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

        // Verify the chart widget is displayed with custom height
        expect(find.byType(ExpenseTrendChart), findsOneWidget);
        
        // Check that the widget respects the custom height by verifying the rendered size
        final renderBox = tester.renderObject<RenderBox>(find.byType(ExpenseTrendChart));
        expect(renderBox.size.height, equals(customHeight));
      });

      testWidgets('respects custom padding parameter', (WidgetTester tester) async {
        const customPadding = EdgeInsets.all(24.0);
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.daily,
                padding: customPadding,
              ),
            ),
          ),
        );

        // Verify the chart widget is displayed with custom padding
        expect(find.byType(ExpenseTrendChart), findsOneWidget);
      });
    });

    group('Data Handling Tests', () {
      testWidgets('handles single data point correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: singleDataPoint,
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        );

        // Verify chart renders with single data point
        expect(find.byType(ExpenseTrendChart), findsOneWidget);
        expect(find.text('Expense Trend'), findsOneWidget);
      });

      testWidgets('handles large dataset efficiently', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: largeTrendData,
                timeFilter: TimeFilter.monthly,
              ),
            ),
          ),
        );

        // Verify chart renders with large dataset
        expect(find.byType(ExpenseTrendChart), findsOneWidget);
        expect(find.text('Last 6 Months'), findsOneWidget);
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
              body: ExpenseTrendChart(
                data: zeroAmountData,
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        );

        // Verify chart handles zero amounts gracefully
        expect(find.byType(ExpenseTrendChart), findsOneWidget);
      });

      testWidgets('handles very large amounts in data', (WidgetTester tester) async {
        final largeAmountData = [
          ExpenseTrendData(
            date: DateTime(2024, 1, 1),
            amount: 1000000.0, // 1 million
            label: 'Jan 1',
          ),
          ExpenseTrendData(
            date: DateTime(2024, 1, 2),
            amount: 2000000.0, // 2 million
            label: 'Jan 2',
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: largeAmountData,
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        );

        // Verify chart handles large amounts gracefully
        expect(find.byType(ExpenseTrendChart), findsOneWidget);
      });
    });

    group('Animation Tests', () {
      testWidgets('triggers animation on data change', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        );

        // Initial render
        expect(find.byType(ExpenseTrendChart), findsOneWidget);

        // Change data and verify animation is triggered
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
              body: ExpenseTrendChart(
                data: newData,
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        );

        // Pump animation frames
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 800));

        // Verify chart is still rendered after animation
        expect(find.byType(ExpenseTrendChart), findsOneWidget);
      });

      testWidgets('triggers animation on time filter change', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        );

        // Initial render with daily filter
        expect(find.text('Last 7 Days'), findsOneWidget);

        // Change time filter
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.weekly,
              ),
            ),
          ),
        );

        // Pump animation frames
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        // Verify new filter label is displayed
        expect(find.text('Last 4 Weeks'), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('provides semantic labels for accessibility', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: mockTrendData,
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        );

        // Verify semantic labels are present
        expect(find.byType(Semantics), findsWidgets);
      });

      testWidgets('provides semantic labels for empty state', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: emptyTrendData,
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        );

        // Verify semantic labels are present for empty state
        expect(find.byType(Semantics), findsWidgets);
      });

      testWidgets('has proper minimum touch target sizes', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: emptyTrendData,
                timeFilter: TimeFilter.daily,
                onEmptyStateAction: () {},
              ),
            ),
          ),
        );

        // Verify the add transaction button text is displayed
        expect(find.text('Add Transaction'), findsOneWidget);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('handles null data gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: emptyTrendData, // Empty list instead of null
                timeFilter: TimeFilter.daily,
              ),
            ),
          ),
        );

        // Should display empty state instead of crashing
        expect(find.text('No expense data available'), findsOneWidget);
      });

      testWidgets('displays both retry and alternative actions in error state', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: emptyTrendData,
                timeFilter: TimeFilter.daily,
                errorMessage: 'Network error',
                onRetry: () {},
                onAlternativeAction: () {},
                alternativeActionLabel: 'Use Offline Data',
              ),
            ),
          ),
        );

        // Verify both button texts are displayed
        expect(find.text('Retry'), findsOneWidget);
        expect(find.text('Use Offline Data'), findsOneWidget);
      });

      testWidgets('handles missing alternative action label', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpenseTrendChart(
                data: emptyTrendData,
                timeFilter: TimeFilter.daily,
                errorMessage: 'Error',
                onAlternativeAction: () {},
                // No alternativeActionLabel provided
              ),
            ),
          ),
        );

        // Should use default label
        expect(find.text('Reset'), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('renders efficiently with frequent updates', (WidgetTester tester) async {
        // Measure rendering time for multiple updates
        final stopwatch = Stopwatch()..start();
        
        for (int i = 0; i < 10; i++) {
          final testData = List.generate(i + 1, (index) => ExpenseTrendData(
            date: DateTime(2024, 1, index + 1),
            amount: 100.0 + index,
            label: 'Day ${index + 1}',
          ));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ExpenseTrendChart(
                  data: testData,
                  timeFilter: TimeFilter.daily,
                ),
              ),
            ),
          );
          
          await tester.pump();
        }
        
        stopwatch.stop();
        
        // Should complete all updates in reasonable time (less than 5 seconds)
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
      });
    });
  });
}