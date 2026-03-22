import 'package:flutter_finance_clean_bloc/features/finance/data/data%20sources/finance_local_datasource.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/repositories/finance_repository.dart';


class FinanceRepositoryImpl implements FinanceRepository {
  final FinanceLocalDatasource datasource;

  FinanceRepositoryImpl(this.datasource);

  @override
  Future<List<FinanceTransaction>> getTransactions() {
    return datasource.getTransactions();
  }

  @override
  Future<void> addTransaction(FinanceTransaction transaction) {
    return datasource.addTransaction(transaction);
  }

  @override
  Future<void> updateTransaction(FinanceTransaction transaction) {
    return datasource.updateTransaction(transaction);
  }

  @override
  Future<void> deleteTransaction(String id) {
    return datasource.deleteTransaction(id);
  }
}
