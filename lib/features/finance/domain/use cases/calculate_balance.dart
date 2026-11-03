import '../../../../core/utils/enums.dart';
import '../entities/balance.dart';
import '../entities/transaction.dart';

class CalculateBalance {
  Balance call(Iterable<FinanceTransaction> transactions) {
    var income = 0;
    var expense = 0;
    for (final transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        income += transaction.amountCents;
      } else {
        expense += transaction.amountCents;
      }
      if (income > 9007199254740991 || expense > 9007199254740991) {
        throw StateError('El total supera el rango monetario admitido');
      }
    }
    return Balance(totalIncome: income / 100, totalExpense: expense / 100);
  }
}
