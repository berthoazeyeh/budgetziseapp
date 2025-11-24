import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/data/services/local_storage_service.dart';
import 'package:budget_zise/data/services/push_notification_services.dart';
import 'package:budget_zise/domain/repositories/auth_repository.dart';
import 'package:budget_zise/domain/repositories/public_repository.dart';
import 'package:budget_zise/gen/assets.gen.dart';
import 'package:budget_zise/presentation/cubits/notification_count_cubit.dart';
import 'package:budget_zise/presentation/cubits/user_cubit.dart';
import 'package:budget_zise/presentation/helpers/ui_alert_helper.dart';
import 'package:flutter/material.dart';
import 'package:budget_zise/router/app_router.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';

@RoutePage()
class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  bool hasError = false;
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<bool> tryBiometricAuth() async {
    try {
      final localStorageService = Provider.of<LocalStorageService>(
        context,
        listen: false,
      );

      final LocalAuthentication auth = LocalAuthentication();
      final List<BiometricType> availableBiometrics = await auth
          .getAvailableBiometrics();
      debugPrint(availableBiometrics.toString());
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      if (canAuthenticate) {
        final didAuthenticate = await auth.authenticate(
          localizedReason: LocaleKeys.auth_please_authenticate.tr(),
          biometricOnly: true,
        );
        if (didAuthenticate) {
          await localStorageService.setBiometricAuthDate(DateTime.now());
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> _checkAuthStatus() async {
    try {
      final authRepository = Provider.of<AuthRepository>(
        context,
        listen: false,
      );
      final authCubit = BlocProvider.of<AuthCubit>(context, listen: false);

      final pushNotificationService = Provider.of<PushNotificationService>(
        context,
        listen: false,
      );
      final publicRepository = Provider.of<PublicRepository>(
        context,
        listen: false,
      );
      final localStorageService = Provider.of<LocalStorageService>(
        context,
        listen: false,
      );
      setState(() {
        hasError = false;
      });

      final accessToken = await localStorageService.getAccessToken();

      if (accessToken != null && mounted) {
        await pushNotificationService.init(
          BlocProvider.of<NotificationCountCubit>(context, listen: false),
        );
        final result = await authRepository.getUser();
        // Lecture propre
        final user = result;
        authCubit.setUser(user);
        final fcmToken = await localStorageService.getFcmToken();
        if (fcmToken == null || fcmToken.isEmpty || user.fcmToken != fcmToken) {
          final fcmToken = await pushNotificationService.getFcmToken();
          if (fcmToken != null) {
            final result = await publicRepository.updateFcmToken(fcmToken);
            if (result) {
              await localStorageService.setFcmToken(fcmToken);
              authCubit.setUser(user.copyWith(fcmToken: fcmToken));
            }
          }
        }

        final biometricAuthDate = await localStorageService
            .getBiometricAuthDate();
        if (biometricAuthDate == null ||
            DateTime.now().difference(biometricAuthDate).inMinutes > 5) {
          debugPrint('biometricAuthDate: $biometricAuthDate');
          final result = await tryBiometricAuth();
          if (result) {
            await localStorageService.setBiometricAuthDate(DateTime.now());
            if (!mounted) {
              return;
            }
            context.replaceRoute(const MainShellRoute());
            return;
          } else {
            await localStorageService.deleteBiometricAuthDate();
            if (!mounted) {
              return;
            }
            context.replaceRoute(const PinRoute());
            return;
          }
        }
        if (mounted) {
          UiAlertHelper.showSuccessSnackBar(
            context,
            LocaleKeys.auth_welcome.tr(args: [user.firstName]),
          );
          context.replaceRoute(const MainShellRoute());
        }
      } else {
        if (!mounted) {
          return;
        }
        context.replaceRoute(const HomeRoute());
      }
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) {
        return;
      }
      setState(() {
        hasError = true;
      });
      // context.replaceRoute(const HomeRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Image.asset(
                      MyAssets.images.logo.path,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  LocaleKeys.home_app_name.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Center(
                child: Visibility(
                  visible: !hasError,
                  replacement: InkWell(
                    onTap: _checkAuthStatus,
                    child: Text(
                      LocaleKeys.auth_refresh.tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
