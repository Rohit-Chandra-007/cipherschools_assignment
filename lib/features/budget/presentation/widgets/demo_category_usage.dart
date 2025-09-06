import 'package:flutter/material.dart';
import '../../../../shared/models/chart_data_models.dart';
import '../../../../core/theme/app_colors.dart';
import 'category_breakdown_section.dart';

/// Demo widget showing how to use the CategoryBreakdownSection
class DemoCategoryUsage extends StatelessWidget {
  const DemoCategoryUsage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample category data
    final categoryData = [
      CategoryData(
        category: 'Food & Dining',
        amount: 450.00,
        percentage: 35.0,
        color: AppColors.red100,
      ),
      CategoryData(
        category: 'Transportation',
        amount: 320.00,
        percentage: 25.0,
        color: AppColors.blue100,
      ),
      CategoryData(
        category: 'Entertainment',
        amount: 200.00,
        percentage: 15.6,
        color: AppColors.green100,
      ),
      CategoryData(
        category: 'Shopping',
        amount: 180.00,
        percentage: 14.0,
        color: AppColors.yellow100,
      ),
      CategoryData(
        category: 'Utilities',
        amount: 130.00,
        percentage: 10.1,
        color: AppColors.violet100,
      ),
      CategoryData(
        category: 'Others',
        amount: 5.00,
        percentage: 0.3,
        color: AppColors.dark25,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Breakdown Demo'),
        backgroundColor: AppColors.light100,
        elevation: 0,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CategoryBreakdownSection(
              categoryData: categoryData,
              title: 'Monthly Spending Breakdown',
              showLegend: true,
            ),
            const SizedBox(height: 24),
            CategoryBreakdownSection(
              categoryData: [],
              title: 'Empty State Example',
              showLegend: true,
            ),
          ],
        ),
      ),
    );
  }
}