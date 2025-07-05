part of 'login_screen.dart';

class LoginScreenController extends ScreenController {
  LoginScreenController(super.state);
  bool isLoading = false;
  bool isPasswordVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  void togleVisiblePassword() {
    isPasswordVisible = !isPasswordVisible;
    updateUI();
  }

  Future<void> login() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      UiAlertHelper.showErrorToast('Veuillez remplir tous les champs');
      return;
    }
    try {
      isLoading = true;
      updateUI();
      final localStorageService = Provider.of<LocalStorageService>(
        context,
        listen: false,
      );
      final authRepository = Provider.of<AuthRepository>(
        context,
        listen: false,
      );
      final authCubit = BlocProvider.of<AuthCubit>(context, listen: false);
      final response = await authRepository.login(
        email: emailController.text,
        password: passwordController.text,
      );
      authCubit.setUser(response);
      await localStorageService.setAccessToken(response.token);
      if (context.mounted) {
        UiAlertHelper.showSuccessSnackBar(
          context,
          'Bienvenue ${response.firstName}',
        );
        context.replaceRoute(const MainShellRoute());
      }
    } catch (e) {
      debugPrint(e.toString());
      if (e is NetworkException) {
        UiAlertHelper.showErrorToast(e.message);
      } else {
        UiAlertHelper.showErrorToast(LocaleKeys.network_unknown.tr());
      }
    } finally {
      isLoading = false;
      updateUI();
    }
  }
}
