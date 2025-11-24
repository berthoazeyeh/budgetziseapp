import 'package:budget_zise/budget_zise.dart'
    show
        EasyLocalization,
        getApplicationDocumentsDirectory,
        Hive,
        HydratedBloc,
        HydratedStorage,
        HydratedStorageDirectory,
        getTemporaryDirectory,
        initializeDateFormatting,
        setPathUrlStrategy;
import 'package:budget_zise/data/services/notification_service.dart';
import 'package:budget_zise/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InitApplication {
  static Future<void> initMyApplication() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    if (kIsWeb) {
      setPathUrlStrategy();
    } else {
      final appDir = await getApplicationDocumentsDirectory();
      Hive.init(appDir.path);
    }
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await NotificationService.init();
    await Future.wait([EasyLocalization.ensureInitialized()], eagerError: true);
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorageDirectory.web
          : HydratedStorageDirectory((await getTemporaryDirectory()).path),
    );

    await initializeDateFormatting('fr_FR', null);
  }
}
