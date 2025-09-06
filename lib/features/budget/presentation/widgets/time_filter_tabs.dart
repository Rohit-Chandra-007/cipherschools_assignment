import 'package:flutter/material.dart';
import 'package:cipherschools_assignment/core/theme/app_colors.dart';
import 'package:cipherschools_assignment/shared/extensions/transaction_analytics.dart';

class TimeFilterTabs extends StatefulWidget {
  final TimeFilter selectedFilter;
  final ValueChanged<TimeFilter> onFilterChanged;

  const TimeFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  State<TimeFilterTabs> createState() => _TimeFilterTabsState();
}

class _TimeFilterTabsState extends State<TimeFilterTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<TimeFilter> _filters = TimeFilter.values;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _filters.length,
      vsync: this,
      initialIndex: _filters.indexOf(widget.selectedFilter),
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.onFilterChanged(_filters[_tabController.index]);
      }
    });
  }

  @override
  void didUpdateWidget(TimeFilterTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedFilter != widget.selectedFilter) {
      final newIndex = _filters.indexOf(widget.selectedFilter);
      if (newIndex != _tabController.index) {
        _tabController.animateTo(newIndex);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.light40,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: TabBar(
          controller: _tabController,
          isScrollable: false,
          indicator: BoxDecoration(
            color: AppColors.violet100,
            borderRadius: BorderRadius.circular(24),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.zero,
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.dark75,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          splashBorderRadius: BorderRadius.circular(24),
          tabs: _filters.map((filter) {
            return Tab(
              height: 36,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Center(
                  child: Text(
                    filter.displayName,
                    style: TextStyle(
                      color: widget.selectedFilter == filter
                          ? Colors.white
                          : AppColors.dark75,
                      fontWeight: widget.selectedFilter == filter
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}