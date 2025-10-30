part of 'otp_screen.dart';

class OtpScreenController extends ScreenController {
  bool _isLoading = false;
  String? _errorMessage;
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final TickerProvider vsync;
  OtpScreenController(super.state, {required this.vsync});
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  late AnimationController pulseController;
  late AnimationController particleController;

  @override
  void onInit() {
    super.onInit();
    startTimer();

    pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
    )..repeat();

    particleController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: vsync,
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNodes[0].requestFocus();
    });
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Timer? _timer;
  int _countdown = 120; // 2 minutes
  bool _canResend = false;

  List<TextEditingController> get otpControllers => _otpControllers;
  List<FocusNode> get focusNodes => _focusNodes;
  int get countdown => _countdown;
  bool get canResend => _canResend;

  String get formattedTime {
    final minutes = _countdown ~/ 60;
    final seconds = _countdown % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get isOTPComplete {
    return _otpControllers.every((controller) => controller.text.isNotEmpty);
  }

  String get otpCode {
    return _otpControllers.map((c) => c.text).join();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    updateUI();
  }

  void setError(String? error) {
    _errorMessage = error;
    updateUI();
  }

  void clearError() {
    _errorMessage = null;
    updateUI();
  }

  void startTimer() {
    _countdown = 60 * 5;
    _canResend = false;
    updateUI();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        _countdown--;
        updateUI();
      } else {
        _canResend = true;
        timer.cancel();
        updateUI();
      }
    });
  }

  void onOTPChanged(int index, String value) {
    debugPrint('onOTPChanged: $index, $value , ${value.isEmpty}');
    if (value.isEmpty) {
      return;
    }

    // Ensure only digits
    if (!RegExp(r'^\d$').hasMatch(value)) {
      _otpControllers[index].clear();
      return;
    }
    setError(null);
    // Move to next field
    if (index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else {
      _focusNodes[index].unfocus();
      // Auto-verify if complete
      if (isOTPComplete) {
        Future.delayed(const Duration(milliseconds: 500), () {
          verifyOTP();
        });
      }
    }
    updateUI();
  }

  void onBackspace(int index) {
    if (_otpControllers[index].text.isEmpty && index > 0) {
      _otpControllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      updateUI();
    }
  }

  void pasteOTP(String text) {
    final digits = text.replaceAll(RegExp(r'[^\d]'), '');
    for (int i = 0; i < digits.length && i < 6; i++) {
      _otpControllers[i].text = digits[i];
    }
    updateUI();
  }

  Future<void> verifyOTP() async {
    if (!isOTPComplete) return;

    setLoading(true);
    clearError();

    try {
      final publicRepository = context.read<PublicRepository>();
      final userId = context.read<AuthCubit>().getSignedInUser.id;
      final bool isVerified = await publicRepository.verifyOtp(otpCode, userId);

      if (isVerified) {
        // Success - in real app, navigate to next screen
        HapticFeedback.lightImpact();
        if (context.mounted) {
          context.router.replaceAll([const MainShellRoute()]);
        }
        // Navigation logic here
      } else {
        // Error
        setError(LocaleKeys.otp_screen_error_incorrect.tr());
        clearOTPFields();
        HapticFeedback.heavyImpact();
        _focusNodes[0].requestFocus();
      }
    } catch (e) {
      if (e is NetworkException) {
        setError(e.message);
      } else {
        setError(LocaleKeys.otp_screen_error_network.tr());
      }
    } finally {
      setLoading(false);
    }
  }

  Future<void> resendOTP() async {
    if (!_canResend) return;

    setLoading(true);
    clearError();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      clearOTPFields();
      startTimer();
      _focusNodes[0].requestFocus();
      HapticFeedback.selectionClick();
    } catch (e) {
      setError(LocaleKeys.otp_screen_error_send.tr());
    } finally {
      setLoading(false);
    }
  }

  void clearOTPFields() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    updateUI();
  }

  @override
  void onDispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    pulseController.dispose();
    particleController.dispose();
    super.onDispose();
  }
}
