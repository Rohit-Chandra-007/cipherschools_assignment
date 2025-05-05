import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home, 'Home', selectedIndex == 0),
            _buildNavItem(1, Icons.swap_horiz, 'Transaction', selectedIndex == 1),
            const SizedBox(width: 40), // Space for FAB
            _buildNavItem(3, Icons.pie_chart, 'Budget', selectedIndex == 3),
            _buildNavItem(4, Icons.person, 'Profile', selectedIndex == 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isSelected) {
    return InkWell(
      onTap: () => onItemSelected(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.violet100 : AppColors.dark25,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.violet100 : AppColors.dark25,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
