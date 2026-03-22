import 'package:flutter_finance_clean_bloc/features/finance/domain/entities/transaction.dart';

abstract class FinanceEvent {}

class LoadTransactionsEvent extends FinanceEvent {}

class AddTransactionEvent extends FinanceEvent {
  final FinanceTransaction transaction;
  AddTransactionEvent(this.transaction);
}

class UpdateTransactionEvent extends FinanceEvent {
  final FinanceTransaction transaction;
  UpdateTransactionEvent(this.transaction);
}

class DeleteTransactionEvent extends FinanceEvent {
  final String id;
  DeleteTransactionEvent(this.id);
}

class ChangeMonthEvent extends FinanceEvent {
  final DateTime month;
  ChangeMonthEvent(this.month);
}