import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cipherschools_assignment/features/budget/presentation/widgets/category_pie_chart.dart';
import 'package:cipherschools_assignment/shared/models/chart_data_models.dart';
import 'package:cipherschools_assignment/core/theme/app_colors.dart';

void main() {
  group('CategoryPieChart Widget Tests', () {
    late List<CategoryData> mockCategoryData;

    setUp(() {
      mockCategoryData = [
        CategoryData(
          category: 'Food',
          amount: 500.0,
          percentage: 50.0,
          color: AppColors.red100,
        ),
        CategoryData(
          category: 'Transport',
          amount: 300.0,
          percentage: 30.0,
          color: AppColors.blue100,
        ),
        CategoryData(
          category: 'Entertainment',
          amount: 200.0,
          percentage: 20.0,
          color: AppColors.green100,
        ),
      ];
    });

    testWidgets('displays pie chart with category data', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryPieChart(
              categoryData: mockCategoryData,
            ),
          ),
        ),
      );

      // Verify the pie chart is displayed
      expect(find.byType(CategoryPieChart), findsOneWidget);
    });

    testWidgets('displays empty state when no data provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryPieChart(
              categoryData: [],
            ),
          ),
        ),
      );

      // Verify empty state is shown
      expect(find.text('No expense data'), findsOneWidget);
      expect(find.text('Add some expenses to see category breakdown'), findsOneWidget);
      expect(find.byIcon(Icons.pie_chart_outline), findsOneWidget);
    });

    testWidgets('handles tap interactions', (WidgetTester tester) async {
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryPieChart(
              categoryData: mockCategoryData,
              onSectionTapped: (category) {
              },
            ),
          ),
        ),
      );

      // The actual tap testing would require more complex setup with fl_chart
      // For now, we verify the widget builds correctly with the callback
      expect(find.byType(CategoryPieChart), findsOneWidget);
    });

    testWidgets('respects custom size parameter', (WidgetTester tester) async {
      const customSize = 300.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryPieChart(
              categoryData: mockCategoryData,
              size: customSize,
            ),
          ),
        ),
      );

      // Find the Container that wraps the CategoryPieChart
      final containerFinder = find.descendant(
        of: find.byType(CategoryPieChart),
        matching: find.byType(Container),
      );
      expect(containerFinder, findsOneWidget);
      
      // Check that the widget respects the custom size by verifying the rendered size
      final renderBox = tester.renderObject<RenderBox>(find.byType(CategoryPieChart));
      expect(renderBox.size.height, equals(customSize));
    });
  });
}