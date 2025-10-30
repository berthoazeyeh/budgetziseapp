// pin_screen.dart
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/core/exceptions/network_exception.dart';
import 'package:budget_zise/data/services/local_storage_service.dart';
import 'package:budget_zise/domain/models/user_model.dart';
import 'package:budget_zise/domain/repositories/dashboard_repository.dart';
import 'package:budget_zise/presentation/cubits/user_cubit.dart';
import 'package:budget_zise/presentation/helpers/ui_alert_helper.dart';
import 'package:budget_zise/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

part 'pin_screen_controller.dart';

@RoutePage()
class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final userCubit = BlocProvider.of<AuthCubit>(context);
    debugPrint(
      "userCubit.getSignedInUser.pinCode: ${userCubit.getSignedInUser.pinCode}",
    );
    return BlocBuilder<AuthCubit, UserModel?>(
      builder: (context, state) {
        return Scaffold(
          body: ScreenControllerBuilder<PinScreenController>(
            create: (state) =>
                PinScreenController(state, vsync: this, userCubit: userCubit),
            builder: (context, ctrl) => AnimatedBuilder(
              animation: ctrl.pulseController,
              builder: (context, child) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A1A2E),
                        Color(0xFF16213E),
                        Color(0xFF0F3460),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: PinContent(controller: ctrl, userCubit: userCubit),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// Composant principal du contenu PIN
class PinContent extends StatelessWidget {
  final PinScreenController controller;
  final AuthCubit userCubit;

  const PinContent({
    super.key,
    required this.controller,
    required this.userCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundElements(),
        FloatingParticles(controller: controller),
        MainPinLayout(controller: controller),
        if (controller.isLoading) const LoadingOverlay(),
      ],
    );
  }
}

// Composant pour les éléments d'arrière-plan
class BackgroundElements extends StatelessWidget {
  const BackgroundElements({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Cercles décoratifs
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF4ECDC4).withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -150,
          left: -150,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF45B7D1).withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Composant pour les particules flottantes
class FloatingParticles extends StatelessWidget {
  final PinScreenController controller;

  const FloatingParticles({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.particleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(8, (index) {
            final animation = Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: controller.particleController,
                curve: Interval(index * 0.125, 1.0, curve: Curves.easeInOut),
              ),
            );

            return Positioned(
              top: 150 + (index * 80).toDouble(),
              left: 30 + (index * 45).toDouble(),
              child: Transform.translate(
                offset: Offset(
                  10 * sin(animation.value * 2 * pi),
                  -30 * animation.value,
                ),
                child: Opacity(
                  opacity:
                      0.2 +
                      0.6 * animation.value, // 0.2 + 0.6 * animation.value
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4ECDC4),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF4ECDC4),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
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
class MainPinLayout extends StatelessWidget {
  final PinScreenController controller;

  const MainPinLayout({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        children: [
          const CustomBackButton(),
          const SizedBox(height: 5),
          PinHeader(controller: controller),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  if (controller.errorMessage != null)
                    ErrorMessage(message: controller.errorMessage!),
                  const SizedBox(height: 10),
                  PinDotsDisplay(controller: controller),
                  const SizedBox(height: 30),
                  PinKeypad(controller: controller),
                  const SizedBox(height: 15),
                  if (controller.isCreatingPin &&
                      controller.currentStep == PinStep.confirm)
                    ResetPinButton(controller: controller),
                  if (!controller.isCreatingPin)
                    ForgotPinButton(controller: controller),
                  if (!controller.isCreatingPin)
                    BiometricHint(controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Composant pour le bouton retour personnalisé
class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E).withValues(alpha: 0.8),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4ECDC4).withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF4ECDC4),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

// Composant pour l'en-tête PIN
class PinHeader extends StatelessWidget {
  final PinScreenController controller;

  const PinHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: controller.pulseController,
          builder: (context, child) {
            final pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
              CurvedAnimation(
                parent: controller.pulseController,
                curve: Curves.easeInOut,
              ),
            );

            return Transform.scale(
              scale: pulseAnimation.value,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4ECDC4), Color(0xFF45B7D1)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4ECDC4).withValues(alpha: 0.4),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Text(
          controller.headerTitle,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          controller.headerSubtitle,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.7),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Composant pour le message d'erreur
class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6B6B).withValues(alpha: 0.1),
            const Color(0xFFEE5A24).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFFF6B6B), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFFFF6B6B),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Composant pour l'affichage des points PIN
class PinDotsDisplay extends StatelessWidget {
  final PinScreenController controller;

  const PinDotsDisplay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isActive = index < controller.currentPin.length;
        final hasError = controller.errorMessage != null;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? hasError
                      ? const Color(0xFFFF6B6B)
                      : const Color(0xFF4ECDC4)
                : Colors.transparent,
            border: Border.all(
              color: hasError
                  ? const Color(0xFFFF6B6B)
                  : isActive
                  ? const Color(0xFF4ECDC4)
                  : Colors.white.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: isActive && !hasError
                ? [
                    BoxShadow(
                      color: const Color(0xFF4ECDC4).withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}

// Composant pour le clavier PIN
class PinKeypad extends StatelessWidget {
  final PinScreenController controller;

  const PinKeypad({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Première ligne: 1, 2, 3
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 1; i <= 3; i++)
              PinKeypadButton(
                number: i.toString(),
                onTap: () => controller.onNumberPressed(i.toString()),
              ),
          ],
        ),
        const SizedBox(height: 10),
        // Deuxième ligne: 4, 5, 6
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 4; i <= 6; i++)
              PinKeypadButton(
                number: i.toString(),
                onTap: () => controller.onNumberPressed(i.toString()),
              ),
          ],
        ),
        const SizedBox(height: 10),
        // Troisième ligne: 7, 8, 9
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 7; i <= 9; i++)
              PinKeypadButton(
                number: i.toString(),
                onTap: () => controller.onNumberPressed(i.toString()),
              ),
          ],
        ),
        const SizedBox(height: 10),
        // Quatrième ligne: vide, 0, effacer
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 60), // Espace vide
            PinKeypadButton(
              number: '0',
              onTap: () => controller.onNumberPressed('0'),
            ),
            PinKeypadButton(
              icon: Icons.backspace_outlined,
              onTap: controller.onBackspacePressed,
            ),
          ],
        ),
      ],
    );
  }
}

