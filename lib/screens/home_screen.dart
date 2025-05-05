import 'package:cipherschools_assignment/core/theme/app_colors.dart';
import 'package:cipherschools_assignment/widgets/balance_card.dart';
import 'package:cipherschools_assignment/widgets/pill_tab_bar.dart';
import 'package:flutter/material.dart';

import 'expense_screen.dart';
import 'income_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          children: [
            AppBar(),
            BalanceCard(),
            const SizedBox(height: 16),
            PillTabBar(tabs: const ['Today', 'Week', 'Month', 'Year']),
            const SizedBox(height: 8),
            PillWidget(),
            Expanded(
              child: TabBarView(
                children: const [
                  Center(child: Text('Today')),
                  Center(child: Text('Week')),
                  Center(child: Text('Month')),
                  Center(child: Text('Year')),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder:
                  (context) => Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.violet100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.arrow_upward,
                              color: AppColors.violet100,
                            ),
                          ),
                          title: const Text('Add Income'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const IncomeScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.blue80,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.arrow_downward,
                              color: AppColors.blue100,
                            ),
                          ),
                          title: const Text('Add Expense'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ExpenseScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
            );
          },
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class PillWidget extends StatelessWidget {
  const PillWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
