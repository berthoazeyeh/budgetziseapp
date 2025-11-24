// otp_verification_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/core/exceptions/network_exception.dart';
import 'package:budget_zise/domain/repositories/public_repository.dart';
import 'package:budget_zise/presentation/cubits/user_cubit.dart';
import 'package:budget_zise/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

part 'otp_screen_controller.dart';

@RoutePage()
class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenControllerBuilder<OtpScreenController>(
        create: (state) => OtpScreenController(state, vsync: this),
        builder: (context, ctrl) => AnimatedBuilder(
          animation: ctrl.pulseController,
          builder: (context, child) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 60,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: OTPContent(controller: ctrl),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Composant principal du contenu OTP
class OTPContent extends StatelessWidget {
  final OtpScreenController controller;

  const OTPContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundGradient(),
        FloatingParticles(controller: controller),
        MainContentLayout(controller: controller),
        if (controller.isLoading) const LoadingOverlay(),
      ],
    );
  }
}

// Composant pour l'arrière-plan dégradé
class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 250,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.elliptical(200, 100),
            bottomRight: Radius.elliptical(200, 100),
          ),
        ),
      ),
    );
  }
}

// Composant pour les particules flottantes
class FloatingParticles extends StatelessWidget {
  final OtpScreenController controller;

  const FloatingParticles({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.particleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(5, (index) {
            final animation = Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: controller.particleController,
                curve: Interval(index * 0.2, 1.0, curve: Curves.easeInOut),
              ),
            );

            return Positioned(
              top: 100 + (index * 60).toDouble(),
              left: 50 + (index * 50).toDouble(),
              child: Transform.translate(
                offset: Offset(0, -20 * animation.value),
                child: Opacity(
                  opacity: 0.3 + 0.5 * animation.value,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// Composant principal pour la mise en page du contenu
class MainContentLayout extends StatelessWidget {
  final OtpScreenController controller;

  const MainContentLayout({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const BackButton(),
            OTPHeader(controller: controller),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(),
                    const SizedBox(height: 40),
                    if (controller.errorMessage != null)
                      ErrorMessage(message: controller.errorMessage!),
                    OTPInputsSection(controller: controller),
                    const SizedBox(height: 40),
                    TimerWidget(controller: controller),
                    const SizedBox(height: 30),
                    VerifyButton(controller: controller),
                    const SizedBox(height: 20),
                    ResendSection(controller: controller),
                    const SizedBox(height: 10),
                    const FingerprintHint(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Composant pour le bouton retour
class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667EEA).withValues(alpha: 0.2),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF667EEA),
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

// Composant pour l'en-tête OTP
class OTPHeader extends StatelessWidget {
  final OtpScreenController controller;

  const OTPHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final email = context.read<AuthCubit>().getSignedInUser.email;

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Column(
        children: [
          AnimatedBuilder(
            animation: controller.pulseController,
            builder: (context, child) {
              final pulseAnimation = Tween<double>(begin: 1.0, end: 1.05)
                  .animate(
                    CurvedAnimation(
                      parent: controller.pulseController,
                      curve: Curves.easeInOut,
                    ),
                  );

              return Transform.scale(
                scale: pulseAnimation.value,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withValues(alpha: 0.3),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('💳', style: TextStyle(fontSize: 28)),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color.fromARGB(255, 255, 255, 255), Color(0xFF667EEA)],
            ).createShader(bounds),
            child: Text(
              LocaleKeys.otp_screen_title.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            LocaleKeys.otp_screen_subtitle.tr(),
            style: const TextStyle(fontSize: 14, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF667EEA),
            ),
          ),
        ],
      ),
    );
  }
}

// Composant pour le message d'erreur
class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFEF2F2), Color(0xFFFEE2E2)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Color(0xFFDC2626),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Composant pour la section des champs OTP
class OTPInputsSection extends StatelessWidget {
  final OtpScreenController controller;

  const OTPInputsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: OTPInputField(index: index, controller: controller),
        );
      }),
    );
  }
}

