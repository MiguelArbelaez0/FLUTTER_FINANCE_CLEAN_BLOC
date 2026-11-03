import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:flutter_finance_clean_bloc/core/utils/constants.dart';
import 'package:flutter_finance_clean_bloc/core/utils/enums.dart';
import 'package:flutter_finance_clean_bloc/core/utils/money.dart';
import 'package:flutter_finance_clean_bloc/core/utils/local_database_service.dart';
import 'package:flutter_finance_clean_bloc/features/finance/data/data%20sources/finance_local_datasource.dart';
import 'package:flutter_finance_clean_bloc/features/finance/data/repositories/finance_repository_impl.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/entities/transaction.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use%20cases/calculate_balance.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use%20cases/add_transaction.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use%20cases/update_transaction.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use%20cases/delete_transaction.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/use%20cases/get_transactions.dart';
import 'package:flutter_finance_clean_bloc/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:flutter_finance_clean_bloc/features/finance/presentation/bloc/finance_event.dart';
import 'package:flutter_finance_clean_bloc/features/finance/presentation/bloc/finance_state.dart';
import 'package:flutter_finance_clean_bloc/features/finance/presentation/pages/dashboard_page.dart';
import 'package:flutter_finance_clean_bloc/features/finance/presentation/pages/transaction_form_page.dart';

FinanceTransaction tx(
  String id,
  double amount, {
  TransactionType type = TransactionType.income,
  DateTime? date,
}) => FinanceTransaction(
  id: id,
  amount: amount,
  type: type,
  category: 'Otros',
  date: date ?? DateTime(2025, 1, 1),
  description: 'Prueba',
);
Future<FinanceState> dispatch(FinanceBloc bloc, FinanceEvent event) async {
  final next = bloc.stream.firstWhere(
    (s) => s is FinanceError || s is FinanceLoaded && !s.saving,
  );
  bloc.add(event);
  return next;
}

