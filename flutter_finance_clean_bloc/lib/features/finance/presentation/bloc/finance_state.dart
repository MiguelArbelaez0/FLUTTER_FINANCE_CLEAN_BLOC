import '../../domain/entities/balance.dart';
import '../../domain/entities/transaction.dart';

sealed class FinanceState {
  const FinanceState();
}

final class FinanceInitial extends FinanceState {
  const FinanceInitial();
}

final class FinanceLoading extends FinanceState {
  const FinanceLoading();
}

final class FinanceLoaded extends FinanceState {
  const FinanceLoaded({
    required this.transactions,
    required this.selectedMonth,
    required this.balance,
    this.isSaving = false,
  });
  final List<FinanceTransaction> transactions;
  final DateTime selectedMonth;
  final Balance balance;
  final bool isSaving;
}

final class FinanceError extends FinanceState {
  const FinanceError(this.message);
  final String message;
}