// Composant pour un champ de saisie OTP individuel
class OTPInputField extends StatelessWidget {
  final int index;
  final OtpScreenController controller;

  const OTPInputField({
    super.key,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = controller.otpControllers[index].text.isNotEmpty;
    final hasError = controller.errorMessage != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 48,
      height: 60,
      decoration: BoxDecoration(
        color: hasValue && !hasError
            ? null
            : hasError
            ? const Color(0xFFFEF2F2)
            : Colors.white,
        gradient: hasValue && !hasError
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              )
            : null,
        border: Border.all(
          color: hasError
              ? const Color(0xFFEF4444)
              : hasValue
              ? const Color(0xFF667EEA)
              : const Color(0xFFE5E7EB),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          if (hasValue && !hasError)
            BoxShadow(
              color: const Color(0xFF667EEA).withValues(alpha: 0.2),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      transform: hasValue
          // ignore: deprecated_member_use
          ? (Matrix4.identity()..scale(1.05))
          : Matrix4.identity(),
      child: KeyboardListener(
        focusNode: FocusNode(), // FocusNode distinct
        onKeyEvent: (event) {
          if (event.logicalKey == LogicalKeyboardKey.backspace &&
              controller.otpControllers[index].text.isEmpty) {
            if (index > 0) {
              controller.focusNodes[index - 1].requestFocus();
            }
          }
        },
        child: TextField(
          controller: controller.otpControllers[index],
          focusNode: controller.focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: hasValue && !hasError
                ? Colors.white
                : const Color(0xFF1E293B),
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) => controller.onOTPChanged(index, value),
          onTap: () {
            debugPrint('onTap: $index');
            if (controller.otpControllers[index].text.isEmpty) {
              controller.otpControllers[index].selection =
                  TextSelection.fromPosition(const TextPosition(offset: 0));
            }
          },
        ),
      ),
    );
  }
}

// Composant pour le widget de minuterie
class TimerWidget extends StatelessWidget {
  final OtpScreenController controller;

  const TimerWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isExpired = controller.countdown <= 0;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF667EEA).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('⏱️', style: TextStyle(fontSize: 15)),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            isExpired
                ? LocaleKeys.otp_screen_code_expired.tr()
                : LocaleKeys.otp_screen_code_expires_in.tr(
                    args: [controller.formattedTime],
                  ),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isExpired
                  ? const Color(0xFFEF4444)
                  : const Color(0xFF667EEA),
            ),
          ),
        ],
      ),
    );
  }
}

// Composant pour le bouton de vérification
class VerifyButton extends StatelessWidget {
  final OtpScreenController controller;

  const VerifyButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEnabled = controller.isOTPComplete && !controller.isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              )
            : null,
        color: isEnabled ? null : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: const Color(0xFF667EEA).withValues(alpha: 0.3),
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isEnabled ? controller.verifyOTP : null,
          child: Center(
            child: controller.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    LocaleKeys.otp_screen_verify_button.tr(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isEnabled ? Colors.white : const Color(0xFF9CA3AF),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// Composant pour la section de renvoi
class ResendSection extends StatelessWidget {
  final OtpScreenController controller;

  const ResendSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          LocaleKeys.otp_screen_not_received.tr(),
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: controller.canResend && !controller.isLoading
              ? controller.resendOTP
              : null,
          child: Text(
            LocaleKeys.otp_screen_resend_code.tr(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: controller.canResend && !controller.isLoading
                  ? const Color(0xFF667EEA)
                  : const Color(0xFF94A3B8),
              decoration: controller.canResend && !controller.isLoading
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}

// Composant pour l'indice d'empreinte digitale
class FingerprintHint extends StatelessWidget {
  const FingerprintHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('👆', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(
            LocaleKeys.otp_screen_fingerprint_hint.tr(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF059669),
            ),
          ),
        ],
      ),
    );
  }
}

// Composant pour l'overlay de chargement
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: const Center(
        child: CircularProgressIndicator(color: Color(0xFF667EEA)),
      ),
    );
  }
}
