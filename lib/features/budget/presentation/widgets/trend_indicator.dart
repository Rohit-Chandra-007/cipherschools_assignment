import 'package:flutter/material.dart';
import 'package:cipherschools_assignment/core/theme/app_colors.dart';
import 'package:cipherschools_assignment/shared/utils/currency_formatter.dart';

enum TrendType {
  expense, // Higher is worse (red for positive, green for negative)
  income,  // Higher is better (green for positive, red for negative)
  balance, // Positive is better (green for positive, red for negative)
  neutral, // No good/bad connotation (blue for all)
}

class TrendIndicator extends StatelessWidget {
  final double percentage;
  final TrendType type;
  final bool showIcon;
  final bool showBackground;
  final double iconSize;
  final TextStyle? textStyle;

  const TrendIndicator({
    super.key,
    required this.percentage,
    required this.type,
    this.showIcon = true,
    this.showBackground = true,
    this.iconSize = 16,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (percentage == 0) {
      return _buildNeutralIndicator(context);
    }

    final isPositive = percentage > 0;
    final colors = _getTrendColors(isPositive);
    
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Icon(
            _getTrendIcon(isPositive),
            size: iconSize,
            color: colors.iconColor,
          ),
          const SizedBox(width: 4),
        ],
        Text(
          CurrencyFormatter.formatPercentage(percentage.abs()),
          style: textStyle?.copyWith(
            color: colors.textColor,
            fontWeight: FontWeight.w600,
          ) ?? Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colors.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    if (showBackground) {
      content = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colors.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: content,
      );
    }

    return content;
  }

  Widget _buildNeutralIndicator(BuildContext context) {
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Icon(
            Icons.remove,
            size: iconSize,
            color: AppColors.dark50,
          ),
          const SizedBox(width: 4),
        ],
        Text(
          '0%',
          style: textStyle?.copyWith(
            color: AppColors.dark50,
            fontWeight: FontWeight.w600,
          ) ?? Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.dark50,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    if (showBackground) {
      content = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.dark25,
          borderRadius: BorderRadius.circular(12),
        ),
        child: content,
      );
    }

    return content;
  }

  IconData _getTrendIcon(bool isPositive) {
    return isPositive ? Icons.trending_up : Icons.trending_down;
  }

  _TrendColors _getTrendColors(bool isPositive) {
    Color baseColor;
    
    switch (type) {
      case TrendType.expense:
        // For expenses: positive trend (increase) is bad, negative trend (decrease) is good
        baseColor = isPositive ? AppColors.red100 : AppColors.green100;
        break;
      case TrendType.income:
        // For income: positive trend (increase) is good, negative trend (decrease) is bad
        baseColor = isPositive ? AppColors.green100 : AppColors.red100;
        break;
      case TrendType.balance:
        // For balance: positive is always good, negative is always bad
        baseColor = isPositive ? AppColors.green100 : AppColors.red100;
        break;
      case TrendType.neutral:
        // Neutral: use blue for all trends
        baseColor = AppColors.blue100;
        break;
    }

    return _TrendColors(
      iconColor: baseColor,
      textColor: baseColor,
      backgroundColor: baseColor.withAlpha(51), // 20% opacity
    );
  }
}

class _TrendColors {
  final Color iconColor;
  final Color textColor;
  final Color backgroundColor;

  _TrendColors({
    required this.iconColor,
    required this.textColor,
    required this.backgroundColor,
  });
}

/// Helper widget for displaying trend with context message
class TrendWithMessage extends StatelessWidget {
  final double percentage;
  final TrendType type;
  final String? customMessage;
  final bool showIcon;

  const TrendWithMessage({
    super.key,
    required this.percentage,
    required this.type,
    this.customMessage,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final message = customMessage ?? _getDefaultMessage();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TrendIndicator(
          percentage: percentage,
          type: type,
          showIcon: showIcon,
        ),
        if (message.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.dark75,
            ),
          ),
        ],
      ],
    );
  }

  String _getDefaultMessage() {
    if (percentage == 0) return 'No change from previous period';
    
    final isPositive = percentage > 0;
    final direction = isPositive ? 'increased' : 'decreased';
    
    switch (type) {
      case TrendType.expense:
        if (isPositive) {
          return 'Spending has $direction - consider reviewing your budget';
        } else {
          return 'Great! You\'ve $direction your spending';
        }
      case TrendType.income:
        if (isPositive) {
          return 'Excellent! Your income has $direction';
        } else {
          return 'Income has $direction from previous period';
        }
      case TrendType.balance:
        if (isPositive) {
          return 'Your financial position has improved';
        } else {
          return 'Consider reducing expenses to improve balance';
        }
      case TrendType.neutral:
        return 'Changed by ${percentage.abs().toStringAsFixed(1)}% from previous period';
    }
  }
}