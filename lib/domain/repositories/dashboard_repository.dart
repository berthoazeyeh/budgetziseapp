import 'package:budget_zise/core/network/api_response.dart';
import 'package:budget_zise/data/dto/add_contribution_request.dart';
import 'package:budget_zise/data/dto/create_goal_request.dart';
import 'package:budget_zise/data/dto/create_notification_request.dart';
import 'package:budget_zise/data/dto/savings_statistics_dto.dart';
import 'package:budget_zise/data/dto/update_goal_request.dart';
import 'package:budget_zise/data/services/dashboard_sevices.dart';
import 'package:budget_zise/data/services/local_storage_service.dart';
import 'package:budget_zise/data/ui_model/add_expense_request.dart';
import 'package:budget_zise/data/ui_model/recharge_request.dart';
import 'package:budget_zise/domain/models/goal_progress.dart';
import 'package:budget_zise/domain/models/notification_model.dart';
import 'package:budget_zise/domain/models/transaction.dart';
import 'package:budget_zise/presentation/helpers/dio_helper.dart';

class DashboardRepository {
  final DashboardServices dashboardService;
  final LocalStorageService localStorageService;
  DashboardRepository(this.dashboardService, this.localStorageService);

  Future<PaginatedApiResponse<List<Transaction>>> getTransactions({
    required int page,
    required int limit,
    int? categoryId,
    int? incomeTypeId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return safeApiCall(
      () => dashboardService
          .getTransactions(
            page: page,
            limit: limit,
            categoryId: categoryId,
            incomeTypeId: incomeTypeId,
            endDate: endDate,
            startDate: startDate,
          )
          .then((response) {
            return response;
          }),
    );
  }

  Future<dynamic> addExpense(int userId, AddExpenseRequest request) async {
    return safeApiCall(
      () => dashboardService.addExpense(userId, request).then((response) {
        return response.data;
      }),
    );
  }

  Future<dynamic> addRecharge(RechargeRequest request) async {
    return safeApiCall(
      () => dashboardService.addRecharge(request).then((response) {
        return response.data;
      }),
    );
  }

  Future<TransactionsStats> getTransactionsStats({
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
    int? incomeTypeId,
  }) async {
    return safeApiCall(
      () => dashboardService
          .getTransactionsStats(
            startDate: startDate,
            endDate: endDate,
            categoryId: categoryId,
            incomeTypeId: incomeTypeId,
          )
          .then((response) {
            return response.data;
          }),
    );
  }

  Future<bool> updatePin(String pinCode) async {
    return safeApiCall(
      () => dashboardService.updatePin(pinCode).then((response) {
        return response.data;
      }),
    );
  }
  //-------------------------------------------------------------
  // GOALS  Begin
  //----------------------------------------------------------------

  Future<List<GoalProgressModel>> getGoals() async {
    return safeApiCall(
      () => dashboardService.getGoals().then((response) {
        return response.data;
      }),
    );
  }

  Future<SavingsStatisticsDto> getGoalsStats() async {
    return safeApiCall(
      () => dashboardService.getGoalsStats().then((response) {
        return response.data;
      }),
    );
  }

  Future<dynamic> createGoals(CreateGoalRequest request) async {
    return safeApiCall(
      () => dashboardService.createGoals(request).then((response) {
        return response.data;
      }),
    );
  }

  Future<dynamic> updateGoals(int id, UpdateGoalRequest request) async {
    return safeApiCall(
      () => dashboardService.updateGoals(id, request).then((response) {
        return response.data;
      }),
    );
  }

  Future<dynamic> deleteGoals(int id) async {
    return safeApiCall(
      () => dashboardService.deleteGoals(id).then((response) {
        return response.data;
      }),
    );
  }

  Future<dynamic> pauseGoals(int id) async {
    return safeApiCall(
      () => dashboardService.pauseGoals(id).then((response) {
        return response.data;
      }),
    );
  }

  Future<dynamic> resumeGoals(int id) async {
    return safeApiCall(
      () => dashboardService.resumeGoals(id).then((response) {
        return response.data;
      }),
    );
  }

  Future<dynamic> completeGoals(int id) async {
    return safeApiCall(
      () => dashboardService.completeGoals(id).then((response) {
        return response.data;
      }),
    );
  }

  Future<dynamic> cancelGoals(int id) async {
    return safeApiCall(
      () => dashboardService.cancelGoals(id).then((response) {
        return response.data;
      }),
    );
  }

  Future<dynamic> addContribution(
    int id,
    AddContributionRequest request,
  ) async {
    return safeApiCall(
      () => dashboardService.addContribution(id, request).then((response) {
        return response.data;
      }),
    );
  }

  //-------------------------------------------------------------
  // GOALS  End
  //----------------------------------------------------------------

  //-------------------------------------------------------------
  // Notifications  Begin
  //----------------------------------------------------------------

  Future<PaginatedApiResponse<List<NotificationModel>>> getNotifications({
    int page = 1,
    int limit = 10,
    bool unreadOnly = false,
  }) async {
    return safeApiCall(
      () => dashboardService
          .getNotifications(page: page, limit: limit, unreadOnly: unreadOnly)
          .then((response) {
            return response;
          }),
    );
  }

  Future<bool> createNotification(CreateNotificationRequest request) async {
    return safeApiCall(
      () => dashboardService.createNotification(body: request).then((response) {
        return response.data;
      }),
    );
  }

  Future<bool> markNotificationAsRead(int id) async {
    return safeApiCall(
      () => dashboardService.markNotificationAsRead(id: id).then((response) {
        return response.data;
      }),
    );
  }

  Future<bool> markNotificationAsUnread(int id) async {
    return safeApiCall(
      () => dashboardService.markNotificationAsUnread(id: id).then((response) {
        return response.data;
      }),
    );
  }

  Future<int> getUnreadNotificationsCount() async {
    return safeApiCall(
      () => dashboardService.getUnreadNotificationsCount().then((response) {
        return response.data;
      }),
    );
  }

  Future<bool> markAllNotificationsAsRead() async {
    return safeApiCall(
      () => dashboardService.markAllNotificationsAsRead().then((response) {
        return response.data;
      }),
    );
  }

  //-------------------------------------------------------------
  // Notifications  End
  //----------------------------------------------------------------
}
