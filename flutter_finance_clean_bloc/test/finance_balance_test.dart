import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_finance_clean_bloc/core/utils/enums.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/entities/transaction.dart';

void main() {
  group('Finance balance calculation', () {
    test('should calculate income, expense and balance correctly', () {
      // Arrange
      final transactions = [
        FinanceTransaction(
          id: '1',
          amount: 1500,
          type: TransactionType.income,
          category: 'Salary',
          date: DateTime(2025, 1, 10),
          description: 'Monthly salary',
        ),
        FinanceTransaction(
          id: '2',
          amount: 300,
          type: TransactionType.expense,
          category: 'Food',
          date: DateTime(2025, 1, 12),
          description: 'Groceries',
        ),
        FinanceTransaction(
          id: '3',
          amount: 200,
          type: TransactionType.expense,
          category: 'Transport',
          date: DateTime(2025, 1, 15),
          description: 'Taxi',
        ),
      ];

      // Act
      final income = transactions
          .where((t) => t.type == TransactionType.income)
          .fold<double>(0, (sum, t) => sum + t.amount);

      final expense = transactions
          .where((t) => t.type == TransactionType.expense)
          .fold<double>(0, (sum, t) => sum + t.amount);

      final balance = income - expense;

      // Assert
      expect(income, 1500);
      expect(expense, 500);
      expect(balance, 1000);
    });
  });
}