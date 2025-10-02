import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cipherschools_assignment/features/budget/viewmodels/budget_viewmodel.dart';
import 'package:cipherschools_assignment/core/theme/app_colors.dart';
import 'package:cipherschools_assignment/shared/utils/currency_formatter.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetState = ref.watch(budgetViewModelProvider);
    final viewModel = ref.read(budgetViewModelProvider.notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text('Budget'),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: AppColors.dark100,
        ),
        body: SafeArea(
          child: budgetState.isLoading && budgetState.transactions.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: viewModel.refreshData,
                  color: AppColors.violet100,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Salary Overview Card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Monthly Budget',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _showSalaryInputDialog(context, ref),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Salary: ${CurrencyFormatter.format(budgetState.monthlySalary)}',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                'Expenses: ${CurrencyFormatter.format(viewModel.currentMonthExpenses)}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                'Balance: ${CurrencyFormatter.format(budgetState.monthlySalary - viewModel.currentMonthExpenses)}',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: (budgetState.monthlySalary - viewModel.currentMonthExpenses) >= 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Summary Statistics
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Summary',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text('Total Expenses: ${CurrencyFormatter.format(viewModel.summaryStatistics.totalExpenses)}'),
                              Text('Average Daily: ${CurrencyFormatter.format(viewModel.summaryStatistics.averageDaily)}'),
                              Text('Top Category: ${viewModel.summaryStatistics.topCategory}'),
                              Text('Transactions: ${viewModel.summaryStatistics.transactionCount}'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Transactions List
                      Text(
                        'Recent Transactions',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...viewModel.filteredTransactions.take(10).map((transaction) {
                        return Card(
                          child: ListTile(
                            leading: Icon(transaction.icon),
                            title: Text(transaction.title),
                            subtitle: Text(transaction.subtitle),
                            trailing: Text(
                              CurrencyFormatter.format(transaction.amount),
                              style: TextStyle(
                                color: transaction.amount < 0 ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void _showSalaryInputDialog(BuildContext context, WidgetRef ref) {
    final budgetState = ref.read(budgetViewModelProvider);
    final viewModel = ref.read(budgetViewModelProvider.notifier);
    final controller = TextEditingController(
      text: budgetState.monthlySalary > 0 ? budgetState.monthlySalary.toString() : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Monthly Salary'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Monthly Salary',
            prefixText: '\$',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final salary = double.tryParse(controller.text) ?? 0;
              final success = await viewModel.updateMonthlySalary(salary);
              if (context.mounted) {
                Navigator.pop(context);
                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to save salary. Please try again.'),
                    ),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
