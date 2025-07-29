import 'package:budget_zise/data/services/budget_sevices.dart';
import 'package:budget_zise/data/services/local_storage_service.dart';
import 'package:budget_zise/domain/models/category_budget.dart';
import 'package:budget_zise/presentation/helpers/dio_helper.dart';

class BudgetRepository {
  final BudgetServices budgetService;
  final LocalStorageService localStorageService;
  BudgetRepository(this.budgetService, this.localStorageService);

  Future<List<CategoryBudget>> getBudget() async {
    return safeApiCall(
      () => budgetService.getBudgetCategory().then((response) {
        return response.data;
      }),
    );
  }
}
