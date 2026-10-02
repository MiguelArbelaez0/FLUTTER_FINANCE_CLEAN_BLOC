import '../../domain/entities/transaction.dart';
import '../../../../core/utils/enums.dart';

class TransactionModel {
  static Map<String, dynamic> toMap(FinanceTransaction transaction) {
    return {
      'id': transaction.id,
      'amount': transaction.amount,
      'type': transaction.type.name,
      'category': transaction.category,
      'date': transaction.date.toIso8601String(),
      'description': transaction.description,
    };
  }

  static FinanceTransaction fromMap(Map data) {
    return FinanceTransaction(
      id: data['id'],
      amount: data['amount'],
      type: TransactionType.values.firstWhere(
        (e) => e.name == data['type'],
      ),
      category: data['category'],
      date: DateTime.parse(data['date']),
      description: data['description'],
    );
  }
}
