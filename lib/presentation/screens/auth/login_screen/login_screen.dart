import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/constants/my_strings.dart';
import 'package:budget_zise/core/exceptions/network_exception.dart';
import 'package:budget_zise/data/services/auth_services.dart';
import 'package:budget_zise/data/services/local_storage_service.dart';
import 'package:budget_zise/domain/repositories/auth_repository.dart';
import 'package:budget_zise/gen/assets.gen.dart';
import 'package:budget_zise/router/app_router.dart';
import 'package:budget_zise/presentation/cubits/user_cubit.dart';
import 'package:budget_zise/presentation/helpers/ui_alert_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_laravel_form_validation/flutter_laravel_form_validation.dart';

part 'login_screen_controller.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenControllerBuilder<LoginScreenController>(
        create: (state) => LoginScreenController(state),
        builder: (context, ctrl) => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Image.asset(
                      Assets.images.logo.path,
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  LocaleKeys.home_app_name.tr(),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  LocaleKeys.auth_subtitle.tr(),
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: ctrl.formKey,
                    child: Column(
                      children: [
                        Text(
                          LocaleKeys.auth_login.tr(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),

                        TextFormField(
                          controller: ctrl.emailController,
                          validator: ['required', 'email'].validate(
                            attribute: LocaleKeys
                                .login_validation_email_attribute
                                .tr(),
                            customMessages: {
                              'required': LocaleKeys
                                  .login_validation_email_required
                                  .tr(),
                              'email': LocaleKeys.login_validation_email_invalid
                                  .tr(),
                            },
                          ),
                          decoration: InputDecoration(
                            hintText: LocaleKeys.auth_email.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.white.withValues(alpha: 0.9),
                            filled: true,
                            prefixIcon: const Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: ctrl.passwordController,
                          validator: ['required', 'min:4'].validate(
                            attribute: LocaleKeys
                                .login_validation_password_attribute
                                .tr(),
                            customMessages: {
                              'required': LocaleKeys
                                  .login_validation_password_required
                                  .tr(),
                              'min': LocaleKeys.login_validation_password_min
                                  .tr(),
                            },
                          ),
                          decoration: InputDecoration(
                            hintText: LocaleKeys.auth_password.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.white.withValues(alpha: 0.9),
                            filled: true,
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: InkWell(
                              onTap: ctrl.togleVisiblePassword,
                              child: Icon(
                                ctrl.isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          obscureText: !ctrl.isPasswordVisible,
                        ),

                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => ctrl.login(),
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF667EEA),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: ctrl.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  LocaleKeys.auth_sign_in.tr(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            context.router.push(const ForgotPasswordRoute());
                          },
                          child: Text(
                            LocaleKeys.auth_forgot_password.tr(),
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFFFFF),
                              foregroundColor: const Color(0xFF000000),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.grey),
                              ),
                            ),
                            icon: const Icon(
                              MaterialCommunityIcons.google,
                              color: Colors.red,
                              size: 24,
                            ),
                            label: Text(
                              LocaleKeys.auth_continue_with_google.tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              await ctrl._signInWithGoogle();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  LocaleKeys.auth_no_account.tr(),
                  style: TextStyle(color: Colors.white70),
                ),
                TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse('${MyStrings.webUrl}/register'));
                  },
                  child: Text(
                    LocaleKeys.auth_create_account.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
