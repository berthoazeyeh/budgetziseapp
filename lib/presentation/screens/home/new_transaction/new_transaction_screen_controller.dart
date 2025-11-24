part of 'new_transaction_screen.dart';

class NewTransactionScreenController extends ScreenController {
  NewTransactionScreenController(
    super.context,
    this.vsync,
    this.languageSwitchCubit,
    this.userCubit,
  );
  final LanguageSwitchCubit languageSwitchCubit;
  final TickerProvider vsync;
  final AuthCubit userCubit;
  final formKeyExpense = GlobalKey<FormState>();
  final formKeyIncome = GlobalKey<FormState>();
  List<TransactionType> rechargeTypes = [];
  List<TransactionType> expencesTypes = [];
  TabController? _tabController;
  bool isLoadingRechargeTypes = false;
  bool isLoadingExpensesTypes = false;
  bool isMutating = false;
  final TextEditingController amountIncomeController = TextEditingController();
  final TextEditingController amountExpenseController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  int selectedCategoryIncome = 1;
  int selectedCategoryExpense = 1;
  DateTime selectedDate = DateTime.now();
  String selectedPaymentMethod = 'Cash';
  XFile? receiptImage;
  void onDateSelected(DateTime date) {
    selectedDate = date;
    updateUI();
  }

  void onReceiptImageSelected(XFile? image) {
    receiptImage = image;
    updateUI();
  }

  void onPaymentMethodSelected(String paymentMethod) {
    selectedPaymentMethod = paymentMethod;
    updateUI();
  }

  Future<void> saveIncome() async {
    if (isMutating) {
      return;
    }
    if (!(formKeyIncome.currentState?.validate() ?? false)) {
      UiAlertHelper.showErrorToast('Veuillez remplir tous les champs');
      return;
    }
    if (rechargeTypes.isEmpty) {
      UiAlertHelper.showErrorToast('Veuillez ajouter une recharge');
      return;
    }
    try {
      isMutating = true;
      updateUI();
      final dashboardRepository = Provider.of<DashboardRepository>(
        context,
        listen: false,
      );
      final result = await dashboardRepository.addRecharge(
        RechargeRequest(
          amount: double.parse(amountIncomeController.text),
          transactionReference: descriptionController.text,
          paymentMethod: selectedPaymentMethod,
          rechargeDate: selectedDate,
          typeRechargeId: selectedCategoryIncome,
        ),
      );
      if (result && context.mounted) {
        UiAlertHelper.showSuccessToast('Recharge ajoutée avec succès');
        context.router.back();
      } else {
        UiAlertHelper.showErrorToast("Erreur lors de l'ajout de la recharge");
      }
    } catch (e) {
      if (e is DioNetworkException) {
        UiAlertHelper.showErrorToast(e.message);
      } else {
        UiAlertHelper.showErrorToast(LocaleKeys.network_unknown.tr());
      }
    } finally {
      isMutating = false;
      updateUI();
    }
  }

  Future<void> saveExpense() async {
    if (isMutating) {
      return;
    }
    if (!(formKeyExpense.currentState?.validate() ?? false)) {
      UiAlertHelper.showErrorToast('Veuillez remplir tous les champs');
      return;
    }
    if (expencesTypes.isEmpty) {
      UiAlertHelper.showErrorToast('Veuillez ajouter une dépense');
      return;
    }
    try {
      isMutating = true;
      updateUI();
      final publicRepository = Provider.of<PublicRepository>(
        context,
        listen: false,
      );
      final dashboardRepository = Provider.of<DashboardRepository>(
        context,
        listen: false,
      );
      String? receiptUrl;
      if (receiptImage != null) {
        final res = await publicRepository.uploadFile(File(receiptImage!.path));
        receiptUrl = res.url;
      }

      final result = await dashboardRepository.addExpense(
        userCubit.getSignedInUser.id,
        AddExpenseRequest(
          amount: double.parse(amountExpenseController.text),
          description: descriptionController.text,
          categeryId: selectedCategoryExpense,
          paymentMethod: selectedPaymentMethod,
          place: locationController.text,
          receiptUrl: receiptUrl,
        ),
      );
      if (result && context.mounted) {
        UiAlertHelper.showSuccessToast('Dépense ajoutée avec succès');
        context.router.back();
      } else {
        UiAlertHelper.showErrorToast("Erreur lors de l'ajout de la dépense");
      }
    } catch (e) {
      if (e is DioNetworkException) {
        UiAlertHelper.showErrorToast(e.message);
      } else {
        UiAlertHelper.showErrorToast(LocaleKeys.network_unknown.tr());
      }
    } finally {
      isMutating = false;
      updateUI();
    }
  }

  void onCategorySelectedIncome(int categoryId) {
    selectedCategoryIncome = categoryId;
    updateUI();
  }

  void onCategorySelectedExpense(int categoryId) {
    selectedCategoryExpense = categoryId;
    updateUI();
  }

  @override
  void onInit() {
    super.onInit();
    _tabController = TabController(length: 2, vsync: vsync);
    getCategories();
    getExpensesTypes();
  }

  void getCategories() async {
    try {
      isLoadingRechargeTypes = true;
      updateUI();
      final publicRepository = Provider.of<PublicRepository>(
        context,
        listen: false,
      );
      final categories = await publicRepository.getRechargeTypes();
      rechargeTypes = categories;
      updateUI();
    } catch (e) {
      if (e is DioNetworkException) {
        UiAlertHelper.showErrorToast(e.message);
      } else {
        UiAlertHelper.showErrorToast(LocaleKeys.network_unknown.tr());
      }
    } finally {
      isLoadingRechargeTypes = false;
      updateUI();
    }
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

  @override
  void onDispose() {
    super.onDispose();
    _tabController?.dispose();
  }
}
