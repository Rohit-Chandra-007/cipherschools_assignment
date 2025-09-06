import 'package:flutter/material.dart';
import 'package:cipherschools_assignment/core/theme/app_colors.dart';
import 'package:cipherschools_assignment/shared/models/chart_data_models.dart';
import 'package:cipherschools_assignment/shared/utils/currency_formatter.dart';

class FinancialInsightsCard extends StatelessWidget {
  final AnalyticsSummary summary;
  final AnalyticsSummary? previousSummary;

  const FinancialInsightsCard({
    super.key,
    required this.summary,
    this.previousSummary,
  });

  @override
  Widget build(BuildContext context) {
    final insights = _generateInsights();
    
    if (insights.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.light100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.violet20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 20,
                color: AppColors.violet100,
              ),
              const SizedBox(width: 8),
              Text(
                'Financial Insights',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.violet100,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...insights.map((insight) => _buildInsightItem(context, insight)),
        ],
      ),
    );
  }

  Widget _buildInsightItem(BuildContext context, _FinancialInsight insight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: insight.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              insight.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.dark75,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<_FinancialInsight> _generateInsights() {
    final insights = <_FinancialInsight>[];

    // Balance insights
    if (summary.monthlyBalance < 0) {
      insights.add(_FinancialInsight(
        message: 'Your expenses exceed your monthly salary by ${CurrencyFormatter.format(summary.monthlyBalance.abs())}. Consider reviewing your spending habits.',
        color: AppColors.red100,
      ));
    } else if (summary.monthlyBalance > 0) {
      final savingsRate = (summary.monthlyBalance / (summary.monthlyBalance + summary.totalExpenses)) * 100;
      if (savingsRate > 20) {
        insights.add(_FinancialInsight(
          message: 'Excellent! You\'re saving ${savingsRate.toStringAsFixed(1)}% of your income. Keep up the great work!',
          color: AppColors.green100,
        ));
      } else if (savingsRate > 10) {
        insights.add(_FinancialInsight(
          message: 'Good job! You\'re saving ${savingsRate.toStringAsFixed(1)}% of your income. Try to increase it to 20% for better financial health.',
          color: AppColors.blue100,
        ));
      } else {
        insights.add(_FinancialInsight(
          message: 'You\'re saving ${savingsRate.toStringAsFixed(1)}% of your income. Consider reducing expenses to save at least 10-20%.',
          color: AppColors.yellow100,
        ));
      }
    }

    // Spending trend insights
    if (previousSummary != null) {
      final expenseChange = summary.totalExpenses - previousSummary!.totalExpenses;
      final expenseChangePercent = previousSummary!.totalExpenses > 0 
          ? (expenseChange / previousSummary!.totalExpenses) * 100 
          : 0.0;

      if (expenseChangePercent > 20) {
        insights.add(_FinancialInsight(
          message: 'Your spending increased by ${expenseChangePercent.toStringAsFixed(1)}% compared to the previous period. Review your ${summary.topCategory} expenses.',
          color: AppColors.red100,
        ));
      } else if (expenseChangePercent < -10) {
        insights.add(_FinancialInsight(
          message: 'Great! You reduced your spending by ${expenseChangePercent.abs().toStringAsFixed(1)}% compared to the previous period.',
          color: AppColors.green100,
        ));
      }
    }

    // Daily spending insights
    if (summary.averageDaily > 0) {
      final monthlyProjection = summary.averageDaily * 30;
      if (monthlyProjection > summary.monthlyBalance + summary.totalExpenses) {
        insights.add(_FinancialInsight(
          message: 'At your current daily spending rate of ${CurrencyFormatter.format(summary.averageDaily)}, you might exceed your monthly budget.',
          color: AppColors.yellow100,
        ));
      }
    }

    // Top category insights
    if (summary.topCategory != 'None' && summary.totalExpenses > 0) {
      // This is a simplified insight - in a real app, you'd calculate the actual percentage
      insights.add(_FinancialInsight(
        message: '${summary.topCategory} is your highest spending category. Consider if there are ways to optimize these expenses.',
        color: AppColors.violet100,
      ));
    }

    return insights.take(3).toList(); // Limit to 3 insights to avoid overwhelming the user
  }
}

class _FinancialInsight {
  final String message;
  final Color color;

  _FinancialInsight({
    required this.message,
    required this.color,
  });
}