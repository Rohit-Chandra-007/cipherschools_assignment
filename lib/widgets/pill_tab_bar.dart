import 'package:cipherschools_assignment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PillTabBar extends StatelessWidget {
  final List<String> tabs;
  final TabController? controller;
  final ValueChanged<int>? onTabChanged;

  const PillTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.light40, // Light gray background
        borderRadius: BorderRadius.circular(28),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: false,
        indicatorWeight: 0.0,
        indicator: BoxDecoration(
          color: AppColors.yellow20, // White background for selected tab
          borderRadius: BorderRadius.circular(24),
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          // When pressed, show purple splash color
          if (states.contains(WidgetState.pressed)) {
            return AppColors.backgroundColor; // Purple with opacity
          }
          return null; // Use default for other states
        }),

        indicatorSize: TabBarIndicatorSize.tab,
        dividerHeight: 0.0,
        splashBorderRadius: BorderRadius.circular(24),
        splashFactory: NoSplash.splashFactory,
        labelColor: AppColors.yellow100, // Purple text for selected tab
        unselectedLabelColor:
            AppColors.dark50, // Gray text for unselected tabs,

        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.normal,
          backgroundColor: Colors.transparent,
        ),
        tabs: tabs.map((tab) => Tab(height: 36, text: tab)).toList(),
        onTap: onTabChanged,
      ),
    );
  }
}
