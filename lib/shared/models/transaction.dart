import 'package:flutter/material.dart';

class Transaction {
  final String title;
  final String subtitle;
  final double amount;
  final String time;
  final IconData icon;
  final Color iconBackgroundColor;
  final String category;

  Transaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    required this.icon,
    required this.iconBackgroundColor,
    required this.category,
  });
}