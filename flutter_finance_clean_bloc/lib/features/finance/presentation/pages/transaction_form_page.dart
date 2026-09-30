import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/enums.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/finance_bloc.dart';
import '../bloc/finance_event.dart';
import '../bloc/finance_state.dart';

class TransactionFormPage extends StatefulWidget {
  const TransactionFormPage({super.key, this.transaction});
  final FinanceTransaction? transaction;
  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amount, _description;
  late TransactionType _type;
  late String _category;
  late DateTime _date;
  static const _categories = [
    'Alimentación',
    'Transporte',
    'Salario',
    'Entretenimiento',
    'Salud',
    'Compras',
    'Servicios',
    'Otros',
  ];
  @override
  void initState() {
    super.initState();
    final transaction = widget.transaction;
    _amount = TextEditingController(text: transaction?.amount.toString() ?? '');
    _description = TextEditingController(text: transaction?.description ?? '');
    _type = transaction?.type ?? TransactionType.expense;
    _category = _categories.contains(transaction?.category)
        ? transaction!.category
        : _categories.last;
    _date = transaction?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final transaction = FinanceTransaction(
      id:
          widget.transaction?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      amount: double.parse(_amount.text.trim().replaceAll(',', '.')),
      type: _type,
      category: _category,
      date: _date,
      description: _description.text.trim(),
    );
    context.read<FinanceBloc>().add(
      widget.transaction == null
          ? AddTransactionEvent(transaction)
          : UpdateTransactionEvent(transaction),
    );
    Navigator.pop(context);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.transaction != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Editar transacción' : 'Nueva transacción'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  SegmentedButton<TransactionType>(
                    segments: const [
                      ButtonSegment(
                        value: TransactionType.expense,
                        label: Text('Gasto'),
                        icon: Icon(Icons.north_east),
                      ),
                      ButtonSegment(
                        value: TransactionType.income,
                        label: Text('Ingreso'),
                        icon: Icon(Icons.south_west),
                      ),
                    ],
                    selected: {_type},
                    onSelectionChanged: (values) =>
                        setState(() => _type = values.first),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _amount,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Monto',
                      prefixText: '\$ ',
                    ),
                    validator: (value) {
                      final amount = double.tryParse(
                        (value ?? '').trim().replaceAll(',', '.'),
                      );
                      if (amount == null) return 'Ingresa un monto válido';
                      if (amount <= 0) return 'El monto debe ser mayor a 0';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    items: _categories
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
                    validator: (value) => _categories.contains(value)
                        ? null
                        : 'Selecciona una categoría válida',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _description,
                    maxLength: 80,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    validator: (value) {
                      final text = (value ?? '').trim();
                      if (text.isEmpty) {
                        return 'La descripción es obligatoria';
                      }
                      if (text.length < 3) {
                        return 'La descripción debe tener al menos 3 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _selectDate,
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text('${_date.day}/${_date.month}/${_date.year}'),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<FinanceBloc, FinanceState>(
                    builder: (context, state) {
                      final saving = state is FinanceLoaded && state.isSaving;
                      return FilledButton(
                        onPressed: saving ? null : _save,
                        child: saving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                editing
                                    ? 'Guardar cambios'
                                    : 'Guardar transacción',
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
