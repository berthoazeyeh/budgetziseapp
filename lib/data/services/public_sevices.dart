import 'dart:io';

import 'package:budget_zise/constants/my_strings.dart';
import 'package:budget_zise/core/network/api_response.dart';
import 'package:budget_zise/data/dto/platform_stats.dart';
import 'package:budget_zise/domain/models/country.dart';
import 'package:budget_zise/domain/models/transaction_type.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'public_sevices.g.dart';

@RestApi(baseUrl: MyStrings.baseUrl)
abstract class PublicServices {
  factory PublicServices(Dio dio) = _PublicServices;

  @POST('/api/public/updateFcmToken')
  Future<ApiResponse<bool>> updateFcmToken(@Query('fcmToken') String fcmToken);

  @POST('/api/public/updateUserFcmToken')
  Future<ApiResponse<bool>> updateUserFcmToken(
    @Query('fcmToken') String fcmToken,
    @Query('userId') int userId,
  );

  @POST('/api/public/upload')
  @MultiPart()
  Future<UploadResponse> uploadFile(@Part(name: 'file') File file);

  @GET('/api/public/countrys')
  Future<ApiResponse<List<Country>>> getCountrys();

  @GET('/api/Category')
  Future<ApiResponse<List<TransactionType>>> getCategories();

  @GET('/api/Recharge/typeRecharges')
  Future<ApiResponse<List<TransactionType>>> getRechargeTypes();
  @GET('/api/public/stats')
  Future<ApiResponse<PlatformStats>> getAppStats();

  @POST('/api/public/verifyOtp')
  Future<ApiResponse<bool>> verifyOtp(
    @Query('enteredOtp') String otp,
    @Query('userId') String userId,
  );
}

class UploadResponse {
  final String url;

  UploadResponse({required this.url});

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(url: json['url']);
  }
  Map<String, String> toJson() => {'url': url};
}
