import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const CustomTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['Today', 'Week', 'Month', 'Year'];

    return Row(
      children: List.generate(
        tabs.length,
        (index) => Expanded(
          child: GestureDetector(
            onTap: () => onTabSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              
              decoration: BoxDecoration(
                color:
                    selectedIndex == index
                        ? Colors.orange.withOpacity(0.15)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                tabs[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      selectedIndex == index
                          ? AppColors.yellow100
                          : AppColors.dark20,
                  fontWeight:
                      selectedIndex == index
                          ? FontWeight.w600
                          : FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
