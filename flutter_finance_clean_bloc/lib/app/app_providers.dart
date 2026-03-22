import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finance_clean_bloc/core/utils/local_database_service.dart';
import 'package:flutter_finance_clean_bloc/features/finance/data/data%20sources/finance_local_datasource.dart';
import 'package:flutter_finance_clean_bloc/features/finance/data/repositories/finance_repository_impl.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use%20cases/add_transaction.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use%20cases/delete_transaction.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use%20cases/get_transactions.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use%20cases/update_transaction.dart';
import 'package:flutter_finance_clean_bloc/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:flutter_finance_clean_bloc/features/finance/presentation/bloc/finance_event.dart';



class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final databaseService = LocalDatabaseService();
    final datasource = FinanceLocalDatasourceImpl(databaseService);
    final repository = FinanceRepositoryImpl(datasource);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => FinanceBloc(
            getTransactions: GetTransactions(repository),
            addTransaction: AddTransaction(repository),
            updateTransaction: UpdateTransaction(repository),
            deleteTransaction: DeleteTransaction(repository),
          )..add(LoadTransactionsEvent()),
        ),
      ],
      child: child,
    );
  }
}
