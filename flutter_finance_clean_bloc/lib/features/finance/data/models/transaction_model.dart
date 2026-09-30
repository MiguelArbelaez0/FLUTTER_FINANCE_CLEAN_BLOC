import '../../../../core/utils/enums.dart';
import '../../domain/entities/transaction.dart';

final class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.description,
  });
  final String id;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;
  final String? description;
  factory TransactionModel.fromEntity(FinanceTransaction entity) =>
      TransactionModel(
        id: entity.id,
        amount: entity.amount,
        type: entity.type,
        category: entity.category,
        date: entity.date,
        description: entity.description,
      );
  FinanceTransaction toEntity() => FinanceTransaction(
    id: id,
    amount: amount,
    type: type,
    category: category,
    date: date,
    description: description,
  );
  factory TransactionModel.fromMap(Map<dynamic, dynamic> map) =>
      TransactionModel(
        id: map['id'] as String,
        amount: (map['amount'] as num).toDouble(),
        type: TransactionType.values.byName(map['type'] as String),
        category: map['category'] as String,
        date: DateTime.parse(map['date'] as String),
        description: map['description'] as String?,
      );
  Map<String, dynamic> toMap() => {
    'id': id,
    'amount': amount,
    'type': type.name,
    'category': category,
    'date': date.toIso8601String(),
    'description': description,
  };
}
