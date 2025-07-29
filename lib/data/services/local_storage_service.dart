import 'dart:async';

import 'package:hive_ce/hive.dart';

final class LocalStorageService {
  LocalStorageService();

  final _boxName = 'local_storage';
  final _accessTokenKey = 'access_token';
  final _fcmTokenKey = 'fcm_token';
  final _isNotFirstTime = 'is_not_first_time';
  final _biometricAuthDate = 'biometric_auth_date';
  Box<String>? _boxObj;

  Future<Box<String>> _getBox() async {
    if (_boxObj == null) {
      if (Hive.isBoxOpen(_boxName)) {
        _boxObj = Hive.box<String>(_boxName);
      } else {
        _boxObj = await Hive.openBox<String>(_boxName);
      }
    }

    return _boxObj!;
  }

  Future<void> clearAll() async {
    final box = await _getBox();
    final isNotFirstTimeVal = box.get(_isNotFirstTime);
    await box.clear();
    if (isNotFirstTimeVal != null) box.put(_isNotFirstTime, isNotFirstTimeVal);
  }

  //////////////// Access Token ///////////
  Future<void> setAccessToken(String accessToken) async {
    final box = await _getBox();
    return box.putAll({_accessTokenKey: accessToken});
  }

  Future<String?> getAccessToken() async {
    final box = await _getBox();
    return box.get(_accessTokenKey);
  }

  Future<void> deleteAccessToken() async {
    final box = await _getBox();
    box.delete(_accessTokenKey);
  }

  //////////////// Access Token ///////////
  Future<void> setFcmToken(String fcmToken) async {
    final box = await _getBox();
    return box.putAll({_fcmTokenKey: fcmToken});
  }

  Future<String?> getFcmToken() async {
    final box = await _getBox();
    return box.get(_fcmTokenKey);
  }

  Future<void> deleteFcmToken() async {
    final box = await _getBox();
    box.delete(_fcmTokenKey);
  }

  //////////////// Biometric Auth ///////////
  Future<void> setBiometricAuthDate(DateTime date) async {
    final box = await _getBox();
    return box.putAll({_biometricAuthDate: date.toIso8601String()});
  }

  Future<DateTime?> getBiometricAuthDate() async {
    final box = await _getBox();
    final date = box.get(_biometricAuthDate);
    return date != null ? DateTime.parse(date) : null;
  }

  Future<void> deleteBiometricAuthDate() async {
    final box = await _getBox();
    box.delete(_biometricAuthDate);
  }
}
