
import 'package:flutter_finance_clean_bloc/core/use%20cases/usecase.dart';

import '../repositories/finance_repository.dart';

class DeleteTransaction implements UseCase<void, String> {
  final FinanceRepository repository;

  DeleteTransaction(this.repository);

  @override
  Future<void> call(String id) {
    return repository.deleteTransaction(id);
  }
}
