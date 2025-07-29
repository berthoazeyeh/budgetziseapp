import 'dart:io';

import 'package:budget_zise/data/dto/platform_stats.dart';
import 'package:budget_zise/data/services/public_sevices.dart';
import 'package:budget_zise/domain/models/country.dart';
import 'package:budget_zise/domain/models/transaction_type.dart';
import 'package:budget_zise/presentation/helpers/dio_helper.dart';

class PublicRepository {
  final PublicServices publicServices;

  PublicRepository(this.publicServices);

  Future<List<Country>> getCountrys() async {
    return safeApiCall(
      () => publicServices.getCountrys().then((response) {
        return response.data;
      }),
    );
  }

  Future<List<TransactionType>> getCategories() async {
    return safeApiCall(
      () => publicServices.getCategories().then((response) {
        return response.data;
      }),
    );
  }

  Future<List<TransactionType>> getRechargeTypes() async {
    return safeApiCall(
      () => publicServices.getRechargeTypes().then((response) {
        return response.data;
      }),
    );
  }

  Future<PlatformStats> getAppStats() async {
    return safeApiCall(
      () => publicServices.getAppStats().then((response) {
        return response.data;
      }),
    );
  }

  Future<bool> updateFcmToken(String fcmToken) async {
    return safeApiCall(
      () => publicServices.updateFcmToken(fcmToken).then((response) {
        return response.data;
      }),
    );
  }

  Future<bool> updateUserFcmToken(String fcmToken, int userId) async {
    return safeApiCall(
      () =>
          publicServices.updateUserFcmToken(fcmToken, userId).then((response) {
            return response.data;
          }),
    );
  }

  Future<UploadResponse> uploadFile(File file) async {
    return safeApiCall(
      () => publicServices.uploadFile(file).then((response) {
        return response;
      }),
    );
  }

  Future<bool> verifyOtp(String otp, int userId) async {
    return safeApiCall(
      () => publicServices.verifyOtp(otp, userId.toString()).then((response) {
        return response.data;
      }),
    );
  }
}
