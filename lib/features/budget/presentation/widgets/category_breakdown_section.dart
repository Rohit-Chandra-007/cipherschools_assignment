import 'package:flutter/material.dart';
import '../../../../shared/models/chart_data_models.dart';
import '../../../../core/theme/app_colors.dart';
import 'category_pie_chart.dart';
import 'category_legend.dart';

class CategoryBreakdownSection extends StatefulWidget {
  final List<CategoryData> categoryData;
  final String title;
  final bool showLegend;

  const CategoryBreakdownSection({
    super.key,
    required this.categoryData,
    this.title = 'Spending by Category',
    this.showLegend = true,
  });

  @override
  State<CategoryBreakdownSection> createState() => _CategoryBreakdownSectionState();
}

class _CategoryBreakdownSectionState extends State<CategoryBreakdownSection> {
  CategoryData? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.light100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark100.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Icon(
                Icons.pie_chart,
                color: AppColors.violet100,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.dark100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (widget.categoryData.isEmpty)
            _buildEmptyState()
          else ...[
            // Pie chart
            CategoryPieChart(
              categoryData: widget.categoryData,
              size: 220,
              onSectionTapped: _handleSectionTapped,
            ),
            
            if (widget.showLegend) ...[
              const SizedBox(height: 24),
              CategoryLegend(
                categoryData: widget.categoryData,
                selectedCategory: _selectedCategory,
                onCategoryTapped: _handleCategoryTapped,
              ),
            ],

            // Selected category details
            if (_selectedCategory != null) ...[
              const SizedBox(height: 16),
              _buildSelectedCategoryDetails(),
            ],
          ],
        ],
      ),
    );
  }

  void _handleSectionTapped(CategoryData? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _handleCategoryTapped(CategoryData category) {
    setState(() {
      _selectedCategory = _selectedCategory?.category == category.category 
          ? null 
          : category;
    });
  }

  Widget _buildSelectedCategoryDetails() {
    if (_selectedCategory == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _selectedCategory!.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedCategory!.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              color: _selectedCategory!.color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedCategory!.category,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark100,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '\$${_selectedCategory!.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _selectedCategory!.color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _selectedCategory!.color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_selectedCategory!.percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.light100,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _selectedCategory = null),
            icon: Icon(
              Icons.close,
              color: AppColors.dark50,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.light20,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.dark25,
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline,
              size: 48,
              color: AppColors.dark50,
            ),
            const SizedBox(height: 12),
            Text(
              'No expense data available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.dark75,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Start adding expenses to see your spending breakdown',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.dark50,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}