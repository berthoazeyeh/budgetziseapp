import 'package:budget_zise/constants/my_strings.dart';
import 'package:budget_zise/core/network/api_response.dart';
import 'package:budget_zise/domain/models/category_budget.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'budget_sevices.g.dart';

@RestApi(baseUrl: MyStrings.baseUrl)
abstract class BudgetServices {
  factory BudgetServices(Dio dio) = _BudgetServices;

  @GET('/api/SimpleUser/myBudget')
  Future<ApiResponse<dynamic>> getBudget();

  @GET('/api/CategoryBudget/myBudget')
  Future<ApiResponse<List<CategoryBudget>>> getBudgetCategory();
}
