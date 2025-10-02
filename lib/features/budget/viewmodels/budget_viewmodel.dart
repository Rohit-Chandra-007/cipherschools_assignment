import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cipherschools_assignment/shared/models/transaction.dart';
import 'package:cipherschools_assignment/shared/models/chart_data_models.dart';
import 'package:cipherschools_assignment/shared/services/analytics_processor.dart';
import 'package:cipherschools_assignment/shared/extensions/transaction_analytics.dart';
import 'package:cipherschools_assignment/features/budget/data/services/salary_service.dart';
import 'package:cipherschools_assignment/data/transaction_data.dart';

/// State class for Budget feature
class BudgetState {
  final List<Transaction> transactions;
  final TimeFilter currentFilter;
  final double monthlySalary;
  final DateTime referenceDate;
  final bool isLoading;
  final String? errorMessage;

  BudgetState({
    this.transactions = const [],
    this.currentFilter = TimeFilter.monthly,
    this.monthlySalary = 0.0,
    DateTime? referenceDate,
    this.isLoading = false,
    this.errorMessage,
  }) : referenceDate = referenceDate ?? DateTime.now();

  BudgetState copyWith({
    List<Transaction>? transactions,
    TimeFilter? currentFilter,
    double? monthlySalary,
    DateTime? referenceDate,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BudgetState(
      transactions: transactions ?? this.transactions,
      currentFilter: currentFilter ?? this.currentFilter,
      monthlySalary: monthlySalary ?? this.monthlySalary,
      referenceDate: referenceDate ?? this.referenceDate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// ViewModel for Budget feature
class BudgetViewModel extends Notifier<BudgetState> {
  @override
  BudgetState build() {
    Future.microtask(() => initialize());
    return BudgetState(referenceDate: DateTime.now());
  }

  Future<void> initialize() async {
    await Future.wait([
      loadTransactions(),
      loadSalary(),
    ]);
  }

  Future<void> loadTransactions() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final transactions = TransactionData.getTransactions();
      state = state.copyWith(transactions: transactions, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> loadSalary() async {
    try {
      final salary = await SalaryService.getMonthlySalary();
      state = state.copyWith(monthlySalary: salary);
    } catch (e) {
      state = state.copyWith(monthlySalary: 0.0);
    }
  }

  void updateTimeFilter(TimeFilter filter) {
    state = state.copyWith(currentFilter: filter);
  }

  Future<bool> updateMonthlySalary(double salary) async {
    final success = await SalaryService.saveMonthlySalary(salary);
    if (success) {
      state = state.copyWith(monthlySalary: salary);
    }
    return success;
  }

  void updateReferenceDate(DateTime date) {
    state = state.copyWith(referenceDate: date);
  }

  List<Transaction> get filteredTransactions {
    return state.transactions.where((transaction) {
      return transaction.isInPeriod(state.currentFilter, state.referenceDate);
    }).toList();
  }

  double get currentMonthExpenses {
    return state.transactions
        .where((t) => t.isExpense && t.isInPeriod(TimeFilter.monthly, state.referenceDate))
        .fold<double>(0, (sum, t) => sum + t.amount);
  }

  List<ExpenseTrendData> get expenseTrendData {
    return AnalyticsProcessor.processExpenseTrend(
      filteredTransactions,
      state.currentFilter,
    );
  }

  List<CategoryData> get categoryBreakdownData {
    return AnalyticsProcessor.processCategoryBreakdown(
      state.transactions,
      referenceDate: state.referenceDate,
      filter: state.currentFilter,
    );
  }

  AnalyticsSummary get summaryStatistics {
    final expenses = filteredTransactions.where((t) => t.isExpense).toList();
    final totalExpenses = expenses.fold<double>(0, (sum, t) => sum + t.amount);

    double averageDaily = 0;
    if (expenses.isNotEmpty) {
      switch (state.currentFilter) {
        case TimeFilter.daily:
          averageDaily = totalExpenses;
          break;
        case TimeFilter.weekly:
          averageDaily = totalExpenses / 7;
          break;
        case TimeFilter.monthly:
          averageDaily = totalExpenses / 30;
          break;
        case TimeFilter.yearly:
          averageDaily = totalExpenses / 365;
          break;
      }
    }

    String topCategory = 'None';
    if (expenses.isNotEmpty) {
      final categoryTotals = <String, double>{};
      for (final expense in expenses) {
        final category = expense.title;
        categoryTotals[category] = (categoryTotals[category] ?? 0) + expense.amount;
      }

      if (categoryTotals.isNotEmpty) {
        topCategory = categoryTotals.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;
      }
    }

    final monthlyExpenses = state.transactions
        .where((t) => t.isExpense && t.isInPeriod(TimeFilter.monthly, state.referenceDate))
        .fold<double>(0, (sum, t) => sum + t.amount);

    final monthlyBalance = state.monthlySalary - monthlyExpenses;

    return AnalyticsSummary(
      totalExpenses: totalExpenses,
      averageDaily: averageDaily,
      topCategory: topCategory,
      monthlyBalance: monthlyBalance,
      totalIncome: state.monthlySalary,
      transactionCount: expenses.length,
    );
  }

  AnalyticsSummary? get previousPeriodSummary {
    return null;
  }

  bool get hasInsufficientData {
    final expenses = filteredTransactions.where((t) => t.isExpense).toList();
    switch (state.currentFilter) {
      case TimeFilter.daily:
        return expenses.isEmpty;
      case TimeFilter.weekly:
      case TimeFilter.monthly:
      case TimeFilter.yearly:
        return expenses.length < 3;
    }
  }

  Future<void> refreshData() async {
    await Future.wait([
      loadTransactions(),
      loadSalary(),
    ]);
  }

  bool get canRetry => true;
}

/// Provider for BudgetViewModel
final budgetViewModelProvider = NotifierProvider<BudgetViewModel, BudgetState>(() {
  return BudgetViewModel();
});
