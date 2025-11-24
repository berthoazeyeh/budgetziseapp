import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/core/graphql/my_graphql_client.dart';
import 'package:budget_zise/data/services/budget_sevices.dart';
import 'package:budget_zise/data/services/dashboard_sevices.dart';
import 'package:budget_zise/data/services/public_sevices.dart';
import 'package:budget_zise/data/services/push_notification_services.dart';
import 'package:budget_zise/domain/repositories/auth_repository.dart';
import 'package:budget_zise/domain/repositories/budget_repository.dart';
import 'package:budget_zise/domain/repositories/dashboard_repository.dart';
import 'package:budget_zise/domain/repositories/public_repository.dart';
import 'package:budget_zise/presentation/cubits/notification_count_cubit.dart';
import 'package:budget_zise/presentation/cubits/platform_stats_cubit.dart';
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
      saveLocale: true,
      useOnlyLangCode: true,
      useFallbackTranslations: kReleaseMode,
      supportedLocales: supportedLocales,
      fallbackLocale: supportedLocales.first,
      // startLocale: const Locale('fr'),
      child: MultiBlocProvider(
        providers: [
          //-----------------------------------------------------------------
          //PROVIDER
          //-----------------------------------------------------------------
          Provider<Logger>.value(value: Logger()),
          Provider<Dio>.value(value: dio),

          //-----------------------------------------------------------------
          //SERVICES
          //-----------------------------------------------------------------
          Provider(create: (_) => LocalStorageService()),
          Provider(create: (_) => PushNotificationService()),
          Provider<AuthServices>(create: (c) => AuthServices(c.read<Dio>())),

          Provider<BudgetServices>(
            create: (c) => BudgetServices(c.read<Dio>()),
          ),

          Provider<PublicServices>(
            create: (c) => PublicServices(c.read<Dio>()),
          ),
          Provider<DashboardServices>(
            create: (c) => DashboardServices(c.read<Dio>()),
          ),

          //-----------------------------------------------------------------
          //REPOSITORIES
          //-----------------------------------------------------------------
          Provider<BudgetRepository>(
            create: (c) => BudgetRepository(
              c.read<BudgetServices>(),
              c.read<LocalStorageService>(),
            ),
          ),
          Provider(
            create: (c) => MyGraphQLClient(c.read<LocalStorageService>()),
          ),
          Provider<DashboardRepository>(
            create: (c) => DashboardRepository(
              c.read<DashboardServices>(),
              c.read<LocalStorageService>(),
            ),
          ),
          Provider<PublicRepository>(
            create: (c) => PublicRepository(c.read<PublicServices>()),
          ),
          Provider<AuthRepository>(
            create: (c) => AuthRepository(
              c.read<AuthServices>(),
              c.read<LocalStorageService>(),
            ),
          ),

          //-----------------------------------------------------------------
          //CUBIT
          //-----------------------------------------------------------------
          BlocProvider(create: (_) => AuthCubit()),
          BlocProvider(
            create: (c) =>
                NotificationCountCubit(c.read<DashboardRepository>()),
          ),
          BlocProvider(create: (_) => ThemeSwitchCubit()),
          BlocProvider(create: (_) => LanguageSwitchCubit()),
          BlocProvider(
            create: (c) => PlatformStatsCubit(c.read<PublicRepository>()),
          ),
        ],
        child: BlocBuilder<ThemeSwitchCubit, ThemeMode>(
          builder: (context, themeMode) =>
              BlocBuilder<LanguageSwitchCubit, Locale>(
                builder: (context, locale) {
                  debugPrint(context.locale.toString());
                  return MaterialApp.router(
                    routerConfig: _appRouter
                        .config(), // ⚠️ Ici on met le router
                    themeMode: themeMode,
                    theme: MyThemes.lightTheme.copyWith(
                      textTheme: GoogleFonts.interTextTheme(
                        Theme.of(context).textTheme,
                      ),
                    ),
                    locale: context.locale,
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
