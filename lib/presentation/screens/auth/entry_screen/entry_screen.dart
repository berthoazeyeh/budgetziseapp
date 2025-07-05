import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/data/services/local_storage_service.dart';
import 'package:budget_zise/domain/repositories/auth_repository.dart';
import 'package:budget_zise/gen/assets.gen.dart';
import 'package:budget_zise/presentation/cubits/user_cubit.dart';
import 'package:budget_zise/presentation/helpers/ui_alert_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:budget_zise/router/app_router.dart';
import 'package:provider/provider.dart';

@RoutePage()
class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final localStorageService = Provider.of<LocalStorageService>(
        context,
        listen: false,
      );
      final authRepository = Provider.of<AuthRepository>(
        context,
        listen: false,
      );
      final authCubit = BlocProvider.of<AuthCubit>(context, listen: false);

      final accessToken = await localStorageService.getAccessToken();
      if (kDebugMode) {
        print(accessToken);
      }
      if (accessToken != null) {
        final result = await authRepository.getUser();
        // Lecture propre
        final user = result;
        authCubit.setUser(user);
        if (!mounted) return;
        UiAlertHelper.showSuccessSnackBar(
          context,
          'Bienvenue ${user.firstName}',
        );
        context.replaceRoute(const MainShellRoute());
      } else {
        if (!mounted) return;
        context.replaceRoute(const HomeRoute());
      }
    } catch (e) {
      debugPrint(e.toString());
      if (!mounted) return;
      context.replaceRoute(const HomeRoute());
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
                      Assets.images.logo.path,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Budget Zise',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Center(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
