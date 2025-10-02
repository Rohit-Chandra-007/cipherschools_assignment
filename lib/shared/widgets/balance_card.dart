
import 'package:cipherschools_assignment/core/constants/app_constant.dart';
import 'package:cipherschools_assignment/core/theme/app_colors.dart';
import 'package:cipherschools_assignment/shared/widgets/income_expence_color_card.dart';
import 'package:cipherschools_assignment/features/home/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cipherschools_assignment/shared/utils/currency_formatter.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({super.key});

  static const List<String> _months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);
    
    final selectedMonth = homeState.selectedMonth;
    final summary = homeState.homeSummary;
    
    final balanceText = summary != null 
        ? CurrencyFormatter.format(summary.balance)
        : '-';
    final incomeText = summary != null
        ? CurrencyFormatter.format(summary.income)
        : '-';
    final expenseText = summary != null
        ? CurrencyFormatter.format(summary.expense)
        : '-';
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF6E5), Color(0xFFF8EDD8)],
          tileMode: TileMode.mirror,
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
                  child: Image.asset(AppIcons.avatar),
                ),
              ),
              PopupMenuButton<String>(
                itemBuilder: (context) => _months
                    .map(
                      (m) => PopupMenuItem<String>(
                        value: m,
                        child: Text(
                          m,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: AppColors.dark100, fontSize: 16),
                        ),
                      ),
                    )
                    .toList(),
                initialValue: selectedMonth,
                onSelected: (value) => viewModel.setSelectedMonth(value),
                color: AppColors.light100,
                position: PopupMenuPosition.under,
                offset: const Offset(0, 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.violet20),
                    borderRadius: BorderRadius.circular(40),
                    color: AppColors.transparent,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.arrowDown,
                        colorFilter: const ColorFilter.mode(
                          AppColors.violet100,
                          BlendMode.srcIn,
                        ),
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        selectedMonth,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.dark100,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SvgPicture.asset(
                AppIcons.notification,
                colorFilter: const ColorFilter.mode(
                  AppColors.violet100,
                  BlendMode.srcIn,
                ),
                width: 32,
                height: 32,
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
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: AppColors.dark50),
              ),

              const SizedBox(height: 8),
              Text(balanceText, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              IncomeExpanseColorCard(
                title: 'Income',
                amount: incomeText,
                iconSvgPath: AppIcons.income,
                cardColor: AppColors.green100,
              ),
              const SizedBox(width: 16),
              IncomeExpanseColorCard(
                title: 'Expense',
                amount: expenseText,
                iconSvgPath: AppIcons.expense,
                cardColor: AppColors.red100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
