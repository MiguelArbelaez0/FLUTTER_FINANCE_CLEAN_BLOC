import 'package:flutter_finance_clean_bloc/core/utils/enums.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/entities/transaction.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/repositories/finance_repository.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use_cases/add_transaction.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use_cases/calculate_balance.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use_cases/delete_transaction.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use_cases/get_transactions.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use_cases/update_transaction.dart';
import 'package:flutter_finance_clean_bloc/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:flutter_finance_clean_bloc/features/finance/presentation/bloc/finance_event.dart';
import 'package:flutter_finance_clean_bloc/features/finance/presentation/bloc/finance_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _MemoryRepository repository;
  late FinanceBloc bloc;
  setUp(() {
    repository = _MemoryRepository();
    bloc = FinanceBloc(
      getTransactions: GetTransactions(repository),
      addTransaction: AddTransaction(repository),
      updateTransaction: UpdateTransaction(repository),
      deleteTransaction: DeleteTransaction(repository),
      calculateBalance: CalculateBalance(),
    );
  });
  tearDown(() => bloc.close());

  test(
    'loads, changes month from memory, and preserves month after add',
    () async {
      bloc.add(LoadTransactionsEvent());
      await expectLater(bloc.stream, emitsThrough(isA<FinanceLoaded>()));
      bloc.add(ChangeMonthEvent(DateTime(2026, 8)));
      await expectLater(
        bloc.stream,
        emitsThrough(
          isA<FinanceLoaded>().having((s) => s.selectedMonth.month, 'month', 8),
        ),
      );
      bloc.add(
        AddTransactionEvent(
          FinanceTransaction(
            id: 'aug',
            amount: 25,
            type: TransactionType.expense,
            category: 'Otros',
            date: DateTime(2026, 8),
          ),
        ),
      );
      await expectLater(
        bloc.stream,
        emitsThrough(
          isA<FinanceLoaded>()
              .having((s) => s.selectedMonth.month, 'month', 8)
              .having((s) => s.transactions.length, 'transaction count', 1),
        ),
      );
      expect(
        repository.readCount,
        2,
      ); // initial load and mutation refresh; month changes use memory.
    },
  );

  test('maps repository errors to a friendly error state', () async {
    repository.failReads = true;
    bloc.add(LoadTransactionsEvent());
    await expectLater(
      bloc.stream,
      emitsThrough(
        isA<FinanceError>().having(
          (s) => s.message,
          'message',
          contains('Inténtalo'),
        ),
      ),
    );
  });

  test(
    'updates and deletes transactions without changing the selected month',
    () async {
      final original = FinanceTransaction(
        id: 'aug',
        amount: 25,
        type: TransactionType.expense,
        category: 'Otros',
        date: DateTime(2026, 8),
      );
      repository.values.add(original);
      bloc.add(LoadTransactionsEvent());
      await expectLater(bloc.stream, emitsThrough(isA<FinanceLoaded>()));
      bloc.add(ChangeMonthEvent(DateTime(2026, 8)));
      await expectLater(
        bloc.stream,
        emitsThrough(
          isA<FinanceLoaded>().having(
            (state) => state.selectedMonth.month,
            'month',
            8,
          ),
        ),
      );
      bloc.add(
        UpdateTransactionEvent(
          FinanceTransaction(
            id: 'aug',
            amount: 40,
            type: TransactionType.expense,
            category: 'Otros',
            date: DateTime(2026, 8),
          ),
        ),
      );
      await expectLater(
        bloc.stream,
        emitsThrough(
          isA<FinanceLoaded>()
              .having((state) => state.selectedMonth.month, 'month', 8)
              .having(
                (state) => state.transactions.single.amount,
                'updated amount',
                40,
              ),
        ),
      );
      bloc.add(DeleteTransactionEvent('aug'));
      await expectLater(
        bloc.stream,
        emitsThrough(
          isA<FinanceLoaded>()
              .having((state) => state.selectedMonth.month, 'month', 8)
              .having((state) => state.transactions, 'transactions', isEmpty),
        ),
      );
    },
  );
}

final class _MemoryRepository implements FinanceRepository {
  final List<FinanceTransaction> values = [];
  int readCount = 0;
  bool failReads = false;
  @override
  Future<List<FinanceTransaction>> getTransactions() async {
    readCount++;
    if (failReads) throw Exception('private detail');
    return List.of(values);
  }

  @override
  Future<void> addTransaction(FinanceTransaction transaction) async =>
      values.add(transaction);
  @override
  Future<void> updateTransaction(FinanceTransaction transaction) async {
    final index = values.indexWhere((value) => value.id == transaction.id);
    if (index >= 0) values[index] = transaction;
  }

  @override
  Future<void> deleteTransaction(String id) async =>
      values.removeWhere((value) => value.id == id);
}
