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

        splashBorderRadius: BorderRadius.circular(24),

        tabs: tabs.map((tab) => Tab(height: 36, text: tab)).toList(),
        onTap: onTabChanged,
      ),
    );
  }
}
