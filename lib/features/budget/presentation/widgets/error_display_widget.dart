import 'package:flutter/material.dart';
import 'package:cipherschools_assignment/core/theme/app_colors.dart';
import 'package:cipherschools_assignment/features/budget/data/services/error_handling_service.dart';

/// Comprehensive error display widget with recovery options
class ErrorDisplayWidget extends StatelessWidget {
  final ErrorInfo errorInfo;
  final VoidCallback? onDismiss;
  final bool showTechnicalDetails;

  const ErrorDisplayWidget({
    super.key,
    required this.errorInfo,
    this.onDismiss,
    this.showTechnicalDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getBorderColor(), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 12),
          _buildMessage(context),
          if (showTechnicalDetails && errorInfo.technicalDetails != null) ...[
            const SizedBox(height: 8),
            _buildTechnicalDetails(context),
          ],
          const SizedBox(height: 16),
          _buildRecoverySuggestions(context),
          if (errorInfo.retryAction != null ||
              errorInfo.alternativeAction != null) ...[
            const SizedBox(height: 16),
            _buildActionButtons(context),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(_getErrorIcon(), color: _getIconColor(), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            _getErrorTitle(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.dark100,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (onDismiss != null)
          IconButton(
            onPressed: onDismiss,
            icon: Icon(Icons.close, color: AppColors.dark75, size: 20),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
      ],
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Text(
      errorInfo.message,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: AppColors.dark75),
    );
  }

  Widget _buildTechnicalDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.light20,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Technical Details:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.dark75,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            errorInfo.technicalDetails!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.dark50,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecoverySuggestions(BuildContext context) {
    final suggestions = ErrorHandlingService.getRecoverySuggestions(
      errorInfo.type,
    );

    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggestions:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.dark75,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...suggestions
            .take(3)
            .map(
              (suggestion) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.dark50,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        suggestion,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.dark50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        if (errorInfo.retryAction != null) ...[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: errorInfo.retryAction,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getActionButtonColor(),
                foregroundColor: AppColors.light100,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(44, 44),
              ),
            ),
          ),
          if (errorInfo.alternativeAction != null) const SizedBox(width: 12),
        ],
        if (errorInfo.alternativeAction != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: errorInfo.alternativeAction,
              icon: const Icon(Icons.settings_backup_restore, size: 18),
              label: Text(errorInfo.alternativeActionLabel ?? 'Alternative'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _getActionButtonColor(),
                side: BorderSide(color: _getActionButtonColor()),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(44, 44),
              ),
            ),
          ),
      ],
    );
  }

  Color _getBackgroundColor() {
    switch (errorInfo.severity) {
      case ErrorSeverity.low:
        return AppColors.blue20;
      case ErrorSeverity.medium:
        return AppColors.yellow20;
      case ErrorSeverity.high:
        return AppColors.red20;
    }
  }

  Color _getBorderColor() {
    switch (errorInfo.severity) {
      case ErrorSeverity.low:
        return AppColors.blue100;
      case ErrorSeverity.medium:
        return AppColors.yellow100;
      case ErrorSeverity.high:
        return AppColors.red100;
    }
  }

  Color _getIconColor() {
    return _getBorderColor();
  }

  Color _getActionButtonColor() {
    return _getBorderColor();
  }

  IconData _getErrorIcon() {
    switch (errorInfo.type) {
      case ErrorType.noData:
        return Icons.inbox_outlined;
      case ErrorType.invalidDateRange:
        return Icons.date_range_outlined;
      case ErrorType.dataLoadingFailure:
        return Icons.cloud_off_outlined;
      case ErrorType.chartRenderingFailure:
        return Icons.bar_chart_outlined;
      case ErrorType.networkError:
        return Icons.wifi_off_outlined;
      case ErrorType.storageError:
        return Icons.storage_outlined;
      case ErrorType.calculationError:
        return Icons.calculate_outlined;
    }
  }

  String _getErrorTitle() {
    switch (errorInfo.type) {
      case ErrorType.noData:
        return 'No Data Available';
      case ErrorType.invalidDateRange:
        return 'Invalid Date Range';
      case ErrorType.dataLoadingFailure:
        return 'Data Loading Failed';
      case ErrorType.chartRenderingFailure:
        return 'Chart Display Error';
      case ErrorType.networkError:
        return 'Network Error';
      case ErrorType.storageError:
        return 'Storage Error';
      case ErrorType.calculationError:
        return 'Calculation Error';
    }
  }
}
