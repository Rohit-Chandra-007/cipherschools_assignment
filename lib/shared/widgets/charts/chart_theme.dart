import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../models/chart_data_models.dart';

/// Theme configuration for consistent chart styling across the app
/// Provides responsive design and accessibility features for all chart components
class ChartTheme {
  ChartTheme._();

  // Chart sizing constants for responsive design
  static const double _minChartHeight = 200.0;
  static const double _maxChartHeight = 300.0;
  static const double _minTouchTargetSize = 44.0;
  static const double _pieChartMinRadius = 50.0;
  static const double _pieChartMaxRadius = 80.0;

  /// Gets responsive chart height based on screen size
  static double getResponsiveChartHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final calculatedHeight = screenHeight * 0.25; // 25% of screen height
    return calculatedHeight.clamp(_minChartHeight, _maxChartHeight);
  }

  /// Gets responsive pie chart radius based on available space
  static double getResponsivePieRadius(BuildContext context, {bool isSelected = false}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseRadius = (screenWidth * 0.15).clamp(_pieChartMinRadius, _pieChartMaxRadius);
    return isSelected ? baseRadius + 10 : baseRadius;
  }

  /// Gets responsive font size for chart labels
  static double getResponsiveFontSize(BuildContext context, {required double baseFontSize}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = (screenWidth / 375).clamp(0.8, 1.2); // Base width: 375px
    return baseFontSize * scaleFactor;
  }

  /// Line chart styling for expense trends with responsive design
  static LineChartBarData get expenseLineStyle => LineChartBarData(
        spots: [], // Will be populated with actual data
        isCurved: true,
        color: AppColors.violet100,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(
          show: true,
          color: AppColors.violet20,
        ),
      );

  /// Creates a styled line chart bar data with actual spots and responsive sizing
  static LineChartBarData createExpenseLineData(
    List<FlSpot> spots, {
    BuildContext? context,
  }) {
    final dotRadius = context != null 
        ? getResponsiveFontSize(context, baseFontSize: 4.0)
        : 4.0;
    
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: AppColors.violet100,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: dotRadius,
          color: AppColors.violet100,
          strokeWidth: 2,
          strokeColor: AppColors.light100,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        color: AppColors.violet20,
      ),
    );
  }

  /// Pie chart section styling for categories with responsive design and accessibility
  static PieChartSectionData createCategorySection(
    CategoryData data, {
    required bool isSelected,
    BuildContext? context,
  }) {
    final radius = context != null 
        ? getResponsivePieRadius(context, isSelected: isSelected)
        : (isSelected ? 70.0 : 60.0);
    
    final fontSize = context != null
        ? getResponsiveFontSize(context, baseFontSize: isSelected ? 14.0 : 12.0)
        : (isSelected ? 14.0 : 12.0);

    return PieChartSectionData(
      color: data.color,
      value: data.amount,
      title: isSelected ? '${data.percentage.toStringAsFixed(1)}%' : '',
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: AppColors.light100,
        shadows: [
          Shadow(
            color: AppColors.dark100.withValues(alpha: 0.3),
            offset: const Offset(1, 1),
            blurRadius: 2,
          ),
        ],
      ),
      titlePositionPercentageOffset: 0.6,
      borderSide: isSelected 
          ? BorderSide(color: AppColors.light100, width: 2)
          : BorderSide.none,
    );
  }

  /// Creates responsive time axis titles for line charts
  static FlTitlesData createResponsiveTimeAxisTitles(BuildContext context) {
    final fontSize = getResponsiveFontSize(context, baseFontSize: 12.0);
    
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          getTitlesWidget: (value, meta) {
            return Text(
              formatCurrency(value),
              style: TextStyle(
                color: AppColors.dark75,
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
              ),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toInt().toString(),
              style: TextStyle(
                color: AppColors.dark75,
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
              ),
            );
          },
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  /// Creates custom bottom titles for time-based data with responsive design
  static AxisTitles createTimeBottomTitles(
    List<ExpenseTrendData> data, {
    BuildContext? context,
  }) {
    final fontSize = context != null
        ? getResponsiveFontSize(context, baseFontSize: 10.0)
        : 10.0;

    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        interval: _calculateOptimalInterval(data.length),
        getTitlesWidget: (value, meta) {
          final index = value.toInt();
          if (index >= 0 && index < data.length) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                data[index].label,
                style: TextStyle(
                  color: AppColors.dark75,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Calculates optimal interval for bottom axis labels to prevent overcrowding
  static double _calculateOptimalInterval(int dataLength) {
    if (dataLength <= 7) return 1;
    if (dataLength <= 14) return 2;
    if (dataLength <= 30) return 5;
    return (dataLength / 6).ceil().toDouble();
  }

  /// Grid styling for line charts with responsive design
  static FlGridData get gridData => FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: null,
        getDrawingHorizontalLine: (value) => FlLine(
          color: AppColors.dark25.withValues(alpha: 0.3),
          strokeWidth: 0.8,
        ),
      );

  /// Border styling for line charts
  static FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: AppColors.dark25.withValues(alpha: 0.5), width: 1),
          left: BorderSide(color: AppColors.dark25.withValues(alpha: 0.5), width: 1),
        ),
      );

  /// Touch configuration for line charts with accessibility support
  static LineTouchData createAccessibleLineTouchData({
    required Function(int?) onSpotTouched,
    required List<ExpenseTrendData> data,
    BuildContext? context,
  }) {
    return LineTouchData(
      enabled: true,
      touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
        if (touchResponse != null && 
            touchResponse.lineBarSpots != null && 
            touchResponse.lineBarSpots!.isNotEmpty) {
          // Provide haptic feedback for better accessibility
          try {
            HapticFeedback.lightImpact();
          } catch (e) {
            // Haptic feedback might not be available on all platforms
          }
          onSpotTouched(touchResponse.lineBarSpots!.first.spotIndex);
        } else {
          onSpotTouched(null);
        }
      },
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => AppColors.dark100.withValues(alpha: 0.9),
        tooltipRoundedRadius: 8,
        tooltipPadding: const EdgeInsets.all(12),
        tooltipMargin: 8,
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
          return touchedBarSpots.map((barSpot) {
            final dataIndex = barSpot.spotIndex;
            if (dataIndex >= 0 && dataIndex < data.length) {
              final expenseData = data[dataIndex];
              return LineTooltipItem(
                '${formatCurrency(expenseData.amount)}\n${expenseData.label}',
                TextStyle(
                  color: AppColors.light100,
                  fontWeight: FontWeight.w600,
                  fontSize: context != null 
                      ? getResponsiveFontSize(context, baseFontSize: 12.0)
                      : 12.0,
                ),
              );
            }
            return null;
          }).toList();
        },
      ),
      touchSpotThreshold: _minTouchTargetSize / 2,
      getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
        return spotIndexes.map((spotIndex) {
          return TouchedSpotIndicatorData(
            FlLine(
              color: AppColors.violet100.withValues(alpha: 0.5),
              strokeWidth: 2,
              dashArray: [3, 3],
            ),
            FlDotData(
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 8,
                color: AppColors.violet100,
                strokeWidth: 3,
                strokeColor: AppColors.light100,
              ),
            ),
          );
        }).toList();
      },
    );
  }

  /// Touch configuration for pie charts with accessibility support
  static PieTouchData createAccessiblePieTouchData({
    required Function(int?) onSectionTouched,
  }) {
    return PieTouchData(
      enabled: true,
      touchCallback: (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
        if (!event.isInterestedForInteractions ||
            pieTouchResponse == null ||
            pieTouchResponse.touchedSection == null) {
          onSectionTouched(null);
          return;
        }
        
        // Provide haptic feedback for better accessibility
        try {
          HapticFeedback.selectionClick();
        } catch (e) {
          // Haptic feedback might not be available on all platforms
        }
        
        onSectionTouched(pieTouchResponse.touchedSection!.touchedSectionIndex);
      },
    );
  }

  /// Container decoration for chart widgets
  static BoxDecoration get chartContainerDecoration => BoxDecoration(
        color: AppColors.light100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark25.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      );

  /// Empty state decoration for charts
  static BoxDecoration get emptyStateDecoration => BoxDecoration(
        color: AppColors.light20,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.dark25.withValues(alpha: 0.3),
          width: 1,
        ),
      );

  /// Formats currency values for axis labels with proper scaling
  static String formatCurrency(double value) {
    if (value >= 1000000) {
      return '₹${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '₹${(value / 1000).toStringAsFixed(1)}K';
    } else if (value >= 100) {
      return '₹${value.toStringAsFixed(0)}';
    } else {
      return '₹${value.toStringAsFixed(1)}';
    }
  }

  /// Gets semantic label for chart accessibility
  static String getChartSemanticLabel({
    required String chartType,
    required int dataPointCount,
    String? additionalInfo,
  }) {
    final baseLabel = '$chartType with $dataPointCount data points';
    return additionalInfo != null ? '$baseLabel. $additionalInfo' : baseLabel;
  }

  /// Category colors for consistent pie chart styling
  static const List<Color> categoryColors = [
    AppColors.red100,
    AppColors.blue100,
    AppColors.green100,
    AppColors.yellow100,
    AppColors.violet100,
  ];

  /// Gets color for category by index with fallback
  static Color getCategoryColor(int index) {
    return categoryColors[index % categoryColors.length];
  }

  /// Animation duration constants
  static const Duration chartAnimationDuration = Duration(milliseconds: 800);
  static const Duration touchAnimationDuration = Duration(milliseconds: 200);
  static const Duration transitionAnimationDuration = Duration(milliseconds: 300);
}