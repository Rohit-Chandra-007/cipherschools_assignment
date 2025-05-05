import 'package:flutter/material.dart';
import '../models/transaction.dart';

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
    ];
  }
}