import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../models/chart_data_models.dart';
import '../../extensions/transaction_analytics.dart';
import 'chart_theme.dart';

/// Interactive line chart widget for displaying expense trends over time
class ExpenseTrendChart extends StatefulWidget {
  final List<ExpenseTrendData> data;
  final TimeFilter timeFilter;
  final double? height;
  final EdgeInsets? padding;
  final VoidCallback? onEmptyStateAction;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const ExpenseTrendChart({
    super.key,
    required this.data,
    required this.timeFilter,
    this.height = 250,
    this.padding = const EdgeInsets.all(16),
    this.onEmptyStateAction,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  State<ExpenseTrendChart> createState() => _ExpenseTrendChartState();
}

class _ExpenseTrendChartState extends State<ExpenseTrendChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ExpenseTrendChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data || oldWidget.timeFilter != widget.timeFilter) {
      _handleDataTransition();
    }
  }

  /// Handles smooth transitions when data changes
  void _handleDataTransition() {
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final chartHeight = widget.height ?? ChartTheme.getResponsiveChartHeight(context);
    
    return Container(
      height: chartHeight,
      padding: widget.padding,
      decoration: ChartTheme.chartContainerDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Expense Trend',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.dark100,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (widget.data.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.violet20,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getTimeFilterLabel(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.violet100,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return _buildLoadingState();
    }
    
    if (widget.errorMessage != null) {
      return _buildErrorState();
    }
    
    if (widget.data.isEmpty) {
      return _buildEmptyState();
    }
    
    return _buildChart();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.violet100),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading expense data...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.dark75,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.red100,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load chart data',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.dark75,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.errorMessage ?? 'An unexpected error occurred',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.dark50,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: widget.onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red100,
                foregroundColor: AppColors.light100,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChart() {
    final spots = _createFlSpots();
    final maxY = _calculateMaxY();
    
    return Semantics(
      label: ChartTheme.getChartSemanticLabel(
        chartType: 'Expense trend line chart',
        dataPointCount: widget.data.length,
        additionalInfo: 'Tap points to view details',
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return LineChart(
            LineChartData(
              gridData: ChartTheme.gridData,
              titlesData: _createTitlesData(),
              borderData: ChartTheme.borderData,
              minX: 0,
              maxX: (widget.data.length - 1).toDouble(),
              minY: 0,
              maxY: maxY,
              lineBarsData: [
                ChartTheme.createExpenseLineData(
                  spots.map((spot) => FlSpot(
                    spot.x,
                    spot.y * _animation.value,
                  )).toList(),
                  context: context,
                ),
              ],
              lineTouchData: ChartTheme.createAccessibleLineTouchData(
                onSpotTouched: (index) {
                  // Touch handling is managed by ChartTheme
                },
                data: widget.data,
                context: context,
              ),
              clipData: const FlClipData.all(),
            ),
            duration: ChartTheme.transitionAnimationDuration,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final fontSize = ChartTheme.getResponsiveFontSize(context, baseFontSize: 16.0);
    final smallFontSize = ChartTheme.getResponsiveFontSize(context, baseFontSize: 14.0);
    
    return Semantics(
      label: 'No expense data available for trend analysis',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.trending_up_outlined,
              size: 48,
              color: AppColors.dark25,
            ),
            const SizedBox(height: 16),
            Text(
              'No expense data available',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.dark75,
                fontSize: fontSize,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start adding transactions to see your expense trends',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.dark50,
                fontSize: smallFontSize,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.onEmptyStateAction != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: widget.onEmptyStateAction,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Transaction'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.violet100,
                  foregroundColor: AppColors.light100,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: const Size(44, 44), // Minimum touch target size
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<FlSpot> _createFlSpots() {
    return widget.data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.amount);
    }).toList();
  }

  double _calculateMaxY() {
    if (widget.data.isEmpty) return 100;
    
    final maxAmount = widget.data
        .map((d) => d.amount)
        .reduce((a, b) => a > b ? a : b);
    
    // Add 20% padding to the top
    return maxAmount * 1.2;
  }

  FlTitlesData _createTitlesData() {
    final fontSize = ChartTheme.getResponsiveFontSize(context, baseFontSize: 12.0);
    
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          interval: _calculateYInterval(),
          getTitlesWidget: (value, meta) {
            return Text(
              ChartTheme.formatCurrency(value),
              style: TextStyle(
                color: AppColors.dark75,
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
              ),
            );
          },
        ),
      ),
      bottomTitles: ChartTheme.createTimeBottomTitles(widget.data, context: context),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  double? _calculateYInterval() {
    if (widget.data.isEmpty) return null;
    
    final maxAmount = widget.data
        .map((d) => d.amount)
        .reduce((a, b) => a > b ? a : b);
    
    if (maxAmount <= 100) return 20;
    if (maxAmount <= 500) return 100;
    if (maxAmount <= 1000) return 200;
    if (maxAmount <= 5000) return 1000;
    return null; // Let fl_chart decide
  }



  String _getTimeFilterLabel() {
    switch (widget.timeFilter) {
      case TimeFilter.daily:
        return 'Last 7 Days';
      case TimeFilter.weekly:
        return 'Last 4 Weeks';
      case TimeFilter.monthly:
        return 'Last 6 Months';
      case TimeFilter.yearly:
        return 'Last 3 Years';
    }
  }


}