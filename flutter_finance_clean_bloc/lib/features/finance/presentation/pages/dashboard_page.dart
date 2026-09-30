import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/finance_bloc.dart';
import '../bloc/finance_event.dart';
import '../bloc/finance_state.dart';
import '../widgets/balance_card.dart';
import '../widgets/month_selector.dart';
import '../widgets/transaction_tile.dart';
import 'transaction_form_page.dart';

class FinanceDashboardPage extends StatelessWidget {
  const FinanceDashboardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TransactionFormPage()),
      ),
      icon: const Icon(Icons.add),
      label: const Text('Agregar movimiento'),
    ),
    body: SafeArea(
      child: BlocConsumer<FinanceBloc, FinanceState>(
        listener: (context, state) {
          if (state is FinanceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                action: SnackBarAction(
                  label: 'Reintentar',
                  onPressed: () =>
                      context.read<FinanceBloc>().add(LoadTransactionsEvent()),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FinanceLoading || state is FinanceInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FinanceError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off_outlined, size: 48),
                  const SizedBox(height: 12),
                  const Text('No pudimos cargar tus movimientos.'),
                  TextButton(
                    onPressed: () => context.read<FinanceBloc>().add(
                      LoadTransactionsEvent(),
                    ),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          if (state is! FinanceLoaded) return const SizedBox.shrink();
          final monthTransactions =
              state.transactions
                  .where(
                    (t) =>
                        t.date.year == state.selectedMonth.year &&
                        t.date.month == state.selectedMonth.month,
                  )
                  .toList()
                ..sort((a, b) => b.date.compareTo(a.date));
          return LayoutBuilder(
            builder: (context, constraints) => Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        constraints.maxWidth > 600 ? 32 : 20,
                        24,
                        constraints.maxWidth > 600 ? 32 : 20,
                        8,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mis Finanzas',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Resumen de tus movimientos',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            MonthSelector(
                              month: state.selectedMonth,
                              onChanged: (month) => context
                                  .read<FinanceBloc>()
                                  .add(ChangeMonthEvent(month)),
                            ),
                            const SizedBox(height: 12),
                            BalanceCard(balance: state.balance),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        constraints.maxWidth > 600 ? 32 : 20,
                        24,
                        constraints.maxWidth > 600 ? 32 : 20,
                        100,
                      ),
                      sliver: monthTransactions.isEmpty
                          ? SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.receipt_long_outlined,
                                      size: 52,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      'No hay movimientos este mes',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'Agrega tu primera transacción para comenzar.',
                                    ),
                                    const SizedBox(height: 16),
                                    FilledButton.icon(
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const TransactionFormPage(),
                                        ),
                                      ),
                                      icon: const Icon(Icons.add),
                                      label: const Text('Agregar transacción'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: TransactionTile(
                                    transaction: monthTransactions[index],
                                  ),
                                ),
                                childCount: monthTransactions.length,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
