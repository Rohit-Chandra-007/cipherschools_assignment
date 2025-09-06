import 'package:flutter/material.dart';
import '../../models/chart_data_models.dart';
import '../../extensions/transaction_analytics.dart';
import 'expense_trend_chart.dart';

/// Demo widget to test ExpenseTrendChart functionality
class ExpenseTrendChartDemo extends StatefulWidget {
  const ExpenseTrendChartDemo({super.key});

  @override
  State<ExpenseTrendChartDemo> createState() => _ExpenseTrendChartDemoState();
}

class _ExpenseTrendChartDemoState extends State<ExpenseTrendChartDemo> {
  TimeFilter _currentFilter = TimeFilter.weekly;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Trend Chart Demo'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildFilterTabs(),
            const SizedBox(height: 16),
            _buildControlButtons(),
            const SizedBox(height: 16),
            Expanded(
              child: ExpenseTrendChart(
                data: _generateSampleData(),
                timeFilter: _currentFilter,
                isLoading: _isLoading,
                errorMessage: _errorMessage,
                onEmptyStateAction: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add Transaction tapped!')),
                  );
                },
                onRetry: () {
                  setState(() {
                    _errorMessage = null;
                    _isLoading = true;
                  });
                  
                  // Simulate loading
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Row(
      children: TimeFilter.values.map((filter) {
        final isSelected = filter == _currentFilter;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _currentFilter = filter),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.purple : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                filter.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () => setState(() => _isLoading = !_isLoading),
          child: Text(_isLoading ? 'Stop Loading' : 'Show Loading'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => setState(() {
            _errorMessage = _errorMessage == null 
                ? 'Network connection failed. Please check your internet connection and try again.'
                : null;
          }),
          child: Text(_errorMessage == null ? 'Show Error' : 'Clear Error'),
        ),
      ],
    );
  }

  List<ExpenseTrendData> _generateSampleData() {
    if (_isLoading || _errorMessage != null) {
      return [];
    }

    final now = DateTime.now();
    final data = <ExpenseTrendData>[];

    switch (_currentFilter) {
      case TimeFilter.daily:
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          data.add(ExpenseTrendData(
            date: date,
            amount: 50 + (i * 25) + (i % 3 * 30),
            label: '${date.day}/${date.month}',
          ));
        }
        break;
      case TimeFilter.weekly:
        for (int i = 3; i >= 0; i--) {
          final date = now.subtract(Duration(days: i * 7));
          data.add(ExpenseTrendData(
            date: date,
            amount: 200 + (i * 150) + (i % 2 * 100),
            label: 'Week ${4 - i}',
          ));
        }
        break;
      case TimeFilter.monthly:
        const months = ['Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan'];
        for (int i = 5; i >= 0; i--) {
          final date = DateTime(now.year, now.month - i);
          data.add(ExpenseTrendData(
            date: date,
            amount: 800 + (i * 200) + (i % 4 * 300),
            label: months[5 - i],
          ));
        }
        break;
      case TimeFilter.yearly:
        for (int i = 2; i >= 0; i--) {
          final date = DateTime(now.year - i);
          data.add(ExpenseTrendData(
            date: date,
            amount: 10000 + (i * 2000) + (i % 2 * 1500),
            label: date.year.toString(),
          ));
        }
        break;
    }

    return data;
  }
}