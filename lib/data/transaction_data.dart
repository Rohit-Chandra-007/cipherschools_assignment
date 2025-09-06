import 'package:cipherschools_assignment/shared/models/transaction.dart';
import 'package:flutter/material.dart';


class TransactionData {
  static List<Transaction> getTransactions() {
    return [
      Transaction(
        title: 'Shopping',
        subtitle: 'Buy some grocery',
        amount: 120,
        time: '10:00 AM',
        icon: Icons.shopping_bag,
        iconBackgroundColor: Colors.amber,
        category: 'expense',
      ),
      Transaction(
        title: 'Subscription',
        subtitle: 'Disney+ Annual..',
        amount: 499,
        time: '03:30 PM',
        icon: Icons.subscriptions,
        iconBackgroundColor: Colors.purple,
        category: 'expense',
      ),
      Transaction(
        title: 'Travel',
        subtitle: 'Chandigarh to Delhi',
        amount: 1000,
        time: '10:00 AM',
        icon: Icons.directions_car,
        iconBackgroundColor: Colors.blue,
        category: 'expense',
      ),
      Transaction(
        title: 'Food',
        subtitle: 'Lunch',
        amount: 32,
        time: '01:30 PM',
        icon: Icons.fastfood,
        iconBackgroundColor: Colors.red,
        category: 'expense',
      ),
      Transaction(
        title: 'Salary',
        subtitle: 'Received from company',
        amount: 12000,
        time: '01:30 PM',
        icon: Icons.money,
        iconBackgroundColor: Colors.green,
        category: 'income',
      ),
      Transaction(
        title: 'Bonus',
        subtitle: 'Received from company',
        amount: 12000,
        time: '01:30 PM',
        icon: Icons.money,
        iconBackgroundColor: Colors.green,
        category: 'income',
      ),
    ];
  }
}
