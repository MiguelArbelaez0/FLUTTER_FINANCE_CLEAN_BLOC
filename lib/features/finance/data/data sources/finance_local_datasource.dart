import 'package:flutter_finance_clean_bloc/core/utils/local_database_service.dart';
import 'package:hive/hive.dart';

import '../../../../core/utils/constants.dart';
import '../models/transaction_model.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/entities/transaction.dart';

abstract class FinanceLocalDatasource {
  Future<List<FinanceTransaction>> getTransactions();
  Future<void> addTransaction(FinanceTransaction transaction);
  Future<void> updateTransaction(FinanceTransaction transaction);
  Future<void> deleteTransaction(String id);
}

class FinanceLocalDatasourceImpl implements FinanceLocalDatasource {
  final LocalDatabaseService databaseService;

  FinanceLocalDatasourceImpl(this.databaseService);

  Future<Box> _box() async {
    return await databaseService.openBox(transactionsBox);
  }

  @override
  Future<List<FinanceTransaction>> getTransactions() async {
    final box = await _box();
    try {
      return box.toMap().entries.map((entry) {
        final transaction = TransactionModel.fromMap(Map.from(entry.value));
        if (transaction.id != entry.key) {
          throw const FormatException('Identificador inconsistente');
        }
        return transaction;
      }).toList();
    } catch (_) {
      // Preserve the original records: never silently discard financial data.
      throw const FormatException(
        'Hay movimientos inválidos en el almacenamiento local',
      );
    }
  }

  @override
  Future<void> addTransaction(FinanceTransaction transaction) async {
    _validateAmount(transaction);
    final box = await _box();
    if (box.containsKey(transaction.id)) {
      throw StateError('El movimiento ya existe');
    }
    await box.put(transaction.id, TransactionModel.toMap(transaction));
  }

  @override
  Future<void> updateTransaction(FinanceTransaction transaction) async {
    _validateAmount(transaction);
    final box = await _box();
    if (!box.containsKey(transaction.id)) {
      throw StateError('El movimiento no existe');
    }
    await box.put(transaction.id, TransactionModel.toMap(transaction));
  }

  void _validateAmount(FinanceTransaction transaction) {
    if ((transaction.amount * 100 - transaction.amountCents).abs() > 0.00001) {
      throw ArgumentError('El monto admite como máximo dos decimales');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final box = await _box();
    await box.delete(id);
  }
}
