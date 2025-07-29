import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/presentation/componends/my_bottom_nav_bar.dart';
import 'package:budget_zise/presentation/screens/auth/home_screen/home_screen.dart';
import 'package:budget_zise/presentation/screens/auth/otp_screen/otp_screen.dart';
import 'package:budget_zise/presentation/screens/auth/pin_screen/pin_screen.dart';
import 'package:budget_zise/presentation/screens/home/budget_screen/budget_screen.dart';
import 'package:budget_zise/presentation/screens/home/new_budget/new_budget_screen.dart';
import 'package:budget_zise/presentation/screens/home/new_savings_goal_screen/new_savings_goal_screen.dart';
import 'package:budget_zise/presentation/screens/home/new_transaction/new_transaction_screen.dart';
import 'package:budget_zise/presentation/screens/home/savings_goals_screen/savings_goals_screen.dart';
import 'package:budget_zise/presentation/screens/home/statistique_screen/statistique_screen.dart';
import 'package:budget_zise/presentation/screens/profiles/change_password/change_password.dart';
import 'package:budget_zise/presentation/screens/profiles/profil_screen/profil_screen.dart';
import 'package:budget_zise/presentation/screens/home/transaction_screen/transaction_screen.dart';
import 'package:budget_zise/presentation/screens/profiles/edit_profil_screen/edit_profil_screen.dart';
import 'package:budget_zise/presentation/screens/settings/notifications_screen/notifications_screen.dart';
import 'package:budget_zise/presentation/screens/settings/principal_settings_screen/principal_settings_screen.dart';
import '../presentation/screens/home/dashboard_screen/dashboard_screen.dart';
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
    AutoRoute(
      page: OTPVerificationRoute.page,
      path: '/otp-verification',
      guards: [_authGuard],
    ),
    AutoRoute(page: PinRoute.page, path: '/pin', guards: [_authGuard]),
    // Home parent route
    AutoRoute(
      page: MainShellRoute.page,
      guards: [_authGuard],
      children: [
        AutoRoute(
          page: DashboardRoute.page,
          path: 'dashboard',
          initial: true,
          guards: [_authGuard],
        ),
        AutoRoute(page: BudgetRoute.page, path: 'budget', guards: [_authGuard]),
        AutoRoute(
          page: TransactionRoute.page,
          path: 'transaction',
          guards: [_authGuard],
        ),

        AutoRoute(
          page: ProfilRoute.page,
          path: 'profile',
          guards: [_authGuard],
        ),
      ],
    ),
    AutoRoute(
      page: PrincipalSettingsRoute.page,
      path: '/settings',
      guards: [_authGuard],
    ),
    AutoRoute(
      page: EditProfilRoute.page,
      path: '/edit-profil',
      guards: [_authGuard],
    ),
    AutoRoute(
      page: ChangePasswordRoute.page,
      path: '/change-password',
      guards: [_authGuard],
    ),
    AutoRoute(
      page: NewTransactionRoute.page,
      path: '/new-transaction',
      guards: [_authGuard],
    ),
    AutoRoute(
      page: CreateBudgetRoute.page,
      path: '/create-budget',
      guards: [_authGuard],
    ),
    AutoRoute(
      page: StatisticsRoute.page,
      path: '/statistics',
      guards: [_authGuard],
    ),
    AutoRoute(
      page: NotificationsRoute.page,
      path: '/notifications',
      guards: [_authGuard],
    ),
    AutoRoute(
      page: SavingsGoalsRoute.page,
      path: '/savings-goals',
      guards: [_authGuard],
    ),
    AutoRoute(
      page: NewSavingsGoalRoute.page,
      path: '/new-savings-goal',
      guards: [_authGuard],
    ),
  ];
}
