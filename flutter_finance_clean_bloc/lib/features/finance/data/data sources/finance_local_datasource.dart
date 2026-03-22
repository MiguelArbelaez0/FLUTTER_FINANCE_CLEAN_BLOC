import 'package:flutter_finance_clean_bloc/core/utils/local_database_service.dart';
import 'package:hive/hive.dart';


import '../../../../core/utils/constants.dart';
import '../models/transaction_model.dart';
import '../../domain/entities/transaction.dart';

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
    return box.values
        .map((e) => TransactionModel.fromMap(Map.from(e)))
        .toList();
  }

  @override
  Future<void> addTransaction(FinanceTransaction transaction) async {
    final box = await _box();
    await box.put(transaction.id, TransactionModel.toMap(transaction));
  }

  @override
  Future<void> updateTransaction(FinanceTransaction transaction) async {
    final box = await _box();
    await box.put(transaction.id, TransactionModel.toMap(transaction));
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final box = await _box();
    await box.delete(id);
  }
}
