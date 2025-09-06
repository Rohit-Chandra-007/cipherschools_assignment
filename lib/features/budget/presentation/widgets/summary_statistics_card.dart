import 'package:flutter/material.dart';
import 'package:cipherschools_assignment/core/theme/app_colors.dart';
import 'package:cipherschools_assignment/shared/models/chart_data_models.dart';
import 'package:cipherschools_assignment/shared/utils/currency_formatter.dart';
import 'package:cipherschools_assignment/features/budget/presentation/widgets/trend_indicator.dart';

class SummaryStatisticsCard extends StatelessWidget {
  final AnalyticsSummary summary;
  final AnalyticsSummary? previousSummary; // For trend comparison
  final bool hasInsufficientData;

  const SummaryStatisticsCard({
    super.key,
    required this.summary,
    this.previousSummary,
    this.hasInsufficientData = false,
  });

  @override
  Widget build(BuildContext context) {
    if (hasInsufficientData) {
      return _buildInsufficientDataCard(context);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.light100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark25,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary Statistics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.dark100,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatisticRow(
            context,
            'Total Expenses',
            CurrencyFormatter.format(summary.totalExpenses),
            _calculateExpensesTrend(),
            AppColors.red100,
            TrendType.expense,
          ),
          const SizedBox(height: 12),
          _buildStatisticRow(
            context,
            'Average Daily',
            CurrencyFormatter.format(summary.averageDaily),
            _calculateAverageTrend(),
            AppColors.blue100,
            TrendType.expense,
          ),
          const SizedBox(height: 12),
          _buildStatisticRow(
            context,
            'Top Category',
            summary.topCategory,
            null,
            AppColors.violet100,
            TrendType.neutral,
          ),
          const SizedBox(height: 12),
          _buildStatisticRow(
            context,
            'Monthly Balance',
            CurrencyFormatter.formatWithSign(summary.monthlyBalance),
            _calculateBalanceTrend(),
            summary.monthlyBalance >= 0 ? AppColors.green100 : AppColors.red100,
            TrendType.balance,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticRow(
    BuildContext context,
    String label,
    String value,
    double? trendPercentage,
    Color accentColor,
    TrendType trendType,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.dark75,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (trendPercentage != null) 
          TrendIndicator(
            percentage: trendPercentage,
            type: trendType,
          ),
      ],
    );
  }



  Widget _buildInsufficientDataCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.light100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark25,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.violet20,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.insights,
              size: 32,
              color: AppColors.violet100,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Need More Data',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.dark100,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getInsufficientDataMessage(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.dark75,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.blue20,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: AppColors.blue100,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Tip: Add transactions regularly to track your spending patterns',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.blue100,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInsufficientDataMessage() {
    // This would be called when hasInsufficientData is true
    // We can provide different messages based on what data is available
    final transactionCount = summary.totalExpenses > 0 ? 1 : 0;
    
    if (transactionCount == 0) {
      return 'Start by adding your first expense transaction to begin tracking your spending patterns.';
    } else {
      return 'Add more transactions to see meaningful statistics and trends. We recommend at least 3-5 transactions for better insights.';
    }
  }

  /// Calculate expenses trend percentage compared to previous period
  double? _calculateExpensesTrend() {
    if (previousSummary == null || previousSummary!.totalExpenses == 0) {
      return null;
    }
    
    final currentExpenses = summary.totalExpenses;
    final previousExpenses = previousSummary!.totalExpenses;
    
    return ((currentExpenses - previousExpenses) / previousExpenses) * 100;
  }

  /// Calculate average daily spending trend percentage
  double? _calculateAverageTrend() {
    if (previousSummary == null || previousSummary!.averageDaily == 0) {
      return null;
    }
    
    final currentAverage = summary.averageDaily;
    final previousAverage = previousSummary!.averageDaily;
    
    return ((currentAverage - previousAverage) / previousAverage) * 100;
  }

  /// Calculate monthly balance trend percentage
  double? _calculateBalanceTrend() {
    if (previousSummary == null) {
      return null;
    }
    
    final currentBalance = summary.monthlyBalance;
    final previousBalance = previousSummary!.monthlyBalance;
    
    // Handle case where previous balance was zero or negative
    if (previousBalance == 0) {
      return currentBalance > 0 ? 100.0 : (currentBalance < 0 ? -100.0 : 0.0);
    }
    
    return ((currentBalance - previousBalance) / previousBalance.abs()) * 100;
  }
}