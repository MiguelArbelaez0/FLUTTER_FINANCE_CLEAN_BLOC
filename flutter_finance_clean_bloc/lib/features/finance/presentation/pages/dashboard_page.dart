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
      appBar: AppBar(title: const Text('Finance')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TransactionFormPage(),
            ),
          );
        },
      ),
      body: BlocBuilder<FinanceBloc, FinanceState>(
        builder: (context, state) {
          if (state is FinanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FinanceLoaded) {
            final filtered = state.transactions.where((t) {
              return t.date.year == state.selectedMonth.year &&
                  t.date.month == state.selectedMonth.month;
            }).toList();

            final income = filtered
                .where((t) => t.type == TransactionType.income)
                .fold<double>(0, (sum, t) => sum + t.amount);

            final expense = filtered
                .where((t) => t.type == TransactionType.expense)
                .fold<double>(0, (sum, t) => sum + t.amount);

            return Column(
              children: [
                MonthSelector(
                  month: state.selectedMonth,
                  onChanged: (month) {
                    context
                        .read<FinanceBloc>()
                        .add(ChangeMonthEvent(month));
                  },
                ),
                BalanceCard(income: income, expense: expense),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(
                          child: Text('No transactions for this month'),
                        )
                      : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (_, index) {
                            return TransactionTile(
                              transaction: filtered[index],
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const Center(child: Text('Error'));
        },
      ),
    );
  }
}
