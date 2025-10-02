import 'package:cipherschools_assignment/core/constants/app_constant.dart';
import 'package:cipherschools_assignment/core/theme/app_colors.dart';
import 'package:cipherschools_assignment/features/home/viewmodels/home_viewmodel.dart';
import 'package:cipherschools_assignment/shared/widgets/widgets.dart';
import 'package:cipherschools_assignment/shared/extensions/transaction_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../add_transaction/views/expense_screen.dart';
import '../../add_transaction/views/income_screen.dart';
import '../../transactions/views/transactions_screen.dart';
import '../../budget/views/budget_screen.dart';
import '../../profile/views/profile_screen.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final List<Widget> _screens = [
    const HomeTabScreen(),
    const TransactionsScreen(),
    const BudgetScreen(),
    const ProfileScreen(),
  ];

  static const List<_NavTab> _tabs = <_NavTab>[
    _NavTab(AppIcons.home, 'Home'),
    _NavTab(AppIcons.transaction, 'Transaction'),
    _NavTab(AppIcons.budget, 'Budget'),
    _NavTab(AppIcons.user, 'Profile'),
  ];

  BottomBarItem _buildBarItem(
    BuildContext context,
    _NavTab tab,
    int index,
    int selectedIndex,
  ) {
    final bool isSelected = selectedIndex == index;
    return BottomBarItem(
      icon: SvgPicture.asset(
        tab.icon,
        colorFilter: ColorFilter.mode(
          isSelected ? AppColors.violet100 : Colors.grey,
          BlendMode.srcIn,
        ),
      ),
      selectedIcon: SvgPicture.asset(
        tab.icon,
        colorFilter: const ColorFilter.mode(
          AppColors.violet100,
          BlendMode.srcIn,
        ),
      ),
      selectedColor: AppColors.violet100,
      unSelectedColor: Colors.grey,
      title: Text(
        tab.label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 12,
          color: isSelected ? AppColors.violet100 : Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);
    
    return Scaffold(
      extendBody: true,
      body: _screens[homeState.bottomNavIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BottomSheetHelper.showAddTransactionBottomSheet(
            context: context,
            onIncomePressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const IncomeScreen()),
              );
            },
            onExpensePressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ExpenseScreen()),
              );
            },
          );
        },
        backgroundColor: AppColors.violet100,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        items: List.generate(
          _tabs.length,
          (index) => _buildBarItem(context, _tabs[index], index, homeState.bottomNavIndex),
        ),
        hasNotch: true,
        fabLocation: StylishBarFabLocation.center,
        currentIndex: homeState.bottomNavIndex,
        notchStyle: NotchStyle.circle,
        onTap: (index) {
          viewModel.setBottomNavIndex(index);
        },
      ),
    );
  }
}

class _NavTab {
  final String icon;
  final String label;
  const _NavTab(this.icon, this.label);
}

class PillWidget extends StatelessWidget {
  const PillWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Recent Transactions",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.dark100,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.violet20,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              "See All",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.violet100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeTabScreen extends ConsumerWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.statusBarColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            AppBar(),
            const BalanceCard(),
            const SizedBox(height: 16),
            PillTabBar(
              tabs: const ['Today', 'Week', 'Month', 'Year'],
              onTabChanged: (index) {
                final mapping = [
                  TimeFilter.daily,
                  TimeFilter.weekly,
                  TimeFilter.monthly,
                  TimeFilter.yearly,
                ];
                viewModel.setTimeFilter(mapping[index]);
              },
            ),
            const SizedBox(height: 8),
            const PillWidget(),
            Expanded(
              child: homeState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : homeState.error != null
                      ? Center(child: Text('Error: ${homeState.error}'))
                      : TabBarView(
                          children: List.generate(
                            4,
                            (_) => ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: homeState.transactions.length,
                              itemBuilder: (context, index) {
                                return TransactionItem(
                                  transaction: homeState.transactions[index],
                                );
                              },
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
