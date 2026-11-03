import 'dart:math';
import '../../../../core/utils/money.dart';
import '../bloc/finance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finance_clean_bloc/features/finance/domain/entities/transaction.dart';

import '../../../../core/utils/enums.dart';
import '../bloc/finance_bloc.dart';
import '../bloc/finance_event.dart';

class TransactionFormPage extends StatefulWidget {
  final FinanceTransaction? transaction;

  const TransactionFormPage({super.key, this.transaction});

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  static const _categories = [
    'Alimentación',
    'Transporte',
    'Vivienda',
    'Salud',
    'Educación',
    'Entretenimiento',
    'Compras',
    'Servicios',
    'Otros',
  ];
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late TransactionType _type;
  late String _category;
  late DateTime _date;
  bool _submitting = false;
  int _revision = 0;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.transaction?.amount.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.transaction?.description ?? '',
    );
    _type = widget.transaction?.type ?? TransactionType.expense;
    _category = widget.transaction?.category ?? 'Otros';
    _date = widget.transaction?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (_submitting) return;
    final amount = Money.parse(_amountController.text);
    final description = _descriptionController.text.trim();
    if (amount == null || amount <= 0 || description.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ingresa un monto válido y una descripción de al menos 3 caracteres.',
          ),
        ),
      );
      return;
    }

    final state = context.read<FinanceBloc>().state;
    if (state is! FinanceLoaded || state.saving) return;
    _revision = state.revision;
    setState(() => _submitting = true);
    final transaction = FinanceTransaction(
      id:
          widget.transaction?.id ??
          '${DateTime.now().microsecondsSinceEpoch}-${Random.secure().nextInt(1 << 30)}',
      amount: amount,
      type: _type,
      category: _category,
      date: _date,
      description: description,
    );
    context.read<FinanceBloc>().add(
      widget.transaction == null
          ? AddTransactionEvent(transaction)
          : UpdateTransactionEvent(transaction),
    );
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: _date.isBefore(DateTime(2000)) ? _date : DateTime(2000),
      lastDate: _date.isAfter(DateTime(2100)) ? _date : DateTime(2100),
      helpText: 'Selecciona la fecha',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );
    if (selected != null && mounted) setState(() => _date = selected);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.transaction != null;
    final dateText = '${_date.day} ${_monthName(_date.month)} ${_date.year}';

    return BlocListener<FinanceBloc, FinanceState>(
      listener: (context, state) {
        if (!_submitting || state is! FinanceLoaded || state.saving) return;
        if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
          setState(() => _submitting = false);
        } else if (state.revision > _revision) {
          Navigator.pop(context);
        }
      },
      child: PopScope(
        canPop: !_submitting,
        child: Scaffold(
          appBar: AppBar(
            title: Text(isEdit ? 'Editar movimiento' : 'Nueva transacción'),
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      'Tipo de movimiento',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<TransactionType>(
                      segments: const [
                        ButtonSegment(
                          value: TransactionType.income,
                          label: Text('Ingreso'),
                          icon: Icon(Icons.arrow_upward),
                        ),
                        ButtonSegment(
                          value: TransactionType.expense,
                          label: Text('Gasto'),
                          icon: Icon(Icons.arrow_downward),
                        ),
                      ],
                      selected: {_type},
                      onSelectionChanged: (value) =>
                          setState(() => _type = value.first),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Monto',
                        prefixText: '\$ ',
                        hintText: '0',
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _category,
                      decoration: const InputDecoration(labelText: 'Categoría'),
                      hint: const Text('Seleccionar categoría'),
                      items: {..._categories, _category}
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _category = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        hintText: 'Escribe una descripción',
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _selectDate,
                      icon: const Icon(Icons.calendar_month),
                      label: Text('Fecha · $dateText'),
                      style: OutlinedButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        foregroundColor: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: _submitting ? null : _save,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          isEdit ? 'Guardar cambios' : 'Guardar movimiento',
                        ),
                      ),
                    ),
                    if (isEdit) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _monthName(int month) => const [
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
  ][month - 1];
}
