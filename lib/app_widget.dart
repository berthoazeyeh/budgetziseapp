import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/core/network/dio_client.dart';
import 'package:budget_zise/domain/repositories/auth_repository.dart';
import 'package:budget_zise/providers/language_switch_cubit.dart';
import 'package:budget_zise/providers/theme_switch_cubit.dart';
import 'package:budget_zise/router/app_router.dart';
import 'package:budget_zise/data/services/auth_services.dart';
import 'package:budget_zise/data/services/local_storage_service.dart';
import 'package:budget_zise/presentation/cubits/user_cubit.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'config/my_themes.dart';

class AppWidget extends StatelessWidget {
  AppWidget({super.key, required this.dio});

  final _appRouter = AppRouter();

  final Dio dio;

  @override
  Widget build(BuildContext context) {
    const supportedLocales = [Locale('fr'), Locale('en')];

    return EasyLocalization(
      path: kIsWeb ? 'i18n' : 'assets/i18n',
      saveLocale: false,
      useOnlyLangCode: true,
      useFallbackTranslations: kReleaseMode,
      supportedLocales: supportedLocales,
      fallbackLocale: supportedLocales.first,
      child: MultiBlocProvider(
        providers: [
          Provider<Logger>.value(value: Logger()),
          Provider<LocalStorageService>.value(value: LocalStorageService()),
          Provider<Dio>.value(value: dio),

          BlocProvider(create: (_) => AuthCubit()),
          BlocProvider(create: (_) => ThemeSwitchCubit()),
          BlocProvider(create: (_) => LanguageSwitchCubit()),
          Provider<AuthServices>(create: (_) => AuthServices(DioClient(dio))),
          Provider<AuthRepository>(
            create: (c) => AuthRepository(
              c.read<AuthServices>(),
              c.read<LocalStorageService>(),
            ),
          ),
        ],
        child: BlocBuilder<ThemeSwitchCubit, ThemeMode>(
          builder: (context, themeMode) =>
              BlocBuilder<LanguageSwitchCubit, Locale>(
                builder: (context, locale) {
                  return MaterialApp.router(
                    routerConfig: _appRouter
                        .config(), // ⚠️ Ici on met le router
                    themeMode: themeMode,
                    theme: MyThemes.lightTheme,
                    locale: locale,
                    darkTheme: MyThemes.lightTheme, // ou AppThemes.darkTheme
                    builder: EasyLoading.init(),
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                  );
                },
              ),
        ),
      ),
    );
  }
}
