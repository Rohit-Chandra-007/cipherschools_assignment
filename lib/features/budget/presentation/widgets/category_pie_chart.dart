import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../shared/models/chart_data_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/charts/chart_theme.dart';

class CategoryPieChart extends StatefulWidget {
  final List<CategoryData> categoryData;
  final double? size;
  final Function(CategoryData?)? onSectionTapped;

  const CategoryPieChart({
    super.key,
    required this.categoryData,
    this.size,
    this.onSectionTapped,
  });

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.categoryData.isEmpty) {
      return _buildEmptyState();
    }

    final chartHeight = widget.size ?? ChartTheme.getResponsiveChartHeight(context);
    
    return Container(
      height: chartHeight,
      decoration: ChartTheme.chartContainerDecoration,
      child: Semantics(
        label: ChartTheme.getChartSemanticLabel(
          chartType: 'Category breakdown pie chart',
          dataPointCount: widget.categoryData.length,
          additionalInfo: 'Tap sections to view details',
        ),
        child: PieChart(
          PieChartData(
            sections: _buildPieChartSections(),
            centerSpaceRadius: chartHeight * 0.2, // Responsive center space
            sectionsSpace: 2,
            pieTouchData: ChartTheme.createAccessiblePieTouchData(
              onSectionTouched: (index) {
                setState(() {
                  _touchedIndex = index;
                  if (index != null && index >= 0 && index < widget.categoryData.length) {
                    widget.onSectionTapped?.call(widget.categoryData[index]);
                  } else {
                    widget.onSectionTapped?.call(null);
                  }
                });
              },
            ),
          ),
          duration: ChartTheme.chartAnimationDuration,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return widget.categoryData.asMap().entries.map((entry) {
      final index = entry.key;
      final categoryData = entry.value;
      final isTouched = index == _touchedIndex;
      
      return ChartTheme.createCategorySection(
        categoryData,
        isSelected: isTouched,
        context: context,
      );
    }).toList();
  }



  Widget _buildEmptyState() {
    final chartHeight = widget.size ?? ChartTheme.getResponsiveChartHeight(context);
    final fontSize = ChartTheme.getResponsiveFontSize(context, baseFontSize: 16.0);
    final smallFontSize = ChartTheme.getResponsiveFontSize(context, baseFontSize: 12.0);
    
    return Container(
      height: chartHeight,
      decoration: ChartTheme.emptyStateDecoration,
      child: Semantics(
        label: 'No expense data available for category breakdown',
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pie_chart_outline,
                size: 48,
                color: AppColors.dark50,
              ),
              const SizedBox(height: 8),
              Text(
                'No expense data',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: AppColors.dark75,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Add some expenses to see category breakdown',
                style: TextStyle(
                  fontSize: smallFontSize,
                  color: AppColors.dark50,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}