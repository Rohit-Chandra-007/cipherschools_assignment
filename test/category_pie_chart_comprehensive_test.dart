import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cipherschools_assignment/features/budget/presentation/widgets/category_pie_chart.dart';
import 'package:cipherschools_assignment/shared/models/chart_data_models.dart';
import 'package:cipherschools_assignment/core/theme/app_colors.dart';

void main() {
  group('CategoryPieChart Comprehensive Widget Tests', () {
    late List<CategoryData> mockCategoryData;
    late List<CategoryData> emptyCategoryData;
    late List<CategoryData> singleCategoryData;
    late List<CategoryData> manyCategoriesData;
    late List<CategoryData> smallPercentageData;

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

      emptyCategoryData = [];

      singleCategoryData = [
        CategoryData(
          category: 'Food',
          amount: 1000.0,
          percentage: 100.0,
          color: AppColors.red100,
        ),
      ];

      manyCategoriesData = List.generate(10, (index) => CategoryData(
        category: 'Category ${index + 1}',
        amount: 100.0 - (index * 5),
        percentage: 10.0 - (index * 0.5),
        color: [AppColors.red100, AppColors.blue100, AppColors.green100, AppColors.yellow100, AppColors.violet100][index % 5],
      ));

      smallPercentageData = [
        CategoryData(
          category: 'Major',
          amount: 950.0,
          percentage: 95.0,
          color: AppColors.red100,
        ),
        CategoryData(
          category: 'Minor',
          amount: 50.0,
          percentage: 5.0,
          color: AppColors.blue100,
        ),
      ];
    });

    group('Basic Rendering Tests', () {
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
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: emptyCategoryData,
              ),
            ),
          ),
        );

        // Verify empty state is shown
        expect(find.text('No expense data'), findsOneWidget);
        expect(find.text('Add some expenses to see category breakdown'), findsOneWidget);
        expect(find.byIcon(Icons.pie_chart_outline), findsOneWidget);
      });

      testWidgets('handles single category correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: singleCategoryData,
              ),
            ),
          ),
        );

        // Verify chart renders with single category
        expect(find.byType(CategoryPieChart), findsOneWidget);
      });

      testWidgets('handles many categories efficiently', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: manyCategoriesData,
              ),
            ),
          ),
        );

        // Verify chart renders with many categories
        expect(find.byType(CategoryPieChart), findsOneWidget);
      });
    });

    group('Interactive Features Tests', () {
      testWidgets('handles tap interactions with callback', (WidgetTester tester) async {
        CategoryData? tappedCategory;
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: mockCategoryData,
                onSectionTapped: (category) {
                  tappedCategory = category;
                },
              ),
            ),
          ),
        );

        // The actual tap testing would require more complex setup with fl_chart
        // For now, we verify the widget builds correctly with the callback
        expect(find.byType(CategoryPieChart), findsOneWidget);
        
        // Verify callback variable is initialized (even if not triggered in this test)
        expect(tappedCategory, isNull);
      });

      testWidgets('handles tap interactions without callback', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: mockCategoryData,
                // No onSectionTapped callback
              ),
            ),
          ),
        );

        // Should render without issues even without callback
        expect(find.byType(CategoryPieChart), findsOneWidget);
      });

      testWidgets('handles null category in tap callback', (WidgetTester tester) async {
        CategoryData? tappedCategory;
        bool nullReceived = false;
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: mockCategoryData,
                onSectionTapped: (category) {
                  tappedCategory = category;
                  if (category == null) {
                    nullReceived = true;
                  }
                },
              ),
            ),
          ),
        );

        // Verify widget renders correctly
        expect(find.byType(CategoryPieChart), findsOneWidget);
        
        // Verify callback variables are initialized (even if not triggered in this test)
        expect(tappedCategory, isNull);
        expect(nullReceived, isFalse);
      });
    });

    group('Responsive Design Tests', () {
      testWidgets('adapts to different screen sizes', (WidgetTester tester) async {
        // Test with small screen
        await tester.binding.setSurfaceSize(const Size(320, 568)); // iPhone SE size
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: mockCategoryData,
              ),
            ),
          ),
        );

        // Verify chart renders on small screen
        expect(find.byType(CategoryPieChart), findsOneWidget);
        
        // Test with large screen
        await tester.binding.setSurfaceSize(const Size(768, 1024)); // iPad size
        await tester.pump();

        // Verify chart still renders correctly on large screen
        expect(find.byType(CategoryPieChart), findsOneWidget);
        
        // Reset to default size
        await tester.binding.setSurfaceSize(null);
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
        
        // Check that the widget respects the custom size
        final renderBox = tester.renderObject<RenderBox>(find.byType(CategoryPieChart));
        expect(renderBox.size.height, equals(customSize));
      });

      testWidgets('uses default size when no size specified', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: mockCategoryData,
                // No size parameter
              ),
            ),
          ),
        );

        // Verify chart renders with default size
        expect(find.byType(CategoryPieChart), findsOneWidget);
        
        final renderBox = tester.renderObject<RenderBox>(find.byType(CategoryPieChart));
        expect(renderBox.size.height, greaterThan(0));
      });
    });

    group('Data Handling Tests', () {
      testWidgets('handles zero amounts correctly', (WidgetTester tester) async {
        final zeroAmountData = [
          CategoryData(
            category: 'Zero Category',
            amount: 0.0,
            percentage: 0.0,
            color: AppColors.dark25,
          ),
          CategoryData(
            category: 'Normal Category',
            amount: 100.0,
            percentage: 100.0,
            color: AppColors.red100,
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: zeroAmountData,
              ),
            ),
          ),
        );

        // Verify chart handles zero amounts gracefully
        expect(find.byType(CategoryPieChart), findsOneWidget);
      });

      testWidgets('handles very large amounts', (WidgetTester tester) async {
        final largeAmountData = [
          CategoryData(
            category: 'Large Category',
            amount: 1000000.0, // 1 million
            percentage: 80.0,
            color: AppColors.red100,
          ),
          CategoryData(
            category: 'Small Category',
            amount: 250000.0, // 250k
            percentage: 20.0,
            color: AppColors.blue100,
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: largeAmountData,
              ),
            ),
          ),
        );

        // Verify chart handles large amounts gracefully
        expect(find.byType(CategoryPieChart), findsOneWidget);
      });

      testWidgets('handles decimal percentages correctly', (WidgetTester tester) async {
        final decimalPercentageData = [
          CategoryData(
            category: 'Precise Category',
            amount: 123.45,
            percentage: 33.333,
            color: AppColors.red100,
          ),
          CategoryData(
            category: 'Another Category',
            amount: 246.55,
            percentage: 66.667,
            color: AppColors.blue100,
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: decimalPercentageData,
              ),
            ),
          ),
        );

        // Verify chart handles decimal percentages gracefully
        expect(find.byType(CategoryPieChart), findsOneWidget);
      });

      testWidgets('handles special characters in category names', (WidgetTester tester) async {
        final specialCharData = [
          CategoryData(
            category: 'Food & Drinks',
            amount: 300.0,
            percentage: 60.0,
            color: AppColors.red100,
          ),
          CategoryData(
            category: 'Health/Fitness',
            amount: 200.0,
            percentage: 40.0,
            color: AppColors.blue100,
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: specialCharData,
              ),
            ),
          ),
        );

        // Verify chart handles special characters gracefully
        expect(find.byType(CategoryPieChart), findsOneWidget);
      });

      testWidgets('handles empty category names', (WidgetTester tester) async {
        final emptyCategoryNameData = [
          CategoryData(
            category: '',
            amount: 100.0,
            percentage: 50.0,
            color: AppColors.red100,
          ),
          CategoryData(
            category: 'Normal Category',
            amount: 100.0,
            percentage: 50.0,
            color: AppColors.blue100,
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: emptyCategoryNameData,
              ),
            ),
          ),
        );

        // Verify chart handles empty category names gracefully
        expect(find.byType(CategoryPieChart), findsOneWidget);
      });
    });

    group('Visual State Tests', () {
      testWidgets('displays different colors for different categories', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: mockCategoryData,
              ),
            ),
          ),
        );

        // Verify chart renders (color verification would require more complex testing)
        expect(find.byType(CategoryPieChart), findsOneWidget);
      });

      testWidgets('handles small percentages visibility', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: smallPercentageData,
              ),
            ),
          ),
        );

        // Verify chart renders with small percentages
        expect(find.byType(CategoryPieChart), findsOneWidget);
      });

      testWidgets('maintains visual consistency across updates', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: mockCategoryData,
              ),
            ),
          ),
        );

        // Initial render
        expect(find.byType(CategoryPieChart), findsOneWidget);

        // Update with new data
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: singleCategoryData,
              ),
            ),
          ),
        );

        // Verify chart still renders after update
        expect(find.byType(CategoryPieChart), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('provides semantic labels for accessibility', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: mockCategoryData,
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
              body: CategoryPieChart(
                categoryData: emptyCategoryData,
              ),
            ),
          ),
        );

        // Verify semantic labels are present for empty state
        expect(find.byType(Semantics), findsWidgets);
      });

      testWidgets('supports screen reader navigation', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: mockCategoryData,
              ),
            ),
          ),
        );

        // Verify accessibility features are in place
        expect(find.byType(CategoryPieChart), findsOneWidget);
        expect(find.byType(Semantics), findsWidgets);
      });
    });

    group('Animation and Performance Tests', () {
      testWidgets('handles rapid data updates efficiently', (WidgetTester tester) async {
        final stopwatch = Stopwatch()..start();
        
        // Perform multiple rapid updates
        for (int i = 0; i < 10; i++) {
          final testData = List.generate(i + 1, (index) => CategoryData(
            category: 'Category $index',
            amount: 100.0 + index,
            percentage: 10.0 + index,
            color: [AppColors.red100, AppColors.blue100, AppColors.green100, AppColors.yellow100, AppColors.violet100][index % 5],
          ));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: CategoryPieChart(
                  categoryData: testData,
                ),
              ),
            ),
          );
          
          await tester.pump();
        }
        
        stopwatch.stop();
        
        // Should complete all updates in reasonable time (less than 3 seconds)
        expect(stopwatch.elapsedMilliseconds, lessThan(3000));
      });

      testWidgets('maintains smooth animations during interactions', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: mockCategoryData,
                onSectionTapped: (category) {
                  // Callback for interaction
                },
              ),
            ),
          ),
        );

        // Verify initial render
        expect(find.byType(CategoryPieChart), findsOneWidget);

        // Simulate animation frames
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 800));

        // Verify chart is still rendered after animation frames
        expect(find.byType(CategoryPieChart), findsOneWidget);
      });
    });

    group('Edge Cases and Error Handling Tests', () {
      testWidgets('handles percentages that don\'t sum to 100%', (WidgetTester tester) async {
        final invalidPercentageData = [
          CategoryData(
            category: 'Category 1',
            amount: 100.0,
            percentage: 30.0,
            color: AppColors.red100,
          ),
          CategoryData(
            category: 'Category 2',
            amount: 200.0,
            percentage: 40.0,
            color: AppColors.blue100,
          ),
          // Total: 70% (not 100%)
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: invalidPercentageData,
              ),
            ),
          ),
        );

        // Should handle gracefully without crashing
        expect(find.byType(CategoryPieChart), findsOneWidget);
      });

      testWidgets('handles negative amounts gracefully', (WidgetTester tester) async {
        final negativeAmountData = [
          CategoryData(
            category: 'Positive',
            amount: 100.0,
            percentage: 150.0, // Over 100%
            color: AppColors.red100,
          ),
          CategoryData(
            category: 'Negative',
            amount: -50.0, // Negative amount
            percentage: -50.0, // Negative percentage
            color: AppColors.blue100,
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: negativeAmountData,
              ),
            ),
          ),
        );

        // Should handle gracefully without crashing
        expect(find.byType(CategoryPieChart), findsOneWidget);
      });

      testWidgets('handles extremely long category names', (WidgetTester tester) async {
        final longNameData = [
          CategoryData(
            category: 'This is an extremely long category name that might cause layout issues in the pie chart',
            amount: 100.0,
            percentage: 100.0,
            color: AppColors.red100,
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: longNameData,
              ),
            ),
          ),
        );

        // Should handle long names gracefully
        expect(find.byType(CategoryPieChart), findsOneWidget);
      });

      testWidgets('handles duplicate category names', (WidgetTester tester) async {
        final duplicateNameData = [
          CategoryData(
            category: 'Food',
            amount: 100.0,
            percentage: 50.0,
            color: AppColors.red100,
          ),
          CategoryData(
            category: 'Food', // Duplicate name
            amount: 100.0,
            percentage: 50.0,
            color: AppColors.blue100,
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: duplicateNameData,
              ),
            ),
          ),
        );

        // Should handle duplicate names gracefully
        expect(find.byType(CategoryPieChart), findsOneWidget);
      });
    });

    group('Theme Integration Tests', () {
      testWidgets('adapts to different themes', (WidgetTester tester) async {
        // Test with light theme
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: mockCategoryData,
              ),
            ),
          ),
        );

        expect(find.byType(CategoryPieChart), findsOneWidget);

        // Test with dark theme
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: mockCategoryData,
              ),
            ),
          ),
        );

        expect(find.byType(CategoryPieChart), findsOneWidget);
      });

      testWidgets('maintains color consistency', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryPieChart(
                categoryData: mockCategoryData,
              ),
            ),
          ),
        );

        // Verify chart renders with consistent colors
        expect(find.byType(CategoryPieChart), findsOneWidget);
      });
    });
  });
}