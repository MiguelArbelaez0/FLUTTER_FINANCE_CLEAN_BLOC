import 'package:flutter_finance_clean_bloc/core/utils/enums.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/entities/transaction.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use_cases/calculate_balance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('calculates income, expenses, and net balance', () async {
    final result = await CalculateBalance()([
      FinanceTransaction(
        id: 'i',
        amount: 1500,
        type: TransactionType.income,
        category: 'Salario',
        date: DateTime(2026, 8),
      ),
      FinanceTransaction(
        id: 'e',
        amount: 500,
        type: TransactionType.expense,
        category: 'Hogar',
        date: DateTime(2026, 8),
      ),
    ]);
    expect(result.totalIncome, 1500);
    expect(result.totalExpense, 500);
    expect(result.total, 1000);
  });

  test('returns a zero balance for no transactions', () async {
    final result = await CalculateBalance()([]);
    expect(result.total, 0);
  });
}
