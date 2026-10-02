import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceCard extends StatelessWidget {
  final double income;
  final double expense;

  const BalanceCard({super.key, required this.income, required this.expense});

  String _money(double value) =>
      '\$ ${NumberFormat('#,##0', 'es_CO').format(value)}';

  @override
  Widget build(BuildContext context) {
    final balance = income - expense;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Saldo disponible', style: textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              _money(balance),
              style: textTheme.headlineMedium?.copyWith(
                color: const Color(0xFF1F2937),
                fontWeight: FontWeight.w700,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),
            Row(
              children: [
                Expanded(
                  child: _SummaryAmount(
                    label: 'Ingresos',
                    amount: _money(income),
                    icon: Icons.arrow_upward,
                    color: const Color(0xFF15803D),
                  ),
                ),
                Expanded(
                  child: _SummaryAmount(
                    label: 'Gastos',
                    amount: _money(expense),
                    icon: Icons.arrow_downward,
                    color: const Color(0xFFB91C1C),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryAmount extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;
  final Color color;

  const _SummaryAmount({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 4),
        Text(amount, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
