import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfoService {
  static DeviceInfoService? _instance;
  static DeviceInfoService get instance => _instance ??= DeviceInfoService._();
  DeviceInfoService._();

  String? _deviceId;
  Map<String, dynamic>? _deviceInfo;

  Future<String> getDeviceId() async {
    if (_deviceId != null) {
      return _deviceId!;
    }

    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      _deviceId = androidInfo.id; // ID unique Android
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      _deviceId = iosInfo.identifierForVendor; // ID unique iOS
    } else {
      _deviceId = 'web_${DateTime.now().millisecondsSinceEpoch}';
    }

    return _deviceId!;
  }

  Future<Map<String, dynamic>> getDeviceInfo() async {
    if (_deviceInfo != null) {
      return _deviceInfo!;
    }

    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();

    final Map<String, dynamic> info = {
      'appVersion': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
      'packageName': packageInfo.packageName,
      'platform': Platform.operatingSystem,
    };

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      info.addAll({
        'deviceModel': androidInfo.model,
        'deviceManufacturer': androidInfo.manufacturer,
        'osVersion': androidInfo.version.release,
        'sdkVersion': androidInfo.version.sdkInt,
        'brand': androidInfo.brand,
      });
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      info.addAll({
        'deviceModel': iosInfo.model,
        'deviceName': iosInfo.name,
        'osVersion': iosInfo.systemVersion,
        'isPhysicalDevice': iosInfo.isPhysicalDevice,
      });
    }

    _deviceInfo = info;
    return info;
  }
}
