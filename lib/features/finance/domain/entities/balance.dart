import '../../../../core/utils/money.dart';

class Balance {
  final double totalIncome;
  final double totalExpense;

  Balance({required this.totalIncome, required this.totalExpense});

  double get total =>
      (Money.cents(totalIncome) - Money.cents(totalExpense)) / 100;
}
