import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cipherschools_assignment/features/budget/presentation/widgets/summary_statistics_card.dart';
import 'package:cipherschools_assignment/shared/models/chart_data_models.dart';

void main() {
  group('SummaryStatisticsCard', () {
    testWidgets('displays summary statistics correctly', (WidgetTester tester) async {
      final summary = AnalyticsSummary(
        totalExpenses: 5000.0,
        averageDaily: 166.67,
        topCategory: 'Food',
        monthlyBalance: 3000.0,
        totalIncome: 8000.0,
        transactionCount: 30,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SummaryStatisticsCard(summary: summary),
          ),
        ),
      );

      // Verify that key elements are displayed
      expect(find.text('Summary Statistics'), findsOneWidget);
      expect(find.text('Total Expenses'), findsOneWidget);
      expect(find.text('Average Daily'), findsOneWidget);
      expect(find.text('Top Category'), findsOneWidget);
      expect(find.text('Monthly Balance'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
    });

    testWidgets('displays insufficient data card when hasInsufficientData is true', (WidgetTester tester) async {
      final summary = AnalyticsSummary(
        totalExpenses: 0.0,
        averageDaily: 0.0,
        topCategory: 'None',
        monthlyBalance: 0.0,
        totalIncome: 0.0,
        transactionCount: 0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SummaryStatisticsCard(
              summary: summary,
              hasInsufficientData: true,
            ),
          ),
        ),
      );

      expect(find.text('Need More Data'), findsOneWidget);
      expect(find.text('Tip: Add transactions regularly to track your spending patterns'), findsOneWidget);
    });

    testWidgets('displays trend indicators when previous summary is provided', (WidgetTester tester) async {
      final summary = AnalyticsSummary(
        totalExpenses: 5000.0,
        averageDaily: 166.67,
        topCategory: 'Food',
        monthlyBalance: 3000.0,
        totalIncome: 8000.0,
        transactionCount: 30,
      );

      final previousSummary = AnalyticsSummary(
        totalExpenses: 4000.0,
        averageDaily: 133.33,
        topCategory: 'Transport',
        monthlyBalance: 2500.0,
        totalIncome: 6500.0,
        transactionCount: 25,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SummaryStatisticsCard(
              summary: summary,
              previousSummary: previousSummary,
            ),
          ),
        ),
      );

      // Should display trend indicators
      expect(find.byIcon(Icons.trending_up), findsWidgets);
    });
  });
}