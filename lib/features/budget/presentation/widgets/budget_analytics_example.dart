import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cipherschools_assignment/features/budget/presentation/controllers/budget_analytics_controller.dart';
import 'package:cipherschools_assignment/features/budget/presentation/widgets/summary_statistics_card.dart';
import 'package:cipherschools_assignment/features/budget/presentation/widgets/financial_insights_card.dart';

/// Example widget showing how to integrate SummaryStatisticsCard into the budget screen
/// This can replace the placeholder in budget_screen.dart
class BudgetAnalyticsSection extends StatelessWidget {
  const BudgetAnalyticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BudgetAnalyticsController>(
      builder: (context, controller, child) {
        final summary = controller.getSummaryStatistics();
        final previousSummary = controller.getPreviousPeriodSummary();
        final hasInsufficientData = controller.hasInsufficientData;

        return Column(
          children: [
            // Summary Statistics Card
            SummaryStatisticsCard(
              summary: summary,
              previousSummary: previousSummary,
              hasInsufficientData: hasInsufficientData,
            ),
            
            // Add spacing between cards
            const SizedBox(height: 16),
            
            // Financial Insights Card (only show if we have sufficient data)
            if (!hasInsufficientData)
              FinancialInsightsCard(
                summary: summary,
                previousSummary: previousSummary,
              ),
          ],
        );
      },
    );
  }
}

/// Example of how to replace the placeholder in BudgetScreen
/// Replace the Container with "Budget Analytics" placeholder with:
/// 
/// ```dart
/// const BudgetAnalyticsSection(),
/// ```
/// 
/// This will provide:
/// - Summary statistics with trend indicators
/// - Visual feedback for positive/negative trends
/// - Helpful guidance messages for insufficient data
/// - Financial insights and recommendations
/// - Consistent currency formatting using Indian Rupee (₹)
/// - Color-coded trend indicators based on financial impact