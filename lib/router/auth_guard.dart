import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/data/services/local_storage_service.dart';

class AuthService {
  static final AuthService instance = AuthService();
  bool isLoggedIn = false;
}

class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final token = await LocalStorageService().getAccessToken();
    if (token != null) {
      resolver.next(true);
    } else {
      router.pushPath('/login'); // rediriger
    }
  }
}
