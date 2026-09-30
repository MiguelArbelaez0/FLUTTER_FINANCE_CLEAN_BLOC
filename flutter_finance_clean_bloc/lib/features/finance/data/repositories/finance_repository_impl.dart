import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/finance_repository.dart';
import '../data_sources/finance_local_datasource.dart';
import '../models/transaction_model.dart';

final class FinanceRepositoryImpl implements FinanceRepository {
  FinanceRepositoryImpl(this.datasource);
  final FinanceLocalDatasource datasource;
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on CacheException {
      throw const CacheFailure();
    } catch (_) {
      throw const CacheFailure();
    }
  }

  @override
  Future<List<FinanceTransaction>> getTransactions() => _guard(
    () async => (await datasource.getTransactions())
        .map((model) => model.toEntity())
        .toList(),
  );
  @override
  Future<void> addTransaction(FinanceTransaction transaction) => _guard(
    () => datasource.addTransaction(TransactionModel.fromEntity(transaction)),
  );
  @override
  Future<void> updateTransaction(FinanceTransaction transaction) => _guard(
    () =>
        datasource.updateTransaction(TransactionModel.fromEntity(transaction)),
  );
  @override
  Future<void> deleteTransaction(String id) =>
      _guard(() => datasource.deleteTransaction(id));
}
