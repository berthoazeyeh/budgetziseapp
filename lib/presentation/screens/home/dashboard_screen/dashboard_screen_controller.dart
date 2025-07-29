part of 'dashboard_screen.dart';

class DashboardScreenController extends ScreenController {
  DashboardScreenController(super.state);
  List<Transaction> transactions = [];
  bool isLoadingTransactions = false;
  bool isLoadingBudget = false;
  List<CategoryBudget> budget = [];
  @override
  void onInit() {
    super.onInit();
    getNextTransactions();
    getBudget();
  }

  Future<void> refreshTransactions() async {
    transactions.clear();
    budget.clear();
    await Future.wait([getNextTransactions(), getBudget()]);
    updateUI();
  }

  Future<void> getNextTransactions() async {
    try {
      isLoadingTransactions = true;
      updateUI();
      final budgetRepository = Provider.of<DashboardRepository>(
        context,
        listen: false,
      );

      final res = await budgetRepository.getTransactions(
        limit: 15,
        page: 1,
        startDate: DateTime.now().subtract(const Duration(days: 30)).toUtc(),
        endDate: DateTime.now().toUtc(),
        categoryId: null,
      );
      transactions.addAll(res.data);
    } catch (e) {
      if (e is NetworkException) {
        UiAlertHelper.showErrorToast(e.message);
      } else {
        UiAlertHelper.showErrorToast(LocaleKeys.network_unknown.tr());
      }
    } finally {
      isLoadingTransactions = false;
      updateUI();
    }
  }

  double getExpencesTotal() {
    return budget.fold(0.0, (sum, category) => sum + category.totalExpenses);
  }

  double getBudgetTotal() {
    return budget.fold(0.0, (sum, category) => sum + category.allocatedAmount);
  }

  double getExpencePercentage() {
    return (getExpencesTotal() / getBudgetTotal()) * 100;
  }

  Future<void> getBudget() async {
    try {
      isLoadingBudget = true;
      updateUI();
      final budgetRepository = Provider.of<BudgetRepository>(
        context,
        listen: false,
      );
      final response = await budgetRepository.getBudget();
      budget = response;
      debugPrint('budget: ${budget.length}');
      updateUI();
    } catch (e) {
      if (e is NetworkException) {
        UiAlertHelper.showErrorToast(e.message);
      } else {
        UiAlertHelper.showErrorToast(e.toString());
      }
    } finally {
      isLoadingBudget = false;
      updateUI();
    }
  }
}
