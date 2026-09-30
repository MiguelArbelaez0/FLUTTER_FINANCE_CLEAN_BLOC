import 'package:flutter/material.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/entities/balance.dart';
import 'package:flutter_finance_clean_bloc/features/finance/presentation/widgets/balance_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  testWidgets('shows monthly balance, income, and expenses', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BalanceCard(
            balance: Balance(totalIncome: 1500, totalExpense: 500),
          ),
        ),
      ),
    );
    expect(find.text('SALDO DEL MES'), findsOneWidget);
    final currency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$ ',
      decimalDigits: 0,
    );
    expect(find.text(currency.format(1000)), findsOneWidget);
    expect(find.text('Ingresos'), findsOneWidget);
    expect(find.text(currency.format(1500)), findsOneWidget);
    expect(find.text('Gastos'), findsOneWidget);
    expect(find.text(currency.format(500)), findsOneWidget);
  });
}
