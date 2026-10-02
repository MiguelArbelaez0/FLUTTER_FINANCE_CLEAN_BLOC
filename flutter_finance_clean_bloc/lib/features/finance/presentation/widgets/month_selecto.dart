import 'package:flutter/material.dart';

class MonthSelector extends StatelessWidget {
  final DateTime month;
  final ValueChanged<DateTime> onChanged;

  const MonthSelector({
    super.key,
    required this.month,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    final label = '${_capitalize(months[month.month - 1])} ${month.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              onChanged(DateTime(month.year, month.month - 1));
            },
          ),
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              onChanged(DateTime(month.year, month.month + 1));
            },
          ),
        ],
      ),
    );
  }

  String _capitalize(String value) =>
      '${value[0].toUpperCase()}${value.substring(1)}';
}
