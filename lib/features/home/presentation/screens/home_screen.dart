import 'package:cipherschools_assignment/core/constants/app_constant.dart';
import 'package:cipherschools_assignment/core/theme/app_colors.dart';
import 'package:cipherschools_assignment/data/transaction_data.dart';
import 'package:cipherschools_assignment/shared/models/transaction.dart';
import 'package:cipherschools_assignment/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../../add_transaction/presentation/screens/expense_screen.dart';
import '../../../add_transaction/presentation/screens/income_screen.dart';
import '../../../transactions/presentation/screens/transactions_screen.dart';
import '../../../budget/presentation/screens/budget_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const HomeTabScreen(),
    const TransactionsScreen(),
    const BudgetScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_selectedIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            BottomSheetHelper.showAddTransactionBottomSheet(
              context: context,
              onIncomePressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IncomeScreen(),
                  ),
                );
              },
              onExpensePressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExpenseScreen(),
                  ),
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
          items: [
            BottomBarItem(
              icon: SvgPicture.asset(
                AppIcons.home,
                colorFilter: ColorFilter.mode(
                  _selectedIndex == 0 ? AppColors.violet100 : Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
              selectedIcon: SvgPicture.asset(
                AppIcons.home,
                colorFilter: ColorFilter.mode(
                  AppColors.violet100,
                  BlendMode.srcIn,
                ),
              ),
              selectedColor: AppColors.violet100,
              unSelectedColor: Colors.grey,
              title: Text(
                'Home',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  color: _selectedIndex == 0 ? AppColors.violet100 : Colors.grey,
                ),
              ),
            ),
            BottomBarItem(
              icon: SvgPicture.asset(
                AppIcons.transaction,
                colorFilter: ColorFilter.mode(
                  _selectedIndex == 1 ? AppColors.violet100 : Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
              selectedIcon: SvgPicture.asset(
                AppIcons.transaction,
                colorFilter: ColorFilter.mode(
                  AppColors.violet100,
                  BlendMode.srcIn,
                ),
              ),
              selectedColor: AppColors.violet100,
              unSelectedColor: Colors.grey,
              title: Text(
                'Transaction',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  color: _selectedIndex == 1 ? AppColors.violet100 : Colors.grey,
                ),
              ),
            ),
            BottomBarItem(
              icon: SvgPicture.asset(
                AppIcons.budget,
                colorFilter: ColorFilter.mode(
                  _selectedIndex == 2 ? AppColors.violet100 : Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
              selectedIcon: SvgPicture.asset(
                AppIcons.budget,
                colorFilter: ColorFilter.mode(
                  AppColors.violet100,
                  BlendMode.srcIn,
                ),
              ),
              selectedColor: AppColors.violet100,
              unSelectedColor: Colors.grey,
              title: Text(
                'Budget',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  color: _selectedIndex == 2 ? AppColors.violet100 : Colors.grey,
                ),
              ),
            ),
            BottomBarItem(
              icon: SvgPicture.asset(
                AppIcons.user,
                colorFilter: ColorFilter.mode(
                  _selectedIndex == 3 ? AppColors.violet100 : Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
              selectedIcon: SvgPicture.asset(
                AppIcons.user,
                colorFilter: ColorFilter.mode(
                  AppColors.violet100,
                  BlendMode.srcIn,
                ),
              ),
              selectedColor: AppColors.violet100,
              unSelectedColor: Colors.grey,
              title: Text(
                'Profile',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  color: _selectedIndex == 3 ? AppColors.violet100 : Colors.grey,
                ),
              ),
            ),
          ],
          hasNotch: true,
          fabLocation: StylishBarFabLocation.center,
          currentIndex: _selectedIndex,
          notchStyle: NotchStyle.circle,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      );
  }
}

class PillWidget extends StatelessWidget {
  const PillWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
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
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: AppColors.violet100),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Transaction> transactions = TransactionData.getTransactions();

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
          BalanceCard(),
          const SizedBox(height: 16),
          PillTabBar(tabs: const ['Today', 'Week', 'Month', 'Year']),
          const SizedBox(height: 8),
          const PillWidget(),
          Expanded(
            child: TabBarView(
              children: [
                // Today tab
                ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return TransactionItem(transaction: transactions[index]);
                  },
                ),
                // Week tab
                ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return TransactionItem(transaction: transactions[index]);
                  },
                ),
                // Month tab
                ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return TransactionItem(transaction: transactions[index]);
                  },
                ),
                // Year tab
                ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return TransactionItem(transaction: transactions[index]);
                  },
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}