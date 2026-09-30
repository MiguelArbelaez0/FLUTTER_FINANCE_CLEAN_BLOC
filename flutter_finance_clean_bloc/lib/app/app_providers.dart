import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/database/local_database_service.dart';
import '../features/finance/data/data_sources/finance_local_datasource.dart';
import '../features/finance/data/repositories/finance_repository_impl.dart';
import '../features/finance/domain/repositories/finance_repository.dart';
import '../features/finance/domain/use_cases/add_transaction.dart';
import '../features/finance/domain/use_cases/calculate_balance.dart';
import '../features/finance/domain/use_cases/delete_transaction.dart';
import '../features/finance/domain/use_cases/get_transactions.dart';
import '../features/finance/domain/use_cases/update_transaction.dart';
import '../features/finance/presentation/bloc/finance_bloc.dart';
import '../features/finance/presentation/bloc/finance_event.dart';

final class AppProviders extends StatelessWidget {
  const AppProviders({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final FinanceRepository repository = FinanceRepositoryImpl(
      FinanceLocalDatasourceImpl(LocalDatabaseService.instance),
    );
    return BlocProvider(
      create: (_) => FinanceBloc(
        getTransactions: GetTransactions(repository),
        addTransaction: AddTransaction(repository),
        updateTransaction: UpdateTransaction(repository),
        deleteTransaction: DeleteTransaction(repository),
        calculateBalance: CalculateBalance(),
      )..add(LoadTransactionsEvent()),
      child: child,
    );
  }
}
