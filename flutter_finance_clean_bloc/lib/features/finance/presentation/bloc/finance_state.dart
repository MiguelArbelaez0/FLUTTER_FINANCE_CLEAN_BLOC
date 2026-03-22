import '../../domain/entities/transaction.dart';

abstract class FinanceState {}

class FinanceLoading extends FinanceState {}

class FinanceLoaded extends FinanceState {
  final List<FinanceTransaction> transactions;
  final DateTime selectedMonth;

  FinanceLoaded({
    required this.transactions,
    required this.selectedMonth,
  });
}

class FinanceError extends FinanceState {}
