import '../../../../core/use_cases/usecase.dart';
import '../../../../core/utils/enums.dart';
import '../entities/balance.dart';
import '../entities/transaction.dart';

final class CalculateBalance
    implements UseCase<Balance, List<FinanceTransaction>> {
  @override
  Future<Balance> call(List<FinanceTransaction> transactions) async {
    var income = 0.0;
    var expense = 0.0;
    for (final transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        income += transaction.amount;
      } else {
        expense += transaction.amount;
      }
    }
    return Balance(totalIncome: income, totalExpense: expense);
  }
}
