part of 'transaction_screen.dart';

typedef Period = ({DateTime startDate, DateTime endDate});
typedef CategorieType = ({TransactionType transactionType, bool isRecharge});

class TransactionScreenController extends ScreenController {
  TransactionScreenController(
    super.state,
    this.languageSwitchCubit,
    this.userCubit,
  );
  final LanguageSwitchCubit languageSwitchCubit;
  final AuthCubit userCubit;
  final int limit = 5;
  int nextPage = 1;
  bool hasMoreTransactions = true;
  PaginatedApiResponse<List<Transaction>>? transactionPaginate;
  List<Transaction> transactions = [];
  final ScrollController scrollController = ScrollController();
  int selectedPeriod = 0;
  final List<String> periods = ['Aujourd\'hui', 'Cette semaine', 'Ce mois'];
  TransactionsStats? transactionsStats;
  bool isLoadingTransactions = false;
  bool isLoadingTransactionsStats = false;
  bool isLoadingCategories = false;
  List<TransactionType> categories = [];
  List<TransactionType> rechargeType = [];
  int? selectedCategoryId;
  @override
  void onInit() {
    super.onInit();
    getTransactionsStats();
    getNextTransactions();
    getCategories();
    scrollController.addListener(onScrollListener);
  }

  void changeCategory(int categoryId) {
    selectedCategoryId = categoryId;
    context.router.pop();
    refreshTransactions();
    updateUI();
  }

  void onScrollListener() {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (currentScroll == maxScroll && hasMoreTransactions) {
      debugPrint('onScrollListener');
      getNextTransactions();
    }
  }

  Future<void> refreshTransactions() async {
    nextPage = 1;
    hasMoreTransactions = true;
    transactions = [];
    updateUI();
    Future.wait([getTransactionsStats(), getNextTransactions()]);
  }

  Future<void> getTransactionsStats() async {
    try {
      isLoadingTransactionsStats = true;
      updateUI();
      final budgetRepository = Provider.of<DashboardRepository>(
        context,
        listen: false,
      );
      final res = await budgetRepository.getTransactionsStats(
        startDate: getPeriod(selectedPeriod).startDate.toUtc(),
        endDate: getPeriod(selectedPeriod).endDate.toUtc(),
        categoryId: selectedCategoryId,
      );
      transactionsStats = res;
    } catch (e) {
      if (e is NetworkException) {
        UiAlertHelper.showErrorToast(e.message);
      } else {
        UiAlertHelper.showErrorToast(LocaleKeys.network_unknown.tr());
      }
    } finally {
      isLoadingTransactionsStats = false;
      updateUI();
    }
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
        limit: limit,
        page: nextPage,
        startDate: getPeriod(selectedPeriod).startDate.toUtc(),
        endDate: getPeriod(selectedPeriod).endDate.toUtc(),
        categoryId: selectedCategoryId,
      );
      transactionPaginate = res;
      transactions.addAll(res.data);
      if (res.data.length < limit) {
        hasMoreTransactions = false;
      } else {
        hasMoreTransactions = true;
        nextPage++;
      }
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

  String formatRelativeDate(DateTime date) {
    final moment = Moment(
      date,
      localization: getMomentLocalization(
        locale: languageSwitchCubit.currentLocale,
      ),
    );
    return moment.calendar(omitHours: true, customFormat: 'dddd, DD MMMM YYYY');
  }

  Map<String, List<Transaction>> groupByDate() {
    Map<String, List<Transaction>> groupedTransactions = {};

    for (var transaction in transactions) {
      String dateKey = DateFormat('yyyy-MM-dd').format(transaction.date);
      if (!groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey] = [];
      }
      groupedTransactions[dateKey]!.add(transaction);
    }

    // Trier chaque groupe par date (plus récent en premier)
    groupedTransactions.forEach((key, transactions) {
      transactions.sort((a, b) => b.date.compareTo(a.date));
    });

    // Trier les groupes par date (plus récent en premier)
    var sortedEntries = groupedTransactions.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return Map.fromEntries(sortedEntries);
  }

  void changePeriod(int index) {
    selectedPeriod = index;
    refreshTransactions();
  }

  void getCategories() async {
    try {
      isLoadingCategories = true;
      updateUI();
      final publicRepository = Provider.of<PublicRepository>(
        context,
        listen: false,
      );
      categories = await publicRepository.getCategories();
      rechargeType = await publicRepository.getRechargeTypes();
      updateUI();
    } catch (e) {
      if (e is NetworkException) {
        UiAlertHelper.showErrorToast(e.message);
      } else {
        UiAlertHelper.showErrorToast(LocaleKeys.network_unknown.tr());
      }
    } finally {
      isLoadingCategories = false;
      updateUI();
    }
  }

  Period getPeriod(int index) {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(
      now.year,
      now.month,
      now.day,
    ); // aujourd'hui à minuit

    switch (index) {
      case 0:
        // Aujourd'hui
        return (startDate: startOfDay, endDate: now);
      case 1:
        // Début de la semaine courante (lundi)
        int daysSinceMonday = now.weekday - DateTime.monday;
        DateTime startOfWeek = startOfDay.subtract(
          Duration(days: daysSinceMonday),
        );
        return (startDate: startOfWeek, endDate: now);
      case 2:
        // Début du mois courant
        DateTime startOfMonth = DateTime(now.year, now.month, 1);
        return (startDate: startOfMonth, endDate: now);
      default:
        return (startDate: startOfDay, endDate: now);
    }
  }
}
