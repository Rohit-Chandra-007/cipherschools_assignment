import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cipherschools_assignment/core/theme/app_colors.dart';

class SalaryInputDialog extends StatefulWidget {
  final double? currentSalary;
  final Function(double) onSalaryUpdated;

  const SalaryInputDialog({
    super.key,
    this.currentSalary,
    required this.onSalaryUpdated,
  });

  @override
  State<SalaryInputDialog> createState() => _SalaryInputDialogState();
}

class _SalaryInputDialogState extends State<SalaryInputDialog> {
  late TextEditingController _salaryController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _salaryController = TextEditingController(
      text: widget.currentSalary != null && widget.currentSalary! > 0
          ? widget.currentSalary!.toStringAsFixed(0)
          : '',
    );
  }

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildSalaryInput(context),
              const SizedBox(height: 24),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.currentSalary != null && widget.currentSalary! > 0
                  ? 'Edit Monthly Salary'
                  : 'Add Monthly Salary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.dark100,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.close,
                color: AppColors.dark75,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your monthly salary to track your income vs expenses',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.dark75,
          ),
        ),
      ],
    );
  }

  Widget _buildSalaryInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Salary',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.dark100,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _salaryController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10), // Limit to reasonable salary amounts
          ],
          decoration: InputDecoration(
            hintText: 'Enter your monthly salary',
            prefixText: '₹ ',
            prefixStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.dark100,
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.dark25),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.violet100, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.red100, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.red100, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.dark100,
          ),
          validator: _validateSalary,
          autofocus: true,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.violet100),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.violet100,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.violet100,
              foregroundColor: AppColors.light100,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.light100,
                      ),
                    ),
                  )
                : Text(
                    'Save',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.light100,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  String? _validateSalary(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your monthly salary';
    }

    final salary = double.tryParse(value.trim());
    if (salary == null) {
      return 'Please enter a valid amount';
    }

    if (salary <= 0) {
      return 'Salary must be greater than 0';
    }

    if (salary > 10000000) {
      // 1 crore limit for reasonable validation
      return 'Please enter a reasonable salary amount';
    }

    return null;
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final salary = double.parse(_salaryController.text.trim());
      
      // Simulate a brief delay for better UX
      await Future.delayed(const Duration(milliseconds: 300));
      
      widget.onSalaryUpdated(salary);
      
      if (mounted) {
        Navigator.of(context).pop();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Monthly salary updated successfully',
              style: TextStyle(color: AppColors.light100),
            ),
            backgroundColor: AppColors.green100,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update salary. Please try again.',
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}