import 'package:flutter_finance_clean_bloc/core/utils/enums.dart';
import 'package:flutter_finance_clean_bloc/features/finance/data/models/transaction_model.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps entity to storage and back without losing values', () {
    final entity = FinanceTransaction(
      id: 'tx-1',
      amount: 42.5,
      type: TransactionType.expense,
      category: 'Alimentación',
      date: DateTime(2026, 8, 12),
      description: 'Mercado',
    );
    final model = TransactionModel.fromMap(
      TransactionModel.fromEntity(entity).toMap(),
    );
    expect(model.toEntity().id, entity.id);
    expect(model.amount, entity.amount);
    expect(model.type, entity.type);
    expect(model.category, entity.category);
    expect(model.date, entity.date);
    expect(model.description, entity.description);
  });
}
