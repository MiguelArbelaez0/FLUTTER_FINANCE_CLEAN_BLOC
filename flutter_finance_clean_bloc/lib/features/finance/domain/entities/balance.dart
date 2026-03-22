class Balance {
  final double totalIncome;
  final double totalExpense;

  Balance({
    required this.totalIncome,
    required this.totalExpense,
  });

  double get total => totalIncome - totalExpense;
}
