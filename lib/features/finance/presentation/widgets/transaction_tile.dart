import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finance_clean_bloc/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:flutter_finance_clean_bloc/features/finance/presentation/bloc/finance_event.dart';
import 'package:flutter_finance_clean_bloc/features/finance/presentation/pages/transaction_form_page.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/entities/transaction.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/enums.dart';

class TransactionTile extends StatelessWidget {
  final FinanceTransaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? const Color(0xFF15803D) : const Color(0xFFB91C1C);
    final icon = switch (transaction.category.toLowerCase()) {
      'alimentación' || 'food' => Icons.restaurant,
      'transporte' || 'transport' => Icons.directions_car,
      'vivienda' || 'home' => Icons.home_outlined,
      'salud' || 'health' => Icons.medical_services_outlined,
      'compras' || 'shopping' => Icons.shopping_cart_outlined,
      _ =>
        isIncome ? Icons.account_balance_wallet_outlined : Icons.receipt_long,
    };
    final formattedAmount = NumberFormat(
      '#,##0.##',
      'es_CO',
    ).format(transaction.amount);
    final date = transaction.date;
    final dateText =
        '${date.day} ${_monthAbbreviation(date.month)} ${date.year}';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFF5F6F8),
        foregroundColor: const Color(0xFF1F4E79),
        child: Icon(icon, size: 20),
      ),
      title: Text(
        transaction.description?.isNotEmpty == true
            ? transaction.description!
            : transaction.category,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text('${transaction.category} · $dateText'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${isIncome ? '+' : '−'}\$ $formattedAmount',
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
          PopupMenuButton<String>(
            tooltip: 'Opciones del movimiento',
            onSelected: (action) {
              if (action == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        TransactionFormPage(transaction: transaction),
                  ),
                );
              } else {
                _showDeleteDialog(context);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Editar')),
              PopupMenuItem(value: 'delete', child: Text('Eliminar')),
            ],
          ),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TransactionFormPage(transaction: transaction),
        ),
      ),
      onLongPress: () => _showDeleteDialog(context),
    );
  }

  String _monthAbbreviation(int month) => const [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ][month - 1];

  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Eliminar movimiento?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton.tonal(
            onPressed: () {
              context.read<FinanceBloc>().add(
                DeleteTransactionEvent(transaction.id),
              );
              Navigator.pop(dialogContext);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
