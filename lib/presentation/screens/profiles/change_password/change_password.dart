import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _twoFactorEnabled = false;
  bool _biometricEnabled = true;

  double _passwordStrength = 0.5; // 0.0 à 1.0
  String _passwordStrengthText = "Moyen";
  Color _passwordStrengthColor = Colors.orange;
  bool isVisible = false;
  final List<bool> _criteriasMet = [true, true, false, false];

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_updatePasswordStrength);
  }

  void _updatePasswordStrength() {
    final String password = _newPasswordController.text;
    int criteriaMet = 0;

    // Au moins 8 caractères
    _criteriasMet[0] = password.length >= 8;
    if (_criteriasMet[0]) {
      criteriaMet++;
    }

    // Contient des lettres
    _criteriasMet[1] = password.contains(RegExp(r'[a-zA-Z]'));
    if (_criteriasMet[1]) {
      criteriaMet++;
    }

    // Contient des chiffres
    _criteriasMet[2] = password.contains(RegExp(r'[0-9]'));
    if (_criteriasMet[2]) {
      criteriaMet++;
    }

    // Contient des symboles
    _criteriasMet[3] = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    if (_criteriasMet[3]) {
      criteriaMet++;
    }

    setState(() {
      _passwordStrength = criteriaMet / 4;

      if (criteriaMet <= 1) {
        _passwordStrengthText = "Faible";
        _passwordStrengthColor = Colors.red;
      } else if (criteriaMet <= 2) {
        _passwordStrengthText = "Moyen";
        _passwordStrengthColor = Colors.orange;
      } else if (criteriaMet <= 3) {
        _passwordStrengthText = "Bon";
        _passwordStrengthColor = Colors.blue;
      } else {
        _passwordStrengthText = "Excellent";
        _passwordStrengthColor = Colors.green;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: InkWell(
                      onTap: () {
                        context.router.pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Changer le Mot de Passe',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Alert Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        border: Border.all(color: const Color(0xFFDBEAFE)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('🔒', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Pour votre sécurité, choisissez un mot de passe contenant au moins 8 caractères avec des lettres, chiffres et symboles.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1E40AF),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Card principale
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Mot de passe actuel
                          _buildFormField(
                            'Mot de passe actuel',
                            'Saisissez votre mot de passe actuel',
                            _currentPasswordController,
                          ),

                          // Nouveau mot de passe
                          _buildFormField(
                            'Nouveau mot de passe',
                            'Saisissez le nouveau mot de passe',
                            _newPasswordController,
                          ),

                          // Confirmer nouveau mot de passe
                          _buildFormField(
                            'Confirmer le nouveau mot de passe',
                            'Confirmez le nouveau mot de passe',
                            _confirmPasswordController,
                          ),

                          // Indicateur de force
                          _buildPasswordStrengthIndicator(),

                          // Critères de sécurité
                          _buildSecurityCriteria(),

                          // Boutons
                          const SizedBox(height: 20),
                          _buildPrimaryButton('Changer le mot de passe'),
                          const SizedBox(height: 12),
                          _buildSecondaryButton('Annuler'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Options de sécurité
                    _buildSecurityOptionsCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(
    String label,
    String placeholder,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            obscureText: !isVisible,
            decoration: InputDecoration(
              hintText: placeholder,
              filled: true,
              prefixIcon: const Icon(Icons.password),

              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E7EB),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF667EEA),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E7EB),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.all(16),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Force du mot de passe',
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: index < (_passwordStrength * 4).ceil()
                        ? _passwordStrengthColor
                        : const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 4),
          Text(
            _passwordStrengthText,
            style: TextStyle(fontSize: 12, color: _passwordStrengthColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCriteria() {
    final criteria = [
      'Au moins 8 caractères',
      'Contient des lettres',
      'Contient des chiffres',
      'Contient des symboles',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Critères de sécurité :',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          ...criteria.asMap().entries.map((entry) {
            final int index = entry.key;
            final String criterion = entry.value;
            final bool isMet = _criteriasMet[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Text(
                    isMet ? '✓' : '○',
                    style: TextStyle(
                      color: isMet
                          ? const Color(0xFF10B981)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    criterion,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(String text) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: () {
          // Action pour changer le mot de passe
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF8FAFC),
          foregroundColor: const Color(0xFF64748B),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildSecurityOptionsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Options de Sécurité',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          _buildSecurityOption(
            '🔐',
            'Authentification à deux facteurs',
            'Ajoutez une couche de sécurité supplémentaire',
            const Color(0xFFEFF6FF),
            const Color(0xFF2563EB),
            _twoFactorEnabled,
            (value) => setState(() => _twoFactorEnabled = value),
          ),
          _buildSecurityOption(
            '📱',
            'Connexion biométrique',
            'Utilisez votre empreinte ou Face ID',
            const Color(0xFFECFDF5),
            const Color(0xFF10B981),
            _biometricEnabled,
            (value) => setState(() => _biometricEnabled = value),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOption(
    String emoji,
    String title,
    String subtitle,
    Color backgroundColor,
    Color iconColor,
    bool isEnabled,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(fontSize: 18, color: iconColor),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF667EEA),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
