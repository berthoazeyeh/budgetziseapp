part of 'budget_screen.dart';

class BudgetScreenController extends ScreenController {
  BudgetScreenController(super.state, this.languageSwitchCubit, this.userCubit);
  final LanguageSwitchCubit languageSwitchCubit;
  final AuthCubit userCubit;
  bool isLoading = true;
  List<CategoryBudget> budget = [];
  @override
  void onInit() {
    super.onInit();
    getBudget();
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
      isLoading = true;
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
      isLoading = false;
      updateUI();
    }
  }
}
