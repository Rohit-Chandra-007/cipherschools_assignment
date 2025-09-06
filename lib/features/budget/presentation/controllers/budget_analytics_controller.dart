import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cipherschools_assignment/shared/models/transaction.dart';
import 'package:cipherschools_assignment/shared/models/chart_data_models.dart';
import 'package:cipherschools_assignment/shared/services/analytics_processor.dart';
import 'package:cipherschools_assignment/shared/extensions/transaction_analytics.dart';
import 'package:cipherschools_assignment/features/budget/data/services/salary_service.dart';
import 'package:cipherschools_assignment/features/budget/data/services/error_handling_service.dart';
import 'package:cipherschools_assignment/data/transaction_data.dart';

class BudgetAnalyticsController extends ChangeNotifier {
  List<Transaction> _transactions = [];
  TimeFilter _currentFilter = TimeFilter.monthly;
  double _monthlySalary = 0.0;
  DateTime _referenceDate = DateTime.now();

  // Loading and error state
  bool _isLoading = false;
  String? _errorMessage;
  ErrorInfo? _currentError;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  // Getters
  List<Transaction> get transactions => _transactions;
  TimeFilter get currentTimeFilter => _currentFilter;
  double get monthlySalary => _monthlySalary;
  DateTime get referenceDate => _referenceDate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ErrorInfo? get currentError => _currentError;
  bool get canRetry => _retryCount < _maxRetries;

  BudgetAnalyticsController() {
    _initializeData();
  }

  /// Initialize data with proper error handling
  Future<void> _initializeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadTransactions();
      await _loadSalary();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load transactions from data source with comprehensive error handling
  Future<void> _loadTransactions() async {
    try {
      _clearError();

      final loadedTransactions =
          await ErrorHandlingService.retryOperation<List<Transaction>>(
            () => Future.value(TransactionData.getTransactions()),
            maxRetries: _maxRetries,
          );

      if (loadedTransactions != null) {
        _transactions = loadedTransactions;
        _validateTransactionData();
      } else {
        _handleError(ErrorType.dataLoadingFailure);
      }
    } catch (e) {
      _handleError(
        ErrorType.dataLoadingFailure,
        technicalDetails: e.toString(),
      );
    }
    notifyListeners();
  }

  /// Validate loaded transaction data
  void _validateTransactionData() {
    if (_transactions.isEmpty) {
      _handleError(ErrorType.noData);
      return;
    }

    // Check for data integrity issues
    final invalidTransactions =
        _transactions
            .where(
              (t) =>
                  !ErrorHandlingService.isValidAmount(t.amount) ||
                  t.dateTime.isAfter(
                    DateTime.now().add(const Duration(days: 1)),
                  ),
            )
            .toList();

    if (invalidTransactions.isNotEmpty) {
      debugPrint('Found ${invalidTransactions.length} invalid transactions');
      // Remove invalid transactions but continue
      _transactions.removeWhere((t) => invalidTransactions.contains(t));
    }
  }

  /// Load salary from local storage with error handling
  Future<void> _loadSalary() async {
    try {
      final salary = await ErrorHandlingService.retryOperation(
        () => SalaryService.getMonthlySalary(),
        maxRetries: 2, // Fewer retries for salary as it's less critical
      );

      if (salary != null && ErrorHandlingService.isValidAmount(salary)) {
        _monthlySalary = salary;
      } else {
        _monthlySalary = 0.0;
        debugPrint('Invalid salary data loaded, defaulting to 0');
      }
    } catch (e) {
      _monthlySalary = 0.0;
      debugPrint('Failed to load salary: ${e.toString()}');
      // Don't show error for salary loading failure as it's not critical
    }
    notifyListeners();
  }

  /// Update the current time filter with validation
  void updateTimeFilter(TimeFilter filter) {
    try {
      if (_currentFilter != filter) {
        _currentFilter = filter;

        // Validate the new filter's date range
        if (!_isValidDateRange()) {
          _handleError(
            ErrorType.invalidDateRange,
            customMessage: 'Selected time period contains no valid data',
          );
          return;
        }

        _clearError();
        notifyListeners();
      }
    } catch (e) {
      _handleError(
        ErrorType.calculationError,
        technicalDetails: 'Filter update failed: ${e.toString()}',
      );
    }
  }

