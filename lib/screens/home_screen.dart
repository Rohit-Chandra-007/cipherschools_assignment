import 'package:cipherschools_assignment/theme/app_colors.dart';
import 'package:cipherschools_assignment/widgets/balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/custom_bottom_nav.dart';
import '../widgets/custom_tab_bar.dart';
import '../widgets/transaction_item.dart';
import 'expense_screen.dart';
import 'income_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(),
          BalanceCard(),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.light20),
              borderRadius: BorderRadius.circular(16),
            ),
            child: CustomTabBar(
              selectedIndex: _selectedTabIndex,
              onTabSelected: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transaction',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      AppColors.violet20,
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: const Text(
                      'See All',
                      style: TextStyle(color: AppColors.violet100),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: const [
                TransactionItem(
                  title: 'Shopping',
                  subtitle: 'Buy some grocery',
                  amount: '120',
                  time: '10:00 AM',
                  icon: Icons.shopping_bag,
                  iconBackgroundColor: Colors.orange,
                ),
                TransactionItem(
                  title: 'Subscription',
                  subtitle: 'Disney+ Annual',
                  amount: '499',
                  time: '03:30 PM',
                  icon: Icons.subscriptions,
                  iconBackgroundColor: Colors.purple,
                ),
                TransactionItem(
                  title: 'Travel',
                  subtitle: 'Chandigarh to Delhi',
                  amount: '1000',
                  time: '10:00 AM',
                  icon: Icons.directions_car,
                  iconBackgroundColor: Colors.blue,
                ),
                TransactionItem(
                  title: 'Food',
                  subtitle: 'Lunch',
                  amount: '32',
                  time: '01:30 PM',
                  icon: Icons.restaurant,
                  iconBackgroundColor: Colors.red,
                ),
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
                            color: AppColors.violet100.withOpacity(0.1),
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
                            color: AppColors.blue100.withOpacity(0.1),
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
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
