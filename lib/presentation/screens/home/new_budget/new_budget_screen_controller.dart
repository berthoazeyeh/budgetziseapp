part of 'new_budget_screen.dart';

class NewBudgetScreenController extends ScreenController {
  NewBudgetScreenController(
    super.context,
    this.vsync,
    this.languageSwitchCubit,
    this.userCubit,
  );
  final AuthCubit userCubit;
  final LanguageSwitchCubit languageSwitchCubit;
  final TickerProvider vsync;
  List<TransactionType> expencesTypes = [];
  bool isLoadingExpensesTypes = false;
  final TextEditingController budgetNameController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController singleCategoryAmountController =
      TextEditingController();
  TabController? _tabController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String selectedPeriod = 'Mensuel';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 30));

  // Pour l'onglet catégorie unique
  String selectedSingleCategory = 'Alimentation';

  final List<String> periods = [
    'Hebdomadaire',
    'Mensuel',
    'Trimestriel',
    'Annuel',
    'Personnalisé',
  ];

  final List<Map<String, dynamic>> budgetCategories = [
    {
      'name': 'Alimentation',
      'icon': '🍕',
      'amount': 0.0,
      'color': const Color(0xFFFF6B6B),
    },
    {
      'name': 'Transport',
      'icon': '🚗',
      'amount': 0.0,
      'color': const Color(0xFF4ECDC4),
    },
    {
      'name': 'Loisirs',
      'icon': '🎯',
      'amount': 0.0,
      'color': const Color(0xFF45B7D1),
    },
    {
      'name': 'Logement',
      'icon': '🏠',
      'amount': 0.0,
      'color': const Color(0xFF96CEB4),
    },
    {
      'name': 'Santé',
      'icon': '💊',
      'amount': 0.0,
      'color': const Color(0xFFFECE2F),
    },
    {
      'name': 'Vêtements',
      'icon': '👕',
      'amount': 0.0,
      'color': const Color(0xFFFF8A65),
    },
    {
      'name': 'Épargne',
      'icon': '💰',
      'amount': 0.0,
      'color': const Color(0xFF9C88FF),
    },
    {
      'name': 'Autres',
      'icon': '📦',
      'amount': 0.0,
      'color': const Color(0xFFE17055),
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _tabController = TabController(length: 2, vsync: vsync);
    getExpensesTypes();
  }

  void getExpensesTypes() async {
    try {
      isLoadingExpensesTypes = true;
      updateUI();
      final publicRepository = Provider.of<PublicRepository>(
        context,
        listen: false,
      );
      final categories = await publicRepository.getCategories();
      expencesTypes = categories;
      updateUI();
    } catch (e) {
      if (e is DioNetworkException) {
        UiAlertHelper.showErrorToast(e.message);
      } else {
        UiAlertHelper.showErrorToast(LocaleKeys.network_unknown.tr());
      }
    } finally {
      isLoadingExpensesTypes = false;
      updateUI();
    }
  }

  Color getSelectedCategoryColor() {
    final category = budgetCategories.firstWhere(
      (cat) => cat['name'] == selectedSingleCategory,
      orElse: () => budgetCategories.first,
    );
    return category['color'];
  }

  String getSelectedCategoryIcon() {
    final category = budgetCategories.firstWhere(
      (cat) => cat['name'] == selectedSingleCategory,
      orElse: () => budgetCategories.first,
    );
    return category['icon'];
  }

  void updateDateRange() {
    switch (selectedPeriod) {
      case 'Hebdomadaire':
        endDate = startDate.add(const Duration(days: 7));
        break;
      case 'Mensuel':
        endDate = DateTime(startDate.year, startDate.month + 1, startDate.day);
        break;
      case 'Trimestriel':
        endDate = DateTime(startDate.year, startDate.month + 3, startDate.day);
        break;
      case 'Annuel':
        endDate = DateTime(startDate.year + 1, startDate.month, startDate.day);
        break;
    }
    updateUI();
  }

  Future<void> selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      startDate = date;
      updateDateRange();
      updateUI();
    }
  }

  Future<void> selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: startDate,
      lastDate: DateTime(2030),
    );
    if (date != null) {
      endDate = date;
      updateUI();
    }
  }

  double getTotalAllocated() {
    return 90;
  }

  double getRemainingAmount() {
    final totalBudget = double.tryParse(totalAmountController.text) ?? 0.0;
    return totalBudget - getTotalAllocated();
  }

  void saveBudget() {
    Navigator.pop(context);
  }

  @override
  void onDispose() {
    super.onDispose();
  }
}
