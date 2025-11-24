part of 'notifications_screen.dart';

class NotificationsScreenController extends ScreenController {
  NotificationsScreenController(super.state, this.languageSwitchCubit);
  final LanguageSwitchCubit languageSwitchCubit;
  bool isLoading = false;
  bool isMutating = false;
  final int limit = 20;
  int nextPage = 1;
  bool unreadNotificationsOnly = false;
  bool hasMoreNotifications = true;
  PaginatedApiResponse<List<NotificationModel>>? notificationPaginate;
  List<NotificationModel> notifications = [];
  final ScrollController scrollController = ScrollController();
  @override
  void onInit() {
    super.onInit();
    if (context.mounted) {
      BlocProvider.of<NotificationCountCubit>(
        context,
        listen: false,
      ).fetchNotificationCount();
    }
    fetchNextNotifications();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (hasMoreNotifications && !isLoading) {
          fetchNextNotifications();
        }
      }
    });
  }

  Future<void> refreshNotifications() async {
    nextPage = 1;
    hasMoreNotifications = true;
    notifications = [];
    updateUI();
    await fetchNextNotifications();
  }

  Future<void> fetchNextNotifications() async {
    if (isLoading || !hasMoreNotifications) {
      return;
    }
    isLoading = true;
    updateUI();
    try {
      final dashboardRepo = Provider.of<DashboardRepository>(
        context,
        listen: false,
      );
      final notificationsResponse = await dashboardRepo.getNotifications(
        page: nextPage,
        limit: limit,
        unreadOnly: unreadNotificationsOnly,
      );
      if (notificationsResponse.data.isNotEmpty) {
        notificationPaginate = notificationsResponse;
        notifications.addAll(notificationsResponse.data);
        nextPage++;
        hasMoreNotifications = nextPage < notificationsResponse.totalPages;
        updateUI();
      }
    } catch (e) {
      if (e is DioNetworkException) {
        UiAlertHelper.showErrorToast(e.message);
      } else {
        UiAlertHelper.showErrorToast(e.toString());
      }
    } finally {
      isLoading = false;
      updateUI();
    }
  }

  Map<String, List<NotificationModel>> groupByDay() {
    notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final Map<String, List<NotificationModel>> groupedNotifications = {};

    for (final notification in notifications) {
      final String dateKey = DateFormat(
        'yyyy-MM-dd',
      ).format(notification.createdAt);
      if (!groupedNotifications.containsKey(dateKey)) {
        groupedNotifications[dateKey] = [];
      }
      groupedNotifications[dateKey]!.add(notification);
    }

    return groupedNotifications;
  }

  Future<void> markAsRead(NotificationModel notification) async {
    if (isMutating) {
      return;
    }
    isMutating = true;
    updateUI();
    try {
      final dashboardRepo = Provider.of<DashboardRepository>(
        context,
        listen: false,
      );
      await dashboardRepo.markNotificationAsRead(notification.id);
    } catch (e) {
      if (e is DioNetworkException) {
        UiAlertHelper.showErrorToast(e.message);
      } else {
        UiAlertHelper.showErrorToast(e.toString());
      }
    } finally {
      isMutating = false;
      updateUI();
    }
  }

  Future<void> markAsUnRead(NotificationModel notification) async {
    if (isMutating) {
      return;
    }
    isMutating = true;
    updateUI();
    try {
      final dashboardRepo = Provider.of<DashboardRepository>(
        context,
        listen: false,
      );
      await dashboardRepo.markNotificationAsUnread(notification.id);
    } catch (e) {
      if (e is DioNetworkException) {
        UiAlertHelper.showErrorToast(e.message);
      } else {
        UiAlertHelper.showErrorToast(e.toString());
      }
    } finally {
      isMutating = false;
      updateUI();
    }
  }

  Future<void> markAllAsRead() async {
    if (isMutating) {
      return;
    }
    isMutating = true;
    updateUI();
    try {
      final dashboardRepo = Provider.of<DashboardRepository>(
        context,
        listen: false,
      );
      await dashboardRepo.markAllNotificationsAsRead();
      UiAlertHelper.showSuccessToast("Notifications marquées comme lues");
      if (context.mounted) {
        BlocProvider.of<NotificationCountCubit>(
          context,
          listen: false,
        ).fetchNotificationCount();
      }
      await refreshNotifications();
    } catch (e) {
      if (e is DioNetworkException) {
        UiAlertHelper.showErrorToast(e.message);
      } else {
        UiAlertHelper.showErrorToast(e.toString());
      }
    } finally {
      isMutating = false;
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
}
