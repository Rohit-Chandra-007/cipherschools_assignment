/// Model representing home summary data
class HomeSummary {
  final double income;
  final double expense;
  final double balance;

  const HomeSummary({
    required this.income,
    required this.expense,
  }) : balance = income - expense;

  HomeSummary copyWith({
    double? income,
    double? expense,
  }) {
    return HomeSummary(
      income: income ?? this.income,
      expense: expense ?? this.expense,
    );
  }
}