// Composant pour un bouton du clavier PIN
class PinKeypadButton extends StatelessWidget {
  final String? number;
  final IconData? icon;
  final VoidCallback onTap;

  const PinKeypadButton({
    super.key,
    this.number,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1A1A2E).withValues(alpha: 0.6),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: onTap,
          child: Center(
            child: number != null
                ? Text(
                    number!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    icon,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 24,
                  ),
          ),
        ),
      ),
    );
  }
}

// Composant pour le bouton de réinitialisation du PIN
class ResetPinButton extends StatelessWidget {
  final PinScreenController controller;

  const ResetPinButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: controller.resetPinCreation,
      child: Text(
        LocaleKeys.pin_screen_pin_reset.tr(),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF4ECDC4).withValues(alpha: 0.8),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

// Composant pour le bouton PIN oublié
class ForgotPinButton extends StatelessWidget {
  final PinScreenController controller;

  const ForgotPinButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: controller.showForgotPinOptions,
      child: Text(
        LocaleKeys.pin_screen_pin_forgot.tr(),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white.withValues(alpha: 0.6),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

// Composant pour l'indice biométrique
class BiometricHint extends StatelessWidget {
  final PinScreenController controller;
  const BiometricHint({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.tryBiometricAuth(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF4ECDC4).withValues(alpha: 0.1),
              const Color(0xFF45B7D1).withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF4ECDC4).withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fingerprint, color: Color(0xFF4ECDC4), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                LocaleKeys.pin_screen_pin_biometric_hint.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
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
      color: Colors.black.withValues(alpha: 0.5),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4ECDC4),
          strokeWidth: 3,
        ),
      ),
    );
  }
}
