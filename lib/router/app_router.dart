import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/presentation/screens/auth/home_screen/home_screen.dart';
import 'package:budget_zise/presentation/screens/home/budget_screen/budget_screen.dart';
import 'package:budget_zise/presentation/screens/home/profil_screen/profil_screen.dart';
import 'package:budget_zise/presentation/screens/home/transaction_screen/transaction_screen.dart';
import 'package:budget_zise/presentation/screens/settings/principal_settings_screen/principal_settings_screen.dart';
import '../presentation/screens/home/dashboard_screen/dashboard_screen.dart';
import '../profile_page.dart';
import '../presentation/screens/auth/entry_screen/entry_screen.dart';
import '../presentation/screens/auth/login_screen/login_screen.dart';
import 'auth_guard.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final _authGuard = AuthGuard();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: EntryRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: HomeRoute.page, path: '/home'),
    // Home parent route
    AutoRoute(
      page: MainShellRoute.page,
      guards: [_authGuard],
      children: [
        AutoRoute(page: DashboardRoute.page, path: 'dashboard', initial: true),
        AutoRoute(page: BudgetRoute.page, path: 'budget'),
        AutoRoute(page: TransactionRoute.page, path: 'transaction'),
        AutoRoute(page: ProfileRoute.page, path: 'profile'),
      ],
    ),
    AutoRoute(page: PrincipalSettingsRoute.page, path: '/settings'),
  ];
}
