import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cipherschools_assignment/shared/models/transaction.dart';
import 'package:cipherschools_assignment/shared/models/chart_data_models.dart';
import 'package:cipherschools_assignment/shared/services/analytics_processor.dart';
import 'package:cipherschools_assignment/shared/extensions/transaction_analytics.dart';
import 'package:cipherschools_assignment/features/budget/data/services/salary_service.dart';
import 'package:cipherschools_assignment/data/transaction_data.dart';


class BudgetAnalyticsController extends ChangeNotifier {
  List<Transaction> _transactions = [];
  TimeFilter _currentFilter = TimeFilter.monthly;
  double _monthlySalary = 0.0;
  DateTime _referenceDate = DateTime.now();

  // Loading and error state
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Transaction> get transactions => _transactions;
  TimeFilter get currentTimeFilter => _currentFilter;
  double get monthlySalary => _monthlySalary;
  DateTime get referenceDate => _referenceDate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  BudgetAnalyticsController() {
    _loadTransactions();
    _loadSalary();
  }

  /// Load transactions from data source
  void _loadTransactions() {
    try {
      _transactions = TransactionData.getTransactions();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load transaction data: ${e.toString()}';
      _transactions = [];
    }
    notifyListeners();
  }

  /// Load salary from local storage
  Future<void> _loadSalary() async {
    try {
      _monthlySalary = await SalaryService.getMonthlySalary();
    } catch (e) {
      _errorMessage = 'Failed to load salary data: ${e.toString()}';
      _monthlySalary = 0.0;
    }
    notifyListeners();
  }

