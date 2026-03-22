
import 'package:flutter_finance_clean_bloc/core/use%20cases/usecase.dart';

import '../entities/transaction.dart';
import '../repositories/finance_repository.dart';

class GetTransactions implements UseCase<List<FinanceTransaction>, NoParams> {
  final FinanceRepository repository;

  GetTransactions(this.repository);

  @override
  Future<List<FinanceTransaction>> call(NoParams params) {
    return repository.getTransactions();
  }
}
