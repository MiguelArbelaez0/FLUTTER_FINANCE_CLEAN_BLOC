import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finance_clean_bloc/core/use%20cases/usecase.dart';
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
    on<FinanceEvent>(
      _handle,
      transformer: (events, mapper) => events.asyncExpand(mapper),
    );
  }

  Future<void> _handle(FinanceEvent event, Emitter<FinanceState> emit) async {
    final previous = state is FinanceLoaded ? state as FinanceLoaded : null;
    final month = previous?.selectedMonth ?? DateTime.now();
    if (event is ChangeMonthEvent && previous != null) {
      emit(
        FinanceLoaded(
          transactions: previous.transactions,
          selectedMonth: event.month,
          revision: previous.revision,
        ),
      );
      return;
    }
    final mutation =
        event is AddTransactionEvent ||
        event is UpdateTransactionEvent ||
        event is DeleteTransactionEvent;
    if (previous != null && mutation) {
      emit(
        FinanceLoaded(
          transactions: previous.transactions,
          selectedMonth: month,
          saving: true,
          revision: previous.revision,
        ),
      );
    } else {
      emit(FinanceLoading());
    }
    try {
      if (event is AddTransactionEvent) await addTransaction(event.transaction);
      if (event is UpdateTransactionEvent) {
        await updateTransaction(event.transaction);
      }
      if (event is DeleteTransactionEvent) await deleteTransaction(event.id);
      // A successful write is already committed. Avoid reporting it as failed
      // because a second storage read fails, which could prompt a duplicate retry.
      final transactions = mutation && previous != null
          ? [...previous.transactions]
          : await getTransactions(NoParams());
      if (mutation && previous != null) {
        if (event is AddTransactionEvent) transactions.add(event.transaction);
        if (event is UpdateTransactionEvent) {
          transactions.removeWhere((t) => t.id == event.transaction.id);
          transactions.add(event.transaction);
        }
        if (event is DeleteTransactionEvent) {
          transactions.removeWhere((t) => t.id == event.id);
        }
      }
      emit(
        FinanceLoaded(
          transactions: transactions,
          selectedMonth: month,
          revision: (previous?.revision ?? 0) + (mutation ? 1 : 0),
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      if (previous == null) {
        emit(FinanceError());
      } else {
        emit(
          FinanceLoaded(
            transactions: previous.transactions,
            selectedMonth: month,
            revision: previous.revision,
            error: 'No se pudo completar la operación. Intenta nuevamente.',
          ),
        );
      }
    }
  }
}
