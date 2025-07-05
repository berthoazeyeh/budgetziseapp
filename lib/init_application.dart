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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InitApplication {
  static Future<void> initMyApplication() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    if (kIsWeb) {
      setPathUrlStrategy();
    } else {
      var appDir = await getApplicationDocumentsDirectory();
      Hive.init(appDir.path);
    }
    await Future.wait([EasyLocalization.ensureInitialized()], eagerError: true);
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorageDirectory.web
          : HydratedStorageDirectory((await getTemporaryDirectory()).path),
    );

    await initializeDateFormatting('fr_FR', null);
  }
}
