import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finance_clean_bloc/core/use%20cases/usecase.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/entities/transaction.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use%20cases/add_transaction.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use%20cases/delete_transaction.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use%20cases/get_transactions.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use%20cases/update_transaction.dart';


import 'finance_event.dart';
import 'finance_state.dart';


class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  final GetTransactions getTransactions;
  final AddTransaction addTransaction;
  final UpdateTransaction updateTransaction;
  final DeleteTransaction deleteTransaction;

  FinanceBloc({
    required this.getTransactions,
    required this.addTransaction,
    required this.updateTransaction,
    required this.deleteTransaction,
  }) : super(FinanceLoading()) {
    on<LoadTransactionsEvent>(_onLoad);
    on<AddTransactionEvent>(_onAdd);
    on<UpdateTransactionEvent>(_onUpdate);
    on<DeleteTransactionEvent>(_onDelete);
    on<ChangeMonthEvent>(_onChangeMonth);
  }

  Future<void> _onLoad(
    LoadTransactionsEvent event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());

    final transactions = await getTransactions(NoParams());

    emit(
      FinanceLoaded(
        transactions: transactions,
        selectedMonth: DateTime.now(),
      ),
    );
  }

  Future<void> _onAdd(
    AddTransactionEvent event,
    Emitter<FinanceState> emit,
  ) async {
    await addTransaction(event.transaction);
    final transactions = await getTransactions(NoParams());

    emit(
      FinanceLoaded(
        transactions: transactions,
        selectedMonth: DateTime.now(),
      ),
    );
  }

  Future<void> _onUpdate(
    UpdateTransactionEvent event,
    Emitter<FinanceState> emit,
  ) async {
    await updateTransaction(event.transaction);
    final transactions = await getTransactions(NoParams());

    emit(
      FinanceLoaded(
        transactions: transactions,
        selectedMonth: DateTime.now(),
      ),
    );
  }

  Future<void> _onDelete(
    DeleteTransactionEvent event,
    Emitter<FinanceState> emit,
  ) async {
    await deleteTransaction(event.id);
    final transactions = await getTransactions(NoParams());

    emit(
      FinanceLoaded(
        transactions: transactions,
        selectedMonth: DateTime.now(),
      ),
    );
  }

  Future<void> _onChangeMonth(
    ChangeMonthEvent event,
    Emitter<FinanceState> emit,
  ) async {
    final transactions = await getTransactions(NoParams());

    emit(
      FinanceLoaded(
        transactions: transactions,
        selectedMonth: event.month,
      ),
    );
  }
}