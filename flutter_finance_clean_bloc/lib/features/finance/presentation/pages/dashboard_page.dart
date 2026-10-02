import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finance_clean_bloc/features/finance/presentation/bloc/finance_event.dart';
import 'package:flutter_finance_clean_bloc/features/finance/presentation/widgets/month_selecto.dart';

import '../bloc/finance_bloc.dart';
import '../bloc/finance_state.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_tile.dart';
import 'transaction_form_page.dart';
import '../../../../core/utils/enums.dart';

class FinanceDashboardPage extends StatelessWidget {
  const FinanceDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Nueva transacción'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TransactionFormPage()),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<FinanceBloc, FinanceState>(
          builder: (context, state) {
            if (state is FinanceLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FinanceLoaded) {
              final filtered = state.transactions.where((transaction) {
                return transaction.date.year == state.selectedMonth.year &&
                    transaction.date.month == state.selectedMonth.month;
              }).toList();
              final income = filtered
                  .where((t) => t.type == TransactionType.income)
                  .fold<double>(0, (sum, t) => sum + t.amount);
              final expense = filtered
                  .where((t) => t.type == TransactionType.expense)
                  .fold<double>(0, (sum, t) => sum + t.amount);

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mis finanzas',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Resumen de tus movimientos',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: const Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: BalanceCard(income: income, expense: expense),
                      ),
                      MonthSelector(
                        month: state.selectedMonth,
                        onChanged: (month) => context.read<FinanceBloc>().add(
                          ChangeMonthEvent(month),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 4, 20, 8),
                        child: Text(
                          'Movimientos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: filtered.isEmpty
                            ? const _EmptyMovements()
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  88,
                                ),
                                itemCount: filtered.length,
                                separatorBuilder: (_, _) => const Divider(
                                  height: 1,
                                  indent: 68,
                                  color: Color(0xFFE5E7EB),
                                ),
                                itemBuilder: (_, index) => TransactionTile(
                                  transaction: filtered[index],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No pudimos cargar tus movimientos.'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => context.read<FinanceBloc>().add(
                        LoadTransactionsEvent(),
                      ),
                      child: const Text('Intentar nuevamente'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyMovements extends StatelessWidget {
  const _EmptyMovements();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 36,
            color: Color(0xFF6B7280),
          ),
          const SizedBox(height: 12),
          Text(
            'Sin movimientos',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          const Text(
            'Este mes todavía no tienes movimientos registrados.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TransactionFormPage()),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Agregar movimiento'),
          ),
        ],
      ),
    ),
  );
}