  /// Update time filter with animation support
  Future<void> updateTimeFilterAnimated(TimeFilter filter) async {
    try {
      if (_currentFilter != filter) {
        // Set loading state for smooth transition
        _isLoading = true;
        notifyListeners();

        // Small delay to show loading state
        await Future.delayed(const Duration(milliseconds: 100));

        _currentFilter = filter;
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to update time filter: ${e.toString()}';
      _isLoading = false;
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
        categoryTotals[category] =
            (categoryTotals[category] ?? 0) + expense.amount;
      }

      if (categoryTotals.isNotEmpty) {
        topCategory =
            categoryTotals.entries
                .reduce((a, b) => a.value > b.value ? a : b)
                .key;
      }
    }

    // Calculate monthly balance (salary - monthly expenses)
    final monthlyExpenses = _transactions
        .where(
          (t) =>
              t.isExpense && t.isInPeriod(TimeFilter.monthly, _referenceDate),
        )
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

    final previousTransactions =
        _transactions.where((transaction) {
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
        categoryTotals[category] =
            (categoryTotals[category] ?? 0) + expense.amount;
      }

      if (categoryTotals.isNotEmpty) {
        topCategory =
            categoryTotals.entries
                .reduce((a, b) => a.value > b.value ? a : b)
                .key;
      }
    }

    // Calculate previous monthly balance
    final previousMonthlyExpenses = _transactions
        .where(
          (t) => t.isExpense && t.isInPeriod(TimeFilter.monthly, previousDate),
        )
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
    return sharedCategoryData
        .map(
          (data) => CategoryData(
            category: data.category,
            amount: data.amount,
            percentage: data.percentage,
            color: data.color,
          ),
        )
        .toList();
  }

  /// Get current month expenses
  double get currentMonthExpenses {
    try {
      return _transactions
          .where(
            (t) =>
                t.isExpense && t.isInPeriod(TimeFilter.monthly, _referenceDate),
          )
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
      await _loadTransactions();
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
    if (_errorMessage != null || _currentError != null) {
      _errorMessage = null;
      _currentError = null;
      _retryCount = 0;
      notifyListeners();
    }
  }

  /// Handle errors with comprehensive error information
  void _handleError(
    ErrorType errorType, {
    String? customMessage,
    String? technicalDetails,
  }) {
    _currentError = ErrorHandlingService.getErrorInfo(
      errorType,
      customMessage: customMessage,
      technicalDetails: technicalDetails,
      retryAction:
          _canRetryForErrorType(errorType) ? () => _retryLastOperation() : null,
      alternativeAction: _getAlternativeActionForErrorType(errorType),
    );

    _errorMessage = _currentError!.message;
  }

  /// Clear error state
  void _clearError() {
    _errorMessage = null;
    _currentError = null;
  }

  /// Check if retry is available for error type
  bool _canRetryForErrorType(ErrorType errorType) {
    return errorType == ErrorType.dataLoadingFailure ||
        errorType == ErrorType.networkError ||
        errorType == ErrorType.calculationError;
  }

  /// Get alternative action for error type
  VoidCallback? _getAlternativeActionForErrorType(ErrorType errorType) {
    switch (errorType) {
      case ErrorType.noData:
        return null; // Will be handled by UI navigation
      case ErrorType.invalidDateRange:
        return () => _resetToDefaultFilter();
      case ErrorType.dataLoadingFailure:
        return () => _loadSampleData();
      default:
        return null;
    }
  }

  /// Retry the last failed operation
  Future<void> _retryLastOperation() async {
    if (_retryCount >= _maxRetries) return;

    _retryCount++;
    _isLoading = true;
    _clearError();
    notifyListeners();

    try {
      await _loadTransactions();
      await _loadSalary();
      _retryCount = 0; // Reset on success
    } catch (e) {
      _handleError(
        ErrorType.dataLoadingFailure,
        technicalDetails: 'Retry attempt $_retryCount: ${e.toString()}',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reset to default filter when date range is invalid
  void _resetToDefaultFilter() {
    _currentFilter = TimeFilter.monthly;
    _referenceDate = DateTime.now();
    _clearError();
    notifyListeners();
  }

  /// Load sample data as fallback
  void _loadSampleData() {
    // This would typically load some sample/demo data
    // For now, just clear the error and show empty state
    _transactions = [];
    _clearError();
    notifyListeners();
  }

  /// Validate date range for current filter
  bool _isValidDateRange() {
    final now = DateTime.now();
    DateTime startDate;

    switch (_currentFilter) {
      case TimeFilter.daily:
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case TimeFilter.weekly:
        startDate = now.subtract(const Duration(days: 7));
        break;
      case TimeFilter.monthly:
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case TimeFilter.yearly:
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
    }

    return ErrorHandlingService.isValidDateRange(startDate, now);
  }
}
