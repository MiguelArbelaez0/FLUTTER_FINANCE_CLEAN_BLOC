import 'package:flutter_finance_clean_bloc/features/finance/domain/entities/transaction.dart';

abstract class FinanceState {}

class FinanceLoading extends FinanceState {}

class FinanceLoaded extends FinanceState {
  final List<FinanceTransaction> transactions;
  final DateTime selectedMonth;
  final bool saving;
  final String? error;
  final int revision;

  FinanceLoaded({
    required List<FinanceTransaction> transactions,
    required this.selectedMonth,
    this.saving = false,
    this.error,
    this.revision = 0,
  }) : transactions = List.unmodifiable(transactions);

  List<FinanceTransaction> get monthlyTransactions => transactions
      .where(
        (t) =>
            t.date.year == selectedMonth.year &&
            t.date.month == selectedMonth.month,
      )
      .toList();
}

class FinanceError extends FinanceState {}
