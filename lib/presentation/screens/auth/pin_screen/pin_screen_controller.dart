// pin_screen_controller.dart
part of 'pin_screen.dart';

enum PinStep { create, confirm }

class PinScreenController extends ScreenController {
  final AuthCubit userCubit;

  // Animations
  late AnimationController pulseController;
  late AnimationController particleController;

  // État du PIN
  String _currentPin = '';
  String _firstPin = '';
  bool _isLoading = false;
  String? _errorMessage;
  PinStep _currentStep = PinStep.create;

  // Propriétés calculées
  String get currentPin => _currentPin;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PinStep get currentStep => _currentStep;

  // Détermine si l'utilisateur crée un nouveau PIN ou entre son PIN existant
  bool get isCreatingPin =>
      userCubit.getSignedInUser.pinCode == null ||
      userCubit.getSignedInUser.pinCode!.length < 4;

  // Titres dynamiques basés sur l'état
  String get headerTitle {
    if (isCreatingPin) {
      return _currentStep == PinStep.create
          ? LocaleKeys.pin_screen_pin_create_title.tr()
          : LocaleKeys.pin_screen_pin_confirm_title.tr();
    } else {
      return LocaleKeys.pin_screen_pin_enter_title.tr();
    }
  }

  String get headerSubtitle {
    if (isCreatingPin) {
      return _currentStep == PinStep.create
          ? LocaleKeys.pin_screen_pin_create_subtitle.tr()
          : LocaleKeys.pin_screen_pin_confirm_subtitle.tr();
    } else {
      return LocaleKeys.pin_screen_pin_enter_subtitle.tr();
    }
  }

  Future<void> tryBiometricAuth() async {
    try {
      final localStorageService = Provider.of<LocalStorageService>(
        context,
        listen: false,
      );
      _isLoading = true;
      updateUI();
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
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (didAuthenticate) {
          await localStorageService.setBiometricAuthDate(DateTime.now());
          _onPinVerificationSuccess();
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      updateUI();
    }
  }

  PinScreenController(
    super.screenState, {
    required TickerProvider vsync,
    required this.userCubit,
  }) {
    _initializeAnimations(vsync);
  }

  void _initializeAnimations(TickerProvider vsync) {
    // Animation de pulsation pour l'icône
    pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
    )..repeat(reverse: true);

    // Animation des particules
    particleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: vsync,
    )..repeat();
  }

  // Gestion de la saisie des chiffres
  void onNumberPressed(String number) {
    if (_currentPin.length < 4) {
      _currentPin += number;
      _clearError();
      updateUI();
      // Auto-validation quand le PIN est complet
      if (_currentPin.length == 4) {
        _handleCompletePinEntry();
      }
    }
  }

  // Gestion du backspace
  void onBackspacePressed() {
    if (_currentPin.isNotEmpty) {
      _currentPin = _currentPin.substring(0, _currentPin.length - 1);
      _clearError();
      updateUI();
    }
  }

  // Gestion quand le PIN est complet
  void _handleCompletePinEntry() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (isCreatingPin) {
        _handlePinCreation();
      } else {
        _handlePinVerification();
      }
    });
  }

  // Gestion de la création de PIN
  Future<void> _handlePinCreation() async {
    if (_currentStep == PinStep.create) {
      // Première saisie - stocker et passer à la confirmation
      _firstPin = _currentPin;
      _currentPin = '';
      _currentStep = PinStep.confirm;
      updateUI();
    } else {
      // Confirmation - vérifier la correspondance
      if (_firstPin == _currentPin) {
        _savePinToUser();
      } else {
        _setError(LocaleKeys.pin_screen_pin_error_mismatch.tr());
        _resetCurrentPin();
      }
    }
  }

  // Gestion de la vérification du PIN
  void _handlePinVerification() {
    final userPin = userCubit.getSignedInUser.pinCode;
    if (userPin == _currentPin) {
      _onPinVerificationSuccess();
    } else {
      _setError(LocaleKeys.pin_screen_pin_error_incorrect.tr());
      _resetCurrentPin();
      _vibrateError();
    }
  }

  // Sauvegarder le PIN pour l'utilisateur
  void _savePinToUser() async {
    _setLoading(true);

    try {
      final res = await context.read<DashboardRepository>().updatePin(
        _currentPin,
      );
      if (res) {
        _onPinCreationSuccess();
      } else {
        _setError(LocaleKeys.pin_screen_pin_error_save.tr());
        _resetCurrentPin();
      }
    } catch (e) {
      if (e is NetworkException) {
        _setError(e.message);
      } else {
        _setError(e.toString());
      }
      _resetCurrentPin();
    } finally {
      _setLoading(false);
    }
  }

  // Succès de la création du PIN
  void _onPinCreationSuccess() {
    UiAlertHelper.showSuccessSnackBar(
      context,
      LocaleKeys.auth_welcome.tr(args: [userCubit.getSignedInUser.firstName]),
    );
    userCubit.setUser(userCubit.getSignedInUser.copyWith(pinCode: _currentPin));
    context.router.replaceAll([const MainShellRoute()]);
  }

  // Succès de la vérification du PIN
  void _onPinVerificationSuccess() {
    UiAlertHelper.showSuccessSnackBar(
      context,
      LocaleKeys.auth_welcome.tr(args: [userCubit.getSignedInUser.firstName]),
    );
    context.router.replaceAll([const MainShellRoute()]);
  }

  // Réinitialiser la création de PIN
  void resetPinCreation() {
    _firstPin = '';
    _currentPin = '';
    _currentStep = PinStep.create;
    _clearError();
    updateUI();
  }

  // Afficher les options pour PIN oublié
  void showForgotPinOptions() {
    // Afficher un dialog avec les options de récupération
    // - Utiliser l'empreinte digitale
    // - Répondre aux questions de sécurité
    // - Réinitialiser via SMS/Email
    debugPrint('Afficher les options de récupération du PIN');
  }

  // Méthodes utilitaires
  void _setLoading(bool loading) {
    _isLoading = loading;
    updateUI();
  }

  void _setError(String error) {
    _errorMessage = error;
    updateUI();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      updateUI();
    }
  }

  void _resetCurrentPin() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      _currentPin = '';
      updateUI();
    });
  }

  void _vibrateError() {
    // Vibration pour indiquer une erreur
    HapticFeedback.mediumImpact();
  }

  @override
  void onDispose() {
    pulseController.dispose();
    particleController.dispose();
    super.onDispose();
  }
}
