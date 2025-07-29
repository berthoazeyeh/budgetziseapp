import 'package:budget_zise/constants/my_strings.dart';
import 'package:budget_zise/core/network/api_response.dart';
import 'package:budget_zise/data/dto/add_contribution_request.dart';
import 'package:budget_zise/data/dto/create_goal_request.dart';
import 'package:budget_zise/data/dto/create_notification_request.dart';
import 'package:budget_zise/data/dto/savings_statistics_dto.dart';
import 'package:budget_zise/data/dto/update_goal_request.dart';
import 'package:budget_zise/data/ui_model/add_expense_request.dart';
import 'package:budget_zise/data/ui_model/recharge_request.dart';
import 'package:budget_zise/domain/models/goal_progress.dart';
import 'package:budget_zise/domain/models/notification_model.dart';
import 'package:budget_zise/domain/models/transaction.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'dashboard_sevices.g.dart';

@RestApi(baseUrl: MyStrings.baseUrl)
abstract class DashboardServices {
  factory DashboardServices(Dio dio) = _DashboardServices;

  @GET('/api/SimpleUser/update-pin')
  Future<ApiResponse<bool>> updatePin(@Query('pinCode') String pinCode);

  @GET('/api/Dashboard/dashboard')
  Future<ApiResponse<dynamic>> getDashboard();
  @GET('/api/SimpleUser/myTransactions')
  Future<PaginatedApiResponse<List<Transaction>>> getTransactions({
    @Query('page') required int page,
    @Query('pageSize') required int limit,
    @Query('categoryId') int? categoryId,
    @Query('startDate') DateTime? startDate,
    @Query('endDate') DateTime? endDate,
    @Query('incomeTypeId') int? incomeTypeId,
  });

  @GET('/api/SimpleUser/myTransactionsStats')
  Future<ApiResponse<TransactionsStats>> getTransactionsStats({
    @Query('startDate') DateTime? startDate,
    @Query('endDate') DateTime? endDate,
    @Query('incomeTypeId') int? incomeTypeId,
    @Query('categoryId') int? categoryId,
  });

  @GET('/api/SimpleUser/lasted-transaction-stats')
  Future<ApiResponse<dynamic>> getLastedTransactionStats();

  @POST('/api/SimpleUser/AddEspences/{userId}')
  Future<ApiResponse<bool>> addExpense(
    @Path('userId') int userId,
    @Body() AddExpenseRequest body,
  );

  @POST('/api/Recharge')
  Future<ApiResponse<bool>> addRecharge(@Body() RechargeRequest body);

  //-------------------------------------------------------------
  // GOALS  Begin
  //----------------------------------------------------------------
  @GET('/api/SavingsGoals')
  Future<ApiResponse<List<GoalProgressModel>>> getGoals();
  @GET('/api/SavingsGoals/statistics')
  Future<ApiResponse<SavingsStatisticsDto>> getGoalsStats();
  @POST('/api/SavingsGoals')
  Future<ApiResponse<dynamic>> createGoals(@Body() CreateGoalRequest body);

  @PUT('/api/SavingsGoals/{id}')
  Future<ApiResponse<dynamic>> updateGoals(
    @Path('id') int id,
    @Body() UpdateGoalRequest body,
  );

  @DELETE('/api/SavingsGoals/{id}')
  Future<ApiResponse<dynamic>> deleteGoals(@Path('id') int id);

  @POST('/api/SavingsGoals/{id}/pause')
  Future<ApiResponse<dynamic>> pauseGoals(@Path('id') int id);

  @POST('/api/SavingsGoals/{id}/resume')
  Future<ApiResponse<dynamic>> resumeGoals(@Path('id') int id);

  @POST('/api/SavingsGoals/{id}/complete')
  Future<ApiResponse<dynamic>> completeGoals(@Path('id') int id);

  @POST('/api/SavingsGoals/{id}/cancel')
  Future<ApiResponse<dynamic>> cancelGoals(@Path('id') int id);

  @POST('/api/SavingsGoals/{id}/contributions')
  Future<ApiResponse<dynamic>> addContribution(
    @Path('id') int id,
    @Body() AddContributionRequest body,
  );
  //-------------------------------------------------------------
  // GOALS  End
  //----------------------------------------------------------------

  //-------------------------------------------------------------
  // Notifications  Begin
  //----------------------------------------------------------------

  @GET('/api/Notifications')
  Future<PaginatedApiResponse<List<NotificationModel>>> getNotifications({
    @Query('page') required int page,
    @Query('pageSize') required int limit,
    @Query('unreadOnly') required bool unreadOnly,
  });
  @POST('/api/Notifications')
  Future<ApiResponse<bool>> createNotification({
    @Body() required CreateNotificationRequest body,
  });
  @POST('/api/Notifications/{id}/mark-as-read')
  Future<ApiResponse<bool>> markNotificationAsRead({
    @Path('id') required int id,
  });
  @POST('/api/Notifications/{id}/mark-as-unread')
  Future<ApiResponse<bool>> markNotificationAsUnread({
    @Path('id') required int id,
  });

  @GET('/api/Notifications/unread-count')
  Future<ApiResponse<int>> getUnreadNotificationsCount();

  @POST('/api/Notifications/mark-all-as-read')
  Future<ApiResponse<bool>> markAllNotificationsAsRead();
  //-------------------------------------------------------------
  // Notifications  End
  //----------------------------------------------------------------
}

class TransactionsStats {
  final double totalExpenses;
  final double totalRecharges;

  TransactionsStats({
    required this.totalExpenses,
    required this.totalRecharges,
  });

  factory TransactionsStats.fromJson(Map<String, dynamic> json) {
    return TransactionsStats(
      totalExpenses: double.parse(json['totalExpenses'].toString()),
      totalRecharges: double.parse(json['totalRecharges'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {'totalExpenses': totalExpenses, 'totalRecharges': totalRecharges};
  }
}
