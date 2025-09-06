import 'package:flutter/material.dart';
import 'package:cipherschools_assignment/core/theme/app_colors.dart';

class SalaryOverviewCard extends StatelessWidget {
  final double monthlySalary;
  final double monthlyExpenses;
  final VoidCallback? onEditSalary;

  const SalaryOverviewCard({
    super.key,
    required this.monthlySalary,
    required this.monthlyExpenses,
    this.onEditSalary,
  });

  double get monthlyBalance => monthlySalary - monthlyExpenses;
  bool get hasSurplus => monthlyBalance > 0;
  bool get hasDeficit => monthlyBalance < 0;
  bool get hasSalaryData => monthlySalary > 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.light100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark25.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          if (hasSalaryData) ...[
            _buildSalarySection(context),
            const SizedBox(height: 16),
            _buildComparisonSection(context),
          ] else
            _buildNoSalarySection(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Monthly Overview',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.dark100,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (onEditSalary != null)
          GestureDetector(
            onTap: onEditSalary,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.violet20,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.edit,
                size: 16,
                color: AppColors.violet100,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSalarySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Salary',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.dark75,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '₹${monthlySalary.toStringAsFixed(0)}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.dark100,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBalanceBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                _buildComparisonItem(
                  context,
                  'Income',
                  monthlySalary,
                  AppColors.green100,
                  Icons.trending_up,
                ),
                Container(
                  width: 1,
                  color: AppColors.dark25,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                _buildComparisonItem(
                  context,
                  'Expenses',
                  monthlyExpenses,
                  AppColors.red100,
                  Icons.trending_down,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.dark25, height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Balance',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.dark75,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Icon(
                    _getBalanceIcon(),
                    size: 20,
                    color: _getBalanceColor(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '₹${monthlyBalance.abs().toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: _getBalanceColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getBalanceMessage(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _getBalanceColor(),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonItem(
    BuildContext context,
    String label,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.dark75,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '₹${amount.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSalarySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.violet20,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 48,
            color: AppColors.violet100,
          ),
          const SizedBox(height: 12),
          Text(
            'Add Your Monthly Salary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.violet100,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track your income vs expenses by adding your monthly salary',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.dark75,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (onEditSalary != null)
            ElevatedButton(
              onPressed: onEditSalary,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.violet100,
                foregroundColor: AppColors.light100,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Add Salary',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.light100,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getBalanceBackgroundColor() {
    if (hasDeficit) return AppColors.red20;
    if (hasSurplus) return AppColors.green20;
    return AppColors.light100;
  }

  Color _getBalanceColor() {
    if (hasDeficit) return AppColors.red100;
    if (hasSurplus) return AppColors.green100;
    return AppColors.dark75;
  }

  IconData _getBalanceIcon() {
    if (hasDeficit) return Icons.trending_down;
    if (hasSurplus) return Icons.trending_up;
    return Icons.remove;
  }

  String _getBalanceMessage() {
    if (hasDeficit) {
      return 'You\'re spending more than your income this month';
    } else if (hasSurplus) {
      return 'Great! You have a surplus this month';
    } else {
      return 'Your income and expenses are balanced';
    }
  }
}