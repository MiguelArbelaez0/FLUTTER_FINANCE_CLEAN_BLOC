import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/usecase.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/use_cases/add_transaction.dart';
import '../../domain/use_cases/calculate_balance.dart';
import '../../domain/use_cases/delete_transaction.dart';
import '../../domain/use_cases/get_transactions.dart';
import '../../domain/use_cases/update_transaction.dart';
import 'finance_event.dart';
import 'finance_state.dart';

final class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  FinanceBloc({
    required this.getTransactions,
    required this.addTransaction,
    required this.updateTransaction,
    required this.deleteTransaction,
    required this.calculateBalance,
  }) : super(const FinanceInitial()) {
    on<LoadTransactionsEvent>(_onLoad);
    on<AddTransactionEvent>(_onAdd);
    on<UpdateTransactionEvent>(_onUpdate);
    on<DeleteTransactionEvent>(_onDelete);
    on<ChangeMonthEvent>(_onChangeMonth);
  }
  final GetTransactions getTransactions;
  final AddTransaction addTransaction;
  final UpdateTransaction updateTransaction;
  final DeleteTransaction deleteTransaction;
  final CalculateBalance calculateBalance;
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  List<FinanceTransaction> _transactions = [];
  Future<FinanceLoaded> _loaded(List<FinanceTransaction> list) async =>
      FinanceLoaded(
        transactions: List.unmodifiable(list),
        selectedMonth: _month,
        balance: await calculateBalance(
          list
              .where(
                (t) =>
                    t.date.year == _month.year && t.date.month == _month.month,
              )
              .toList(),
        ),
      );
  Future<void> _onLoad(
    LoadTransactionsEvent event,
    Emitter<FinanceState> emit,
  ) async {
    emit(const FinanceLoading());
    try {
      _transactions = await getTransactions(const NoParams());
      emit(await _loaded(_transactions));
    } catch (error) {
      emit(FinanceError(_friendly(error)));
    }
  }

  Future<void> _mutate(
    Future<void> Function() action,
    Emitter<FinanceState> emit,
  ) async {
    final current = state;
    if (current is! FinanceLoaded || current.isSaving) return;
    emit(
      FinanceLoaded(
        transactions: current.transactions,
        selectedMonth: current.selectedMonth,
        balance: current.balance,
        isSaving: true,
      ),
    );
    try {
      await action();
      _transactions = await getTransactions(const NoParams());
      emit(await _loaded(_transactions));
    } catch (error) {
      emit(FinanceError(_friendly(error)));
    }
  }

  Future<void> _onAdd(AddTransactionEvent event, Emitter<FinanceState> emit) =>
      _mutate(() => addTransaction(event.transaction), emit);
  Future<void> _onUpdate(
    UpdateTransactionEvent event,
    Emitter<FinanceState> emit,
  ) => _mutate(() => updateTransaction(event.transaction), emit);
  Future<void> _onDelete(
    DeleteTransactionEvent event,
    Emitter<FinanceState> emit,
  ) => _mutate(() => deleteTransaction(event.id), emit);
  Future<void> _onChangeMonth(
    ChangeMonthEvent event,
    Emitter<FinanceState> emit,
  ) async {
    _month = DateTime(event.month.year, event.month.month);
    final current = state;
    if (current is FinanceLoaded) {
      emit(
        FinanceLoaded(
          transactions: current.transactions,
          selectedMonth: _month,
          balance: await calculateBalance(
            current.transactions
                .where(
                  (t) =>
                      t.date.year == _month.year &&
                      t.date.month == _month.month,
                )
                .toList(),
          ),
          isSaving: current.isSaving,
        ),
      );
    }
  }

  String _friendly(Object error) => error is Failure
      ? error.message
      : 'Ocurrió un error. Inténtalo de nuevo.';
}