void main() {
  late Directory directory;
  late FinanceLocalDatasourceImpl source;
  late FinanceBloc bloc;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('finance_test_');
    Hive.init(directory.path);
    source = FinanceLocalDatasourceImpl(LocalDatabaseService());
    final repository = FinanceRepositoryImpl(source);
    bloc = FinanceBloc(
      getTransactions: GetTransactions(repository),
      addTransaction: AddTransaction(repository),
      updateTransaction: UpdateTransaction(repository),
      deleteTransaction: DeleteTransaction(repository),
    );
  });
  tearDown(() async {
    await bloc.close();
    await Hive.close();
    await directory.delete(recursive: true);
  });

  test(
    'balance uses production cents calculation including empty and negative balance',
    () {
      final calculate = CalculateBalance();
      final balance = calculate([
        tx('1', .1),
        tx('2', .2),
        tx('3', .3, type: TransactionType.expense),
      ]);
      expect(balance.totalIncome, .3);
      expect(balance.total, 0);
      expect(calculate([]).total, 0);
      expect(
        calculate([tx('4', .01, type: TransactionType.expense)]).total,
        -.01,
      );
    },
  );
  test(
    'amount parser accepts comma and rejects invalid and overprecision inputs',
    () {
      expect(Money.parse(' 12,34 '), 12.34);
      expect(Money.parse('12.34'), 12.34);
      for (final value in [
        'NaN',
        'Infinity',
        '-1',
        '0',
        '1.001',
        '1e3',
        '1,000.20',
        '',
        '1000000001',
      ]) {
        expect(Money.parse(value), isNull, reason: value);
      }
      expect(() => tx('bad', double.nan), throwsArgumentError);
      expect(() => tx('bad', -1), throwsArgumentError);
    },
  );
  test(
    'Hive CRUD survives close and reopen without overwriting duplicate IDs',
    () async {
      expect(await source.getTransactions(), isEmpty);
      await source.addTransaction(tx('1', 12.34));
      await expectLater(source.addTransaction(tx('1', 99)), throwsStateError);
      await source.updateTransaction(tx('1', 20.01));
      await Hive.close();
      expect((await source.getTransactions()).single.amount, 20.01);
      await expectLater(
        source.updateTransaction(tx('missing', 1)),
        throwsStateError,
      );
      await source.deleteTransaction('1');
      expect(await source.getTransactions(), isEmpty);
    },
  );
  test(
    'legacy integer and fractional records remain readable without migration',
    () async {
      final box = await Hive.openBox(transactionsBox);
      await box.put('old', {
        'id': 'old',
        'amount': 12,
        'type': 'income',
        'category': 'Food',
        'date': '2025-01-01T00:00:00.000',
      });
      expect((await source.getTransactions()).single.amount, 12);
      final raw = Map<String, dynamic>.from(box.get('old'))..['amount'] = 1.234;
      await box.put('old', raw);
      expect((await source.getTransactions()).single.amount, 1.234);
      expect(box.get('old')['amount'], 1.234);
      await expectLater(
        source.addTransaction(tx('new', 1.234)),
        throwsArgumentError,
      );
    },
  );
  test('corrupt records fail explicitly and are preserved', () async {
    final box = await Hive.openBox(transactionsBox);
    await box.put('broken', {'amount': 'bad'});
    await expectLater(source.getTransactions(), throwsFormatException);
    expect(box.get('broken'), {'amount': 'bad'});
    expect(await dispatch(bloc, LoadTransactionsEvent()), isA<FinanceError>());
  });
  test(
    'BLoC preserves year/month across CRUD, reports errors and recovers',
    () async {
      await dispatch(bloc, LoadTransactionsEvent());
      await dispatch(bloc, ChangeMonthEvent(DateTime(2025, 1)));
      var state =
          await dispatch(bloc, AddTransactionEvent(tx('1', 1)))
              as FinanceLoaded;
      expect(state.selectedMonth, DateTime(2025, 1));
      expect(state.monthlyTransactions, hasLength(1));
      state =
          await dispatch(bloc, AddTransactionEvent(tx('1', 2)))
              as FinanceLoaded;
      expect(state.error, isNotNull);
      expect(state.transactions.single.amount, 1);
      state =
          await dispatch(
                bloc,
                UpdateTransactionEvent(tx('1', 2, date: DateTime(2024, 1))),
              )
              as FinanceLoaded;
      expect(state.error, isNull);
      expect(state.monthlyTransactions, isEmpty);
      state =
          await dispatch(bloc, DeleteTransactionEvent('1')) as FinanceLoaded;
      expect(state.transactions, isEmpty);
      expect(state.selectedMonth, DateTime(2025, 1));
    },
  );
  test('queued mutations are serialized across event types', () async {
    await dispatch(bloc, LoadTransactionsEvent());
    final finished = bloc.stream.firstWhere(
      (s) => s is FinanceLoaded && s.revision == 3,
    );
    bloc.add(AddTransactionEvent(tx('1', 1)));
    bloc.add(UpdateTransactionEvent(tx('1', 2)));
    bloc.add(DeleteTransactionEvent('1'));
    final state = await finished as FinanceLoaded;
    expect(state.transactions, isEmpty);
  });
  testWidgets('empty dashboard and invalid form input do not write data', (
    tester,
  ) async {
    await tester.runAsync(() => dispatch(bloc, LoadTransactionsEvent()));
    await tester.pumpWidget(
      BlocProvider.value(
        value: bloc,
        child: const MaterialApp(home: FinanceDashboardPage()),
      ),
    );
    expect(find.text('Sin movimientos'), findsOneWidget);
    await tester.tap(find.text('Agregar movimiento'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'NaN');
    await tester.enterText(find.byType(TextField).last, 'Prueba');
    await tester.ensureVisible(find.text('Guardar movimiento'));
    await tester.tap(find.text('Guardar movimiento'));
    await tester.pumpAndSettle();
    expect(find.byType(TransactionFormPage), findsOneWidget);
    expect(await tester.runAsync(source.getTransactions), isEmpty);
    expect(tester.takeException(), isNull);
  });
  testWidgets('valid decimal form saves once and returns after persistence', (
    tester,
  ) async {
    await tester.runAsync(() => dispatch(bloc, LoadTransactionsEvent()));
    await tester.pumpWidget(
      BlocProvider.value(
        value: bloc,
        child: const MaterialApp(home: FinanceDashboardPage()),
      ),
    );
    await tester.tap(find.text('Agregar movimiento'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '12,34');
    await tester.enterText(find.byType(TextField).last, 'Compra');
    await tester.ensureVisible(find.text('Guardar movimiento'));
    await tester.tap(find.text('Guardar movimiento'));
    await tester.runAsync(() async {
      await bloc.stream.firstWhere((s) => s is FinanceLoaded && !s.saving);
    });
    await tester.pumpAndSettle();
    expect(find.byType(TransactionFormPage), findsNothing);
    expect(
      (await tester.runAsync(source.getTransactions))!.single.amount,
      12.34,
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets('failed update keeps form and entered information available', (
    tester,
  ) async {
    await tester.runAsync(() => dispatch(bloc, LoadTransactionsEvent()));
    await tester.pumpWidget(
      BlocProvider.value(
        value: bloc,
        child: MaterialApp(
          home: TransactionFormPage(transaction: tx('missing', 1)),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField).first, '99,99');
    await tester.ensureVisible(find.text('Guardar cambios'));
    await tester.tap(find.text('Guardar cambios'));
    await tester.runAsync(
      () =>
          bloc.stream.firstWhere((s) => s is FinanceLoaded && s.error != null),
    );
    await tester.pumpAndSettle();
    expect(find.byType(TransactionFormPage), findsOneWidget);
    expect(find.text('99,99'), findsOneWidget);
    expect(
      find.text('No se pudo completar la operación. Intenta nuevamente.'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Guardar cambios'),
          )
          .onPressed,
      isNotNull,
    );
    expect(await tester.runAsync(source.getTransactions), isEmpty);
    expect(tester.takeException(), isNull);
  });
}
