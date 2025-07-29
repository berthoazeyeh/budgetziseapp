// lib/domain/repositories/auth_repository.dart

import 'package:budget_zise/core/network/api_response.dart';
import 'package:budget_zise/domain/models/user_model.dart';
import 'package:budget_zise/presentation/helpers/dio_helper.dart';

import '../../core/network/api_result.dart';
import '../../core/exceptions/network_exception.dart';
import '../../data/services/auth_services.dart';
import '../../data/services/local_storage_service.dart';

class AuthRepository {
  final AuthServices authService;
  final LocalStorageService localStorageService;

  AuthRepository(this.authService, this.localStorageService);

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    return safeApiCall(
      () =>
          authService.login(email: email, password: password).then((response) {
            final apiResponse = ApiResponse<UserModel>.fromJson(
              response.data,
              (json) => UserModel.fromJson(json),
            );
            return apiResponse.data;
          }),
    );
  }

  Future<UserModel> getUser() async {
    return safeApiCall(
      () => authService.me().then((response) {
        final apiResponse = ApiResponse<UserModel>.fromJson(
          response.data,
          (json) => UserModel.fromJson(json),
        );
        return apiResponse.data;
      }),
    );
  }

  Future<ApiResult<void>> logout() async {
    try {
      await localStorageService.deleteAccessToken();
      return ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(NetworkException(e.toString()).toString());
    }
  }

  Future<ApiResult<void>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return safeApiCall(
      () => authService
          .register(name: name, email: email, password: password)
          .then((response) {
            return ApiResult.success(null);
          }),
    );
  }

  Future<ApiResult<String?>> refreshToken(String refreshToken) async {
    try {
      final response = await authService.refreshToken(
        refreshToken: refreshToken,
      );
      final newAccessToken = response.data['access_token'];

      if (newAccessToken != null) {
        await localStorageService.setAccessToken(newAccessToken);
        return ApiResult.success(newAccessToken);
      }

      return ApiResult.failure("No new access token provided");
    } catch (e) {
      return ApiResult.failure(NetworkException(e.toString()).toString());
    }
  }
}
