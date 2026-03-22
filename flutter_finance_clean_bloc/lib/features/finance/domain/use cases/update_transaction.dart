
import 'package:flutter_finance_clean_bloc/core/use%20cases/usecase.dart';

import '../entities/transaction.dart';
import '../repositories/finance_repository.dart';

class UpdateTransaction implements UseCase<void, FinanceTransaction> {
  final FinanceRepository repository;

  UpdateTransaction(this.repository);

  @override
  Future<void> call(FinanceTransaction transaction) {
    return repository.updateTransaction(transaction);
  }
}
