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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // Light gray background
        borderRadius: BorderRadius.circular(28),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: false,
        indicatorWeight: 0.0,
        indicator: BoxDecoration(
          color: Colors.white, // White background for selected tab
          borderRadius: BorderRadius.circular(24),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerHeight: 0.0,

        labelColor: Colors.purple, // Purple text for selected tab
        // unselectedLabelColor: Colors.grey,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.normal,
        ),
        tabs: tabs.map((tab) => Tab(height: 36, text: tab)).toList(),
        onTap: onTabChanged,
      ),
    );
  }
}
