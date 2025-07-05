import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// part 'principal_settings_screen_controller.dart';

@RoutePage()
class PrincipalSettingsScreen extends StatefulWidget {
  const PrincipalSettingsScreen({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<PrincipalSettingsScreen> {
  // États des switches
  bool darkModeEnabled = false;
  bool autoSyncEnabled = true;
  bool pushNotificationsEnabled = true;
  bool budgetAlertsEnabled = true;
  bool weeklyReportsEnabled = false;
  bool savingsGoalsEnabled = true;
  bool biometricAuthEnabled = true;
  bool shareDataEnabled = false;
  bool cloudBackupEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.grey[600]),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Paramètres',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Paramètres Généraux
              _buildSettingsCard('Général', [
                _buildSettingItem(
                  '🌐',
                  'Langue',
                  'Français',
                  Colors.blue[50]!,
                  Colors.blue[600]!,
                  showArrow: true,
                  onTap: () => _showLanguageDialog(),
                ),
                _buildSettingItem(
                  '💰',
                  'Devise',
                  'Euro (€)',
                  Colors.green[50]!,
                  Colors.green[500]!,
                  showArrow: true,
                  onTap: () => _showCurrencyDialog(),
                ),
                _buildSettingItem(
                  '🌙',
                  'Mode sombre',
                  'Activé automatiquement',
                  Colors.red[50]!,
                  Colors.red[500]!,
                  hasSwitch: true,
                  switchValue: darkModeEnabled,
                  onSwitchChanged: (value) {
                    setState(() {
                      darkModeEnabled = value;
                    });
                  },
                ),
                _buildSettingItem(
                  '🔄',
                  'Synchronisation automatique',
                  'Synchroniser avec le cloud',
                  Colors.purple[50]!,
                  Colors.purple[600]!,
                  hasSwitch: true,
                  switchValue: autoSyncEnabled,
                  onSwitchChanged: (value) {
                    setState(() {
                      autoSyncEnabled = value;
                    });
                  },
                ),
              ]),

              // Notifications
              _buildSettingsCard('Notifications', [
                _buildSettingItem(
                  '🔔',
                  'Notifications push',
                  'Recevoir des notifications',
                  Colors.blue[50]!,
                  Colors.blue[600]!,
                  hasSwitch: true,
                  switchValue: pushNotificationsEnabled,
                  onSwitchChanged: (value) {
                    setState(() {
                      pushNotificationsEnabled = value;
                    });
                  },
                ),
                _buildSettingItem(
                  '📊',
                  'Alertes de budget',
                  'Quand vous dépassez 80% du budget',
                  Colors.green[50]!,
                  Colors.green[500]!,
                  hasSwitch: true,
                  switchValue: budgetAlertsEnabled,
                  onSwitchChanged: (value) {
                    setState(() {
                      budgetAlertsEnabled = value;
                    });
                  },
                ),
                _buildSettingItem(
                  '📈',
                  'Rapports hebdomadaires',
                  'Résumé de vos dépenses',
                  Colors.red[50]!,
                  Colors.red[500]!,
                  hasSwitch: true,
                  switchValue: weeklyReportsEnabled,
                  onSwitchChanged: (value) {
                    setState(() {
                      weeklyReportsEnabled = value;
                    });
                  },
                ),
                _buildSettingItem(
                  '🎯',
                  'Objectifs d\'épargne',
                  'Rappels pour vos objectifs',
                  Colors.purple[50]!,
                  Colors.purple[600]!,
                  hasSwitch: true,
                  switchValue: savingsGoalsEnabled,
                  onSwitchChanged: (value) {
                    setState(() {
                      savingsGoalsEnabled = value;
                    });
                  },
                ),
              ]),

              // Sécurité et Confidentialité
              _buildSettingsCard('Sécurité et Confidentialité', [
                _buildSettingItem(
                  '🔒',
                  'Verrouillage automatique',
                  'Après 5 minutes d\'inactivité',
                  Colors.blue[50]!,
                  Colors.blue[600]!,
                  showArrow: true,
                  onTap: () => _showAutoLockDialog(),
                ),
                _buildSettingItem(
                  '📱',
                  'Authentification biométrique',
                  'Touch ID / Face ID',
                  Colors.green[50]!,
                  Colors.green[500]!,
                  hasSwitch: true,
                  switchValue: biometricAuthEnabled,
                  onSwitchChanged: (value) {
                    setState(() {
                      biometricAuthEnabled = value;
                    });
                  },
                ),
                _buildSettingItem(
                  '🛡️',
                  'Données de navigation',
                  'Partager les données anonymes',
                  Colors.red[50]!,
                  Colors.red[500]!,
                  hasSwitch: true,
                  switchValue: shareDataEnabled,
                  onSwitchChanged: (value) {
                    setState(() {
                      shareDataEnabled = value;
                    });
                  },
                ),
              ]),

              // Sauvegarde
              _buildSettingsCard('Sauvegarde', [
                _buildSettingItem(
                  '☁️',
                  'Sauvegarde cloud',
                  'Dernière sauvegarde : il y a 2h',
                  Colors.blue[50]!,
                  Colors.blue[600]!,
                  hasSwitch: true,
                  switchValue: cloudBackupEnabled,
                  onSwitchChanged: (value) {
                    setState(() {
                      cloudBackupEnabled = value;
                    });
                  },
                ),
                _buildSettingItem(
                  '📤',
                  'Exporter les données',
                  'Télécharger vos données',
                  Colors.green[50]!,
                  Colors.green[500]!,
                  showArrow: true,
                  onTap: () => _exportData(),
                ),
                _buildSettingItem(
                  '🔄',
                  'Restaurer les données',
                  'Importer depuis une sauvegarde',
                  Colors.red[50]!,
                  Colors.red[500]!,
                  showArrow: true,
                  onTap: () => _restoreData(),
                ),
              ]),

              // Support
              _buildSettingsCard('Support', [
                _buildSettingItem(
                  '❓',
                  'Centre d\'aide',
                  'FAQ et guides d\'utilisation',
                  Colors.blue[50]!,
                  Colors.blue[600]!,
                  showArrow: true,
                  onTap: () => _openHelpCenter(),
                ),
                _buildSettingItem(
                  '💬',
                  'Contacter le support',
                  'Besoin d\'aide ? Contactez-nous',
                  Colors.green[50]!,
                  Colors.green[500]!,
                  showArrow: true,
                  onTap: () => _contactSupport(),
                ),
                _buildSettingItem(
                  '🐛',
                  'Signaler un bug',
                  'Aidez-nous à améliorer l\'app',
                  Colors.red[50]!,
                  Colors.red[500]!,
                  showArrow: true,
                  onTap: () => _reportBug(),
                ),
              ]),

              // À propos
              _buildSettingsCard('À propos', [
                _buildSettingItem(
                  '📱',
                  'Version de l\'application',
                  '2.1.0 (Build 210)',
                  Colors.blue[50]!,
                  Colors.blue[600]!,
                ),
                _buildSettingItem(
                  '📋',
                  'Conditions d\'utilisation',
                  'Lire nos conditions',
                  Colors.green[50]!,
                  Colors.green[500]!,
                  showArrow: true,
                  onTap: () => _openTermsOfService(),
                ),
                _buildSettingItem(
                  '🔒',
                  'Politique de confidentialité',
                  'Comment nous protégeons vos données',
                  Colors.red[50]!,
                  Colors.red[500]!,
                  showArrow: true,
                  onTap: () => _openPrivacyPolicy(),
                ),
              ]),

              // Déconnexion
              _buildSettingsCard('', [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 12),
                  child: ElevatedButton.icon(
                    onPressed: () => _logout(),
                    icon: Text('🚪'),
                    label: Text('Se déconnecter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[500],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _deleteAccount(),
                    icon: Text('🗑️'),
                    label: Text('Supprimer le compte'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red[500],
                      side: BorderSide(color: Colors.red[500]!),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ]),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(String title, List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
          ],
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String emoji,
    String title,
    String subtitle,
    Color bgColor,
    Color iconColor, {
    bool hasSwitch = false,
    bool switchValue = false,
    Function(bool)? onSwitchChanged,
    bool showArrow = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[100]!, width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(emoji, style: TextStyle(fontSize: 18))),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            if (hasSwitch)
              Switch(
                value: switchValue,
                onChanged: onSwitchChanged,
                activeColor: Colors.blue[600],
                inactiveThumbColor: Colors.grey[300],
                inactiveTrackColor: Colors.grey[200],
              ),
            if (showArrow)
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
          ],
        ),
      ),
    );
  }

  // Méthodes d'action
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choisir la langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Français'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('English'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choisir la devise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Euro (€)'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('Dollar (\$)'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showAutoLockDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Verrouillage automatique'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Jamais'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('1 minute'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('5 minutes'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('15 minutes'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Export des données en cours...')));
  }

  void _restoreData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sélectionnez un fichier de sauvegarde')),
    );
  }

  void _openHelpCenter() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Ouverture du centre d\'aide...')));
  }

  void _contactSupport() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Ouverture du support...')));
  }

  void _reportBug() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Formulaire de signalement...')));
  }

  void _openTermsOfService() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Ouverture des conditions...')));
  }

  void _openPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ouverture de la politique de confidentialité...'),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Déconnexion'),
        content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Logique de déconnexion
            },
            child: Text('Déconnecter'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer le compte'),
        content: Text('Cette action est irréversible. Êtes-vous sûr ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Logique de suppression
            },
            child: Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
