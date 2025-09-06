import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cipherschools_assignment/features/budget/presentation/controllers/budget_analytics_controller.dart';
import 'package:cipherschools_assignment/features/budget/presentation/widgets/salary_overview_card.dart';
import 'package:cipherschools_assignment/features/budget/presentation/widgets/salary_input_dialog.dart';
import 'package:cipherschools_assignment/features/budget/presentation/widgets/time_filter_tabs.dart';
import 'package:cipherschools_assignment/features/budget/presentation/widgets/category_breakdown_section.dart';
import 'package:cipherschools_assignment/features/budget/presentation/widgets/summary_statistics_card.dart';
import 'package:cipherschools_assignment/shared/widgets/charts/expense_trend_chart.dart';
import 'package:cipherschools_assignment/core/theme/app_colors.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late BudgetAnalyticsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BudgetAnalyticsController();
    
    // Listen for errors and show user-friendly messages
    _controller.addListener(_handleControllerErrors);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerErrors);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: ChangeNotifierProvider.value(
        value: _controller,
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
            child: Consumer<BudgetAnalyticsController>(
              builder: (context, controller, child) {
                // Show global error state if there's a critical error
                if (controller.errorMessage != null && controller.transactions.isEmpty) {
                  return _buildGlobalErrorState(controller);
                }

                // Show global loading state during initial data load
                if (controller.isLoading && controller.transactions.isEmpty) {
                  return _buildGlobalLoadingState();
                }

                return Semantics(
                  label: 'Budget analytics dashboard',
                  child: RefreshIndicator(
                    onRefresh: controller.refreshData,
                    color: AppColors.violet100,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              
                              // Salary Overview Card
                              Semantics(
                                label: 'Monthly salary and expenses overview',
                                child: SalaryOverviewCard(
                                  monthlySalary: controller.monthlySalary,
                                  monthlyExpenses: controller.currentMonthExpenses,
                                  onEditSalary: () => _showSalaryInputDialog(context, controller),
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Time Filter Tabs
                              Semantics(
                                label: 'Time period filter for expense analysis',
                                child: TimeFilterTabs(
                                  selectedFilter: controller.currentTimeFilter,
                                  onFilterChanged: controller.updateTimeFilter,
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Expense Trend Chart
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                child: ExpenseTrendChart(
                                  data: controller.expenseTrendData,
                                  timeFilter: controller.currentTimeFilter,
                                  isLoading: controller.isLoading,
                                  errorMessage: controller.errorMessage,
                                  onRetry: controller.refreshData,
                                  onEmptyStateAction: () => _navigateToAddTransaction(context),
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Category Breakdown Section
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                child: Semantics(
                                  label: 'Expense breakdown by category',
                                  child: CategoryBreakdownSection(
                                    categoryData: controller.categoryBreakdownData,
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Summary Statistics Card
                              Semantics(
                                label: 'Financial summary and statistics',
                                child: SummaryStatisticsCard(
                                  summary: controller.summaryStatistics,
                                  previousSummary: controller.previousPeriodSummary,
                                  hasInsufficientData: controller.hasInsufficientData,
                                ),
                              ),
                              
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showSalaryInputDialog(BuildContext context, BudgetAnalyticsController controller) {
    showDialog(
      context: context,
      builder: (context) => SalaryInputDialog(
        currentSalary: controller.monthlySalary > 0 ? controller.monthlySalary : null,
        onSalaryUpdated: (salary) async {
          final success = await controller.updateMonthlySalary(salary);
          if (!success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to save salary. Please try again.',
                  style: TextStyle(color: AppColors.light100),
                ),
                backgroundColor: AppColors.red100,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _handleControllerErrors() {
    if (_controller.errorMessage != null && mounted) {
      // Only show snackbar for non-critical errors (when we still have some data)
      if (_controller.transactions.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.light100,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Some data may be outdated. Pull to refresh.',
                    style: TextStyle(color: AppColors.light100),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.yellow100,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            action: SnackBarAction(
              label: 'Refresh',
              textColor: AppColors.light100,
              onPressed: _controller.refreshData,
            ),
          ),
        );
      }
    }
  }

  void _navigateToAddTransaction(BuildContext context) {
    // Navigate to add transaction screen
    // This would typically use Navigator.push or similar navigation
    // For now, we'll show a simple message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Navigate to add transaction screen',
          style: TextStyle(color: AppColors.light100),
        ),
        backgroundColor: AppColors.violet100,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildGlobalLoadingState() {
    return Semantics(
      label: 'Loading budget analytics data',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Semantics(
              label: 'Loading indicator',
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.violet100),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Loading Budget Analytics...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.dark75,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait while we prepare your financial insights',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.dark50,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlobalErrorState(BudgetAnalyticsController controller) {
    return Semantics(
      label: 'Error loading budget data',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.red20,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.red100,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Unable to Load Budget Data',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.dark100,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                controller.errorMessage ?? 'An unexpected error occurred while loading your budget analytics.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.dark75,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    label: 'Retry loading budget data',
                    child: ElevatedButton.icon(
                      onPressed: controller.refreshData,
                      icon: const Icon(Icons.refresh, size: 20),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.violet100,
                        foregroundColor: AppColors.light100,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(44, 44), // Accessibility touch target
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Semantics(
                    label: 'Add new transaction',
                    child: OutlinedButton.icon(
                      onPressed: () => _navigateToAddTransaction(context),
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text('Add Transaction'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.violet100,
                        side: BorderSide(color: AppColors.violet100),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(44, 44), // Accessibility touch target
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.blue20,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.blue100,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'If the problem persists, try restarting the app or check your internet connection.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.blue100,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}