import 'package:cipherschools_assignment/theme/app_colors.dart';
import 'package:cipherschools_assignment/widgets/income_expence_color_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 300,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF6E5), Color(0xFFF8EDD8)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.purple.shade100, width: 2),
                ),
                child: CircleAvatar(
                  radius: 24,
                  child: Image.asset('assets/images/avatar.png'),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.violet20),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.violet100,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'October',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.dark75,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  size: 24,
                  CupertinoIcons.bell_solid,
                  color: AppColors.violet100,
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Account Balance',
                style: TextStyle(color: Colors.grey[600], fontSize: 15),
              ),
              const SizedBox(height: 8),
              const Text(
                '₹38000',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              IncomeExpanseColorCard(
                title: 'Income',
                amount: '₹12000',
                cardColor: AppColors.green100,
                icon: CupertinoIcons.tray_arrow_down_fill,
              ),
              const SizedBox(width: 16),
              IncomeExpanseColorCard(
                title: 'Expense',
                amount: '₹26000',
                cardColor: AppColors.red100,
                icon: CupertinoIcons.tray_arrow_up_fill,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
