import '../entities/transaction.dart';

abstract class FinanceRepository {
  Future<List<FinanceTransaction>> getTransactions();
  Future<void> addTransaction(FinanceTransaction transaction);
  Future<void> updateTransaction(FinanceTransaction transaction);
  Future<void> deleteTransaction(String id);
}
