import 'package:flutter/material.dart';

/// Error types for different scenarios
enum ErrorType {
  noData,
  invalidDateRange,
  dataLoadingFailure,
  chartRenderingFailure,
  networkError,
  storageError,
  calculationError,
}

/// Error severity levels
enum ErrorSeverity {
  low,    // User can continue with limited functionality
  medium, // Some features may not work properly
  high,   // Critical error, major functionality affected
}

/// Error information container
class ErrorInfo {
  final ErrorType type;
  final ErrorSeverity severity;
  final String message;
  final String? technicalDetails;
  final VoidCallback? retryAction;
  final VoidCallback? alternativeAction;
  final String? alternativeActionLabel;

  const ErrorInfo({
    required this.type,
    required this.severity,
    required this.message,
    this.technicalDetails,
    this.retryAction,
    this.alternativeAction,
    this.alternativeActionLabel,
  });
}

/// Comprehensive error handling service for budget analytics
class ErrorHandlingService {

  /// Get user-friendly error information based on error type
  static ErrorInfo getErrorInfo(ErrorType type, {
    String? customMessage,
    String? technicalDetails,
    VoidCallback? retryAction,
    VoidCallback? alternativeAction,
    String? alternativeActionLabel,
  }) {
    switch (type) {
      case ErrorType.noData:
        return ErrorInfo(
          type: type,
          severity: ErrorSeverity.low,
          message: customMessage ?? 'No transaction data available',
          technicalDetails: technicalDetails,
          retryAction: retryAction,
          alternativeAction: alternativeAction,
          alternativeActionLabel: alternativeActionLabel ?? 'Add Transaction',
        );

      case ErrorType.invalidDateRange:
        return ErrorInfo(
          type: type,
          severity: ErrorSeverity.medium,
          message: customMessage ?? 'Invalid date range selected',
          technicalDetails: technicalDetails ?? 'The selected date range contains no valid data points',
          retryAction: retryAction,
          alternativeAction: alternativeAction,
          alternativeActionLabel: alternativeActionLabel ?? 'Reset Filter',
        );

      case ErrorType.dataLoadingFailure:
        return ErrorInfo(
          type: type,
          severity: ErrorSeverity.high,
          message: customMessage ?? 'Failed to load transaction data',
          technicalDetails: technicalDetails ?? 'Unable to retrieve data from storage',
          retryAction: retryAction,
          alternativeAction: alternativeAction,
          alternativeActionLabel: alternativeActionLabel ?? 'Refresh',
        );

      case ErrorType.chartRenderingFailure:
        return ErrorInfo(
          type: type,
          severity: ErrorSeverity.medium,
          message: customMessage ?? 'Unable to display chart',
          technicalDetails: technicalDetails ?? 'Chart rendering encountered an error',
          retryAction: retryAction,
          alternativeAction: alternativeAction,
          alternativeActionLabel: alternativeActionLabel ?? 'View Data Table',
        );

      case ErrorType.networkError:
        return ErrorInfo(
          type: type,
          severity: ErrorSeverity.medium,
          message: customMessage ?? 'Network connection error',
          technicalDetails: technicalDetails ?? 'Unable to sync data with server',
          retryAction: retryAction,
          alternativeAction: alternativeAction,
          alternativeActionLabel: alternativeActionLabel ?? 'Work Offline',
        );

      case ErrorType.storageError:
        return ErrorInfo(
          type: type,
          severity: ErrorSeverity.high,
          message: customMessage ?? 'Storage access error',
          technicalDetails: technicalDetails ?? 'Unable to read or write local data',
          retryAction: retryAction,
          alternativeAction: alternativeAction,
          alternativeActionLabel: alternativeActionLabel ?? 'Clear Cache',
        );

      case ErrorType.calculationError:
        return ErrorInfo(
          type: type,
          severity: ErrorSeverity.medium,
          message: customMessage ?? 'Calculation error occurred',
          technicalDetails: technicalDetails ?? 'Unable to process financial calculations',
          retryAction: retryAction,
          alternativeAction: alternativeAction,
          alternativeActionLabel: alternativeActionLabel ?? 'Recalculate',
        );
    }
  }

  /// Validate date range for given time filter
  static bool isValidDateRange(DateTime startDate, DateTime endDate) {
    if (startDate.isAfter(endDate)) return false;
    if (startDate.isAfter(DateTime.now())) return false;
    
    final difference = endDate.difference(startDate).inDays;
    
    // Reasonable limits for different time ranges
    if (difference > 1095) return false; // Max 3 years
    if (difference < 0) return false;
    
    return true;
  }

  /// Check if transaction data is sufficient for analytics
  static bool hasSufficientData(List<dynamic> transactions, {int minRequired = 1}) {
    return transactions.isNotEmpty && transactions.length >= minRequired;
  }

  /// Validate numeric values for calculations
  static bool isValidAmount(double? amount) {
    if (amount == null) return false;
    if (amount.isNaN || amount.isInfinite) return false;
    if (amount < 0) return false; // Assuming amounts should be positive
    return true;
  }

  /// Handle retry mechanism with exponential backoff
  static Future<T?> retryOperation<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(milliseconds: 500),
  }) async {
    int attempts = 0;
    Duration delay = initialDelay;

    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          rethrow;
        }
        
        await Future.delayed(delay);
        delay = Duration(milliseconds: (delay.inMilliseconds * 1.5).round());
      }
    }
    
    return null;
  }

  /// Get recovery suggestions based on error type
  static List<String> getRecoverySuggestions(ErrorType type) {
    switch (type) {
      case ErrorType.noData:
        return [
          'Add some transactions to see analytics',
          'Import data from another source',
          'Check if you have transactions in other time periods',
        ];

      case ErrorType.invalidDateRange:
        return [
          'Select a different time period',
          'Check if you have data in the selected range',
          'Try switching to a broader time filter',
        ];

      case ErrorType.dataLoadingFailure:
        return [
          'Check your internet connection',
          'Restart the app',
          'Clear app cache and try again',
        ];

      case ErrorType.chartRenderingFailure:
        return [
          'Try switching to a different chart view',
          'Reduce the amount of data being displayed',
          'Update the app to the latest version',
        ];

      case ErrorType.networkError:
        return [
          'Check your internet connection',
          'Try again in a few moments',
          'Switch to offline mode',
        ];

      case ErrorType.storageError:
        return [
          'Free up device storage space',
          'Restart the app',
          'Clear app data (will lose local data)',
        ];

      case ErrorType.calculationError:
        return [
          'Check if your transaction data is valid',
          'Try refreshing the data',
          'Contact support if the problem persists',
        ];
    }
  }
}