  /// Update the current time filter
  void updateTimeFilter(TimeFilter filter) {
    try {
      if (_currentFilter != filter) {
        _currentFilter = filter;
        _errorMessage = null; // Clear any previous errors when changing filters
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to update time filter: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Update monthly salary
  Future<bool> updateMonthlySalary(double salary) async {
    final success = await SalaryService.saveMonthlySalary(salary);
    if (success) {
      _monthlySalary = salary;
      notifyListeners();
    }
    return success;
  }

  /// Update reference date for filtering
  void updateReferenceDate(DateTime date) {
    _referenceDate = date;
    notifyListeners();
  }

  /// Get filtered transactions based on current filter and reference date
  List<Transaction> get filteredTransactions {
    return _transactions.where((transaction) {
      return transaction.isInPeriod(_currentFilter, _referenceDate);
    }).toList();
  }

  /// Get expense trend data for line chart
  List<FlSpot> getExpenseTrendData() {
    final expenses = filteredTransactions.where((t) => t.isExpense).toList();
    
    if (expenses.isEmpty) return [];

    // Group expenses by date and calculate daily totals
    final Map<DateTime, double> dailyExpenses = {};
    
    for (final expense in expenses) {
      final date = DateTime(
        expense.dateTime.year,
        expense.dateTime.month,
        expense.dateTime.day,
      );
      dailyExpenses[date] = (dailyExpenses[date] ?? 0) + expense.amount;
    }

    // Convert to FlSpot list for chart
    final spots = <FlSpot>[];
    final sortedDates = dailyExpenses.keys.toList()..sort();
    
    for (int i = 0; i < sortedDates.length; i++) {
      final date = sortedDates[i];
      spots.add(FlSpot(i.toDouble(), dailyExpenses[date]!));
    }

    return spots;
  }

  /// Get category breakdown data for pie chart
  List<PieChartSectionData> getCategoryBreakdown() {
    final categoryData = getCategoryData();
    
    if (categoryData.isEmpty) return [];

    return categoryData.map((category) {
      return PieChartSectionData(
        color: category.color,
        value: category.amount,
        title: '${category.percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  /// Get summary statistics
  AnalyticsSummary getSummaryStatistics() {
    final expenses = filteredTransactions.where((t) => t.isExpense).toList();
    final totalExpenses = expenses.fold<double>(0, (sum, t) => sum + t.amount);
    
    // Calculate average daily spending based on current filter
    double averageDaily = 0;
    if (expenses.isNotEmpty) {
      switch (_currentFilter) {
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

    // Find top spending category
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

    // Calculate monthly balance (salary - monthly expenses)
    final monthlyExpenses = _transactions
        .where((t) => t.isExpense && t.isInPeriod(TimeFilter.monthly, _referenceDate))
        .fold<double>(0, (sum, t) => sum + t.amount);
    
    final monthlyBalance = _monthlySalary - monthlyExpenses;

    return AnalyticsSummary(
      totalExpenses: totalExpenses,
      averageDaily: averageDaily,
      topCategory: topCategory,
      monthlyBalance: monthlyBalance,
      totalIncome: _monthlySalary,
      transactionCount: expenses.length,
    );
  }

  /// Get summary statistics for previous period for trend comparison
  AnalyticsSummary? getPreviousPeriodSummary() {
    final previousDate = _getPreviousPeriodDate();
    if (previousDate == null) return null;

    final previousTransactions = _transactions.where((transaction) {
      return transaction.isInPeriod(_currentFilter, previousDate);
    }).toList();

    final expenses = previousTransactions.where((t) => t.isExpense).toList();
    final totalExpenses = expenses.fold<double>(0, (sum, t) => sum + t.amount);
    
    // Calculate average daily spending for previous period
    double averageDaily = 0;
    if (expenses.isNotEmpty) {
      switch (_currentFilter) {
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

    // Find top spending category for previous period
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

    // Calculate previous monthly balance
    final previousMonthlyExpenses = _transactions
        .where((t) => t.isExpense && t.isInPeriod(TimeFilter.monthly, previousDate))
        .fold<double>(0, (sum, t) => sum + t.amount);
    
    final monthlyBalance = _monthlySalary - previousMonthlyExpenses;

    return AnalyticsSummary(
      totalExpenses: totalExpenses,
      averageDaily: averageDaily,
      topCategory: topCategory,
      monthlyBalance: monthlyBalance,
      totalIncome: _monthlySalary,
      transactionCount: expenses.length,
    );
  }

  /// Calculate the reference date for the previous period
  DateTime? _getPreviousPeriodDate() {
    switch (_currentFilter) {
      case TimeFilter.daily:
        return _referenceDate.subtract(const Duration(days: 1));
      case TimeFilter.weekly:
        return _referenceDate.subtract(const Duration(days: 7));
      case TimeFilter.monthly:
        return DateTime(
          _referenceDate.year,
          _referenceDate.month - 1,
          _referenceDate.day,
        );
      case TimeFilter.yearly:
        return DateTime(
          _referenceDate.year - 1,
          _referenceDate.month,
          _referenceDate.day,
        );
    }
  }

  /// Check if there's sufficient data for meaningful statistics
  bool get hasInsufficientData {
    final expenses = filteredTransactions.where((t) => t.isExpense).toList();
    
    // Consider data insufficient if:
    // - No expenses at all
    // - Less than 3 transactions for weekly/monthly/yearly views
    // - Less than 1 transaction for daily view
    switch (_currentFilter) {
      case TimeFilter.daily:
        return expenses.isEmpty;
      case TimeFilter.weekly:
      case TimeFilter.monthly:
      case TimeFilter.yearly:
        return expenses.length < 3;
    }
  }

  /// Get category data with colors and percentages using analytics processor
  List<CategoryData> getCategoryData() {
    final sharedCategoryData = AnalyticsProcessor.processCategoryBreakdown(
      _transactions,
      referenceDate: _referenceDate,
      filter: _currentFilter,
    );
    
    // Convert shared CategoryData to local CategoryData
    return sharedCategoryData.map((data) => CategoryData(
      category: data.category,
      amount: data.amount,
      percentage: data.percentage,
      color: data.color,
    )).toList();
  }

  /// Get current month expenses
  double get currentMonthExpenses {
    try {
      return _transactions
          .where((t) => t.isExpense && t.isInPeriod(TimeFilter.monthly, _referenceDate))
          .fold<double>(0, (sum, t) => sum + t.absoluteAmount);
    } catch (e) {
      return 0.0;
    }
  }

  /// Get expense trend data for charts
  List<ExpenseTrendData> get expenseTrendData {
    try {
      return AnalyticsProcessor.processExpenseTrend(
        filteredTransactions,
        _currentFilter,
      );
    } catch (e) {
      _errorMessage = 'Failed to process expense trend data';
      return [];
    }
  }

  /// Get category breakdown data for pie chart
  List<CategoryData> get categoryBreakdownData {
    try {
      return getCategoryData();
    } catch (e) {
      _errorMessage = 'Failed to process category breakdown data';
      return [];
    }
  }

  /// Get summary statistics
  AnalyticsSummary get summaryStatistics {
    try {
      return getSummaryStatistics();
    } catch (e) {
      _errorMessage = 'Failed to calculate summary statistics';
      return AnalyticsSummary(
        totalExpenses: 0,
        averageDaily: 0,
        topCategory: 'None',
        monthlyBalance: _monthlySalary,
        totalIncome: _monthlySalary,
        transactionCount: 0,
      );
    }
  }

  /// Get previous period summary for trend comparison
  AnalyticsSummary? get previousPeriodSummary {
    try {
      return getPreviousPeriodSummary();
    } catch (e) {
      return null;
    }
  }

  /// Refresh all data
  Future<void> refreshData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _loadTransactions();
      await _loadSalary();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to refresh data: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear any existing error messages
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}