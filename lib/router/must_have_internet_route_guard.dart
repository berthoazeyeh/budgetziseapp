import 'package:auto_route/auto_route.dart';

import 'package:budget_zise/data/services/connectivity_service.dart';
import 'package:budget_zise/router/app_router.dart';

/// MustHaveInternetRouteGuard is used to protect routes that require internet access.
class MustHaveInternetRouteGuard extends AutoRouteGuard {
  final ConnectivityService connectivityService;

  const MustHaveInternetRouteGuard(this.connectivityService) : super();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final isInternetOk = connectivityService.isInternetOk;
    if (isInternetOk) {
      resolver.next(true);
    } else {
      router.replaceAll([const LoginRoute()]);
    }
  }
}
