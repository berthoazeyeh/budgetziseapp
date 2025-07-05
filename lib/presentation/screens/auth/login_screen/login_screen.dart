import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/core/exceptions/network_exception.dart';
import 'package:budget_zise/data/services/local_storage_service.dart';
import 'package:budget_zise/domain/repositories/auth_repository.dart';
import 'package:budget_zise/gen/assets.gen.dart';
import 'package:budget_zise/gen/locale_keys.g.dart';
import 'package:budget_zise/router/app_router.dart';
import 'package:budget_zise/presentation/cubits/user_cubit.dart';
import 'package:budget_zise/presentation/helpers/ui_alert_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_laravel_form_validation/flutter_laravel_form_validation.dart';
// import 'package:sign_in_with_google/sign_in_with_google.dart'; // Exemple pour Google Sign-In

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
                    color: Colors.white.withOpacity(0.2),
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
                const Text(
                  'Budget Zise',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Gérez vos finances intelligemment',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: ctrl.formKey,
                    child: Column(
                      children: [
                        const Text(
                          'Connexion',
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
                            attribute: 'Adresse email',
                            customMessages: {
                              'required': 'L\'email est requis',
                              'email':
                                  'Veuillez saisir une adresse email valide',
                            },
                          ),
                          decoration: InputDecoration(
                            hintText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.white.withOpacity(0.9),
                            filled: true,
                            prefixIcon: const Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: ctrl.passwordController,
                          validator: ['required', 'min:4'].validate(
                            attribute: 'Mot de passe',
                            customMessages: {
                              'required': 'Le mot de passe est requis',
                              'min':
                                  'Le mot de passe doit contenir au moins 4 caractères',
                            },
                          ),
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.white.withOpacity(0.9),
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
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Se connecter',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Mot de passe oublié ?',
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
                            icon: Image.asset(
                              Assets.images.logo.path,
                              height: 24,
                            ),
                            label: const Text(
                              'Continuer avec Google',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              // await ctrl.signInWithGoogle();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Pas encore de compte ?',
                  style: TextStyle(color: Colors.white70),
                ),
                TextButton(
                  onPressed: () {
                    launchUrl(
                      Uri.parse('https://budget-rens.vercel.app/register'),
                    );
                  },
                  child: const Text(
                    'Créer un compte gratuitement',
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
