import 'package:flutter/material.dart';
import '../../../../shared/models/chart_data_models.dart';
import '../../../../core/theme/app_colors.dart';

class CategoryLegend extends StatelessWidget {
  final List<CategoryData> categoryData;
  final CategoryData? selectedCategory;
  final Function(CategoryData)? onCategoryTapped;
  final bool showPercentages;

  const CategoryLegend({
    super.key,
    required this.categoryData,
    this.selectedCategory,
    this.onCategoryTapped,
    this.showPercentages = true,
  });

  @override
  Widget build(BuildContext context) {
    if (categoryData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Breakdown',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.dark100,
          ),
        ),
        const SizedBox(height: 12),
        ...categoryData.map((category) => _buildLegendItem(category)),
      ],
    );
  }

  Widget _buildLegendItem(CategoryData category) {
    final isSelected = selectedCategory?.category == category.category;
    
    return GestureDetector(
      onTap: () => onCategoryTapped?.call(category),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? category.color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected 
              ? Border.all(color: category.color, width: 1)
              : null,
        ),
        child: Row(
          children: [
            // Color indicator
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: category.color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: category.color.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            
            // Category name
            Expanded(
              child: Text(
                category.category,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? category.color : AppColors.dark75,
                ),
              ),
            ),
            
            // Amount and percentage
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${category.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? category.color : AppColors.dark100,
                  ),
                ),
                if (showPercentages) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${category.percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.dark50,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}