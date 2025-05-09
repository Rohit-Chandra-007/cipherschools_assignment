import 'package:flutter/material.dart';
import '../data/transaction_data.dart';
import '../models/transaction.dart';
import '../widgets/pill_tab_bar.dart';
import '../widgets/transaction_item.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Today', 'Week', 'Month', 'Year'];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Transaction> transactions = TransactionData.getTransactions();
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transaction',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        PillTabBar(
          tabs: _tabs,
          controller: _tabController,
          onTabChanged: (index) {
            setState(() {});
          },
        ),
        const SizedBox(height: 16),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _tabs.map((tab) {
              return ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return TransactionItem(transaction: transactions[index]);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}