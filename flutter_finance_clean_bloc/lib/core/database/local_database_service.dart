import 'package:hive_flutter/hive_flutter.dart';

/// Owns Hive initialization and the application's single local box.
final class LocalDatabaseService {
  LocalDatabaseService._();
  static final LocalDatabaseService instance = LocalDatabaseService._();
  static const transactionsBox = 'transactions_box';
  Box<Map>? _transactions;

  Future<void> init() async {
    await Hive.initFlutter();
    _transactions = await Hive.openBox<Map>(transactionsBox);
  }

  Box<Map> get transactions {
    final box = _transactions;
    if (box == null || !box.isOpen) {
      throw StateError('LocalDatabaseService.init must complete before use.');
    }
    return box;
  }
}
