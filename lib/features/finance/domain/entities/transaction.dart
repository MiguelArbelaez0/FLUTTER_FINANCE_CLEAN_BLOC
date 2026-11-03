import '../../../../core/utils/money.dart';
import '../../../../core/utils/enums.dart';

class FinanceTransaction {
  final String id;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;
  final String? description;

  FinanceTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.description,
  }) {
    if (id.trim().isEmpty ||
        category.trim().isEmpty ||
        !amount.isFinite ||
        amount <= 0 ||
        amount > Money.maxAmount) {
      throw ArgumentError('Movimiento inválido');
    }
  }

  int get amountCents => Money.cents(amount);
}
