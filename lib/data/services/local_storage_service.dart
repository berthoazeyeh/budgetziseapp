import 'dart:async';

import 'package:hive_ce/hive.dart';

final class LocalStorageService {
  LocalStorageService();

  final _boxName = 'local_storage';
  final _accessTokenKey = 'access_token';
  final _isNotFirstTime = 'is_not_first_time';

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
}
