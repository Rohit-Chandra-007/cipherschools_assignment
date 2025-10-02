import 'package:cipherschools_assignment/features/home/models/home_summary.dart';
import 'package:cipherschools_assignment/shared/models/transaction.dart';
import 'package:cipherschools_assignment/data/transaction_data.dart';

/// Repository for home data operations
class HomeRepository {
  Future<List<Transaction>> getTransactions() async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 100));
    return TransactionData.getTransactions();
  }

  Future<HomeSummary> getHomeSummary({String? month}) async {
    final txs = await getTransactions();

    double income = 0;
    double expense = 0;
    
    for (final t in txs) {
      if (t.category.toLowerCase() == 'income') {
        income += t.amount;
      } else if (t.category.toLowerCase() == 'expense') {
        expense += t.amount;
      }
    }

    return HomeSummary(income: income, expense: expense);
  }
}
