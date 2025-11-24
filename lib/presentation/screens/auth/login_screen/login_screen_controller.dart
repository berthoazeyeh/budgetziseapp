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

  @override
  void onInit() {
    super.onInit();
    // _signInWithGoogle();
  }

  Future<void> _signInWithGoogle() async {
    try {
      final authServices = Provider.of<AuthServices>(context, listen: false);
      final token = await authServices.retreiveGoogleToken();
      debugPrint('🔑 Token Google : $token');
    } catch (error) {
      debugPrint('❌ Erreur lors de la connexion : $error');
    }
  }

  Future<void> login() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      UiAlertHelper.showErrorToast(LocaleKeys.auth_please_fill_all_fields.tr());
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
          LocaleKeys.auth_welcome.tr(args: [response.firstName]),
        );
        context.router.push(const OTPVerificationRoute());
        // context.router.replaceAll([const MainShellRoute()]);

        // context..back(const MainShellRoute());
      }
    } catch (e) {
      debugPrint(e.toString());
      if (e is DioNetworkException) {
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
