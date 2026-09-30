import '../../../../core/database/local_database_service.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/transaction_model.dart';

abstract interface class FinanceLocalDatasource {
  Future<List<TransactionModel>> getTransactions();
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
}

final class FinanceLocalDatasourceImpl implements FinanceLocalDatasource {
  FinanceLocalDatasourceImpl(this.database);
  final LocalDatabaseService database;
  @override
  Future<List<TransactionModel>> getTransactions() async {
    try {
      return database.transactions.values
          .map(TransactionModel.fromMap)
          .toList();
    } catch (error) {
      throw CacheException(error.toString());
    }
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await database.transactions.put(transaction.id, transaction.toMap());
    } catch (error) {
      throw CacheException(error.toString());
    }
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) =>
      addTransaction(transaction);
  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await database.transactions.delete(id);
    } catch (error) {
      throw CacheException(error.toString());
    }
  }
}
