import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/core/network/api_result.dart';
import 'package:budget_zise/domain/repositories/auth_repository.dart';
import 'package:budget_zise/router/app_router.dart';
import 'package:budget_zise/providers/language_switch_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
// part 'principal_settings_screen_controller.dart';

@RoutePage()
class PrincipalSettingsScreen extends StatefulWidget {
  const PrincipalSettingsScreen({super.key});

  @override
  State<PrincipalSettingsScreen> createState() => _SettingsPageState();
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
    final authRepository = Provider.of<AuthRepository>(context);
    final languageSwitchCubit = BlocProvider.of<LanguageSwitchCubit>(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.grey[600]),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          LocaleKeys.settings_title.tr(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Paramètres Généraux
              _buildSettingsCard(LocaleKeys.settings_general.tr(), [
                _buildSettingItem(
                  Ionicons.language_outline,
                  LocaleKeys.settings_language.tr(),
                  languageSwitchCubit.isFrench
                      ? LocaleKeys.settings_french.tr()
                      : LocaleKeys.settings_english.tr(),
                  Colors.blue[50]!,
                  Colors.blue[600]!,
                  showArrow: true,
                  onTap: () => _showLanguageDialog(languageSwitchCubit),
                ),
                _buildSettingItem(
                  MaterialCommunityIcons.currency_eur,

                  LocaleKeys.settings_currency.tr(),
                  LocaleKeys.settings_euro.tr(),
                  Colors.green[50]!,
                  Colors.green[500]!,
                  showArrow: true,
                  onTap: () => _showCurrencyDialog(),
                ),
                _buildSettingItem(
                  Ionicons.moon_outline,
                  LocaleKeys.settings_dark_mode.tr(),
                  LocaleKeys.settings_dark_mode_subtitle.tr(),
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
                  Feather.refresh_ccw,
                  LocaleKeys.settings_auto_sync.tr(),
                  LocaleKeys.settings_auto_sync_subtitle.tr(),
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
                  Feather.bell,
                  LocaleKeys.settings_push_notifications.tr(),
                  LocaleKeys.settings_push_notifications_subtitle.tr(),
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
                  Feather.alert_triangle,
                  LocaleKeys.settings_budget_alerts.tr(),
                  LocaleKeys.settings_budget_alerts_subtitle.tr(),
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
                  Feather.bar_chart_2,
                  LocaleKeys.settings_weekly_reports.tr(),
                  LocaleKeys.settings_weekly_reports_subtitle.tr(),
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
                  Feather.target,
                  LocaleKeys.settings_savings_goals.tr(),
                  LocaleKeys.settings_savings_goals_subtitle.tr(),
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
              _buildSettingsCard(LocaleKeys.settings_security_privacy.tr(), [
                _buildSettingItem(
                  Feather.lock,
                  LocaleKeys.settings_auto_lock.tr(),
                  LocaleKeys.settings_auto_lock_subtitle.tr(),
                  Colors.blue[50]!,
                  Colors.blue[600]!,
                  showArrow: true,
                  onTap: () => _showAutoLockDialog(),
                ),
                _buildSettingItem(
                  Feather.smartphone,
                  LocaleKeys.settings_biometric_auth.tr(),
                  LocaleKeys.settings_biometric_auth_subtitle.tr(),
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
                  Feather.shield,
                  LocaleKeys.settings_navigation_data.tr(),
                  LocaleKeys.settings_navigation_data_subtitle.tr(),
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
              _buildSettingsCard(LocaleKeys.settings_backup.tr(), [
                _buildSettingItem(
                  Feather.cloud,
                  LocaleKeys.settings_cloud_backup.tr(),
                  LocaleKeys.settings_cloud_backup_subtitle.tr(),
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
                  Feather.upload,
                  LocaleKeys.settings_export_data.tr(),
                  LocaleKeys.settings_export_data_subtitle.tr(),
                  Colors.green[50]!,
                  Colors.green[500]!,
                  showArrow: true,
                  onTap: () => _exportData(),
                ),
                _buildSettingItem(
                  Feather.download,
                  LocaleKeys.settings_restore_data.tr(),
                  LocaleKeys.settings_restore_data_subtitle.tr(),
                  Colors.red[50]!,
                  Colors.red[500]!,
                  showArrow: true,
                  onTap: () => _restoreData(),
                ),
              ]),

              // Support
              _buildSettingsCard(LocaleKeys.settings_support.tr(), [
                _buildSettingItem(
                  Feather.help_circle,
                  LocaleKeys.settings_help_center.tr(),
                  LocaleKeys.settings_help_center_subtitle.tr(),
                  Colors.blue[50]!,
                  Colors.blue[600]!,
                  showArrow: true,
                  onTap: () => _openHelpCenter(),
                ),
                _buildSettingItem(
                  Feather.message_square,
                  LocaleKeys.settings_contact_support.tr(),
                  LocaleKeys.settings_contact_support_subtitle.tr(),
                  Colors.green[50]!,
                  Colors.green[500]!,
                  showArrow: true,
                  onTap: () => _contactSupport(),
                ),
                _buildSettingItem(
                  Feather.alert_octagon,
                  LocaleKeys.settings_report_bug.tr(),
                  LocaleKeys.settings_report_bug_subtitle.tr(),
                  Colors.red[50]!,
                  Colors.red[500]!,
                  showArrow: true,
                  onTap: () => _reportBug(),
                ),
              ]),

              // À propos
              _buildSettingsCard('À propos', [
                _buildSettingItem(
                  Feather.info,
                  LocaleKeys.settings_app_version.tr(),
                  LocaleKeys.settings_app_version_subtitle.tr(),
                  Colors.blue[50]!,
                  Colors.blue[600]!,
                ),
                _buildSettingItem(
                  Feather.file_text,
                  LocaleKeys.settings_terms_of_service.tr(),
                  LocaleKeys.settings_terms_of_service_subtitle.tr(),
                  Colors.green[50]!,
                  Colors.green[500]!,
                  showArrow: true,
                  onTap: () => _openTermsOfService(),
                ),
                _buildSettingItem(
                  Feather.shield,
                  LocaleKeys.settings_privacy_policy.tr(),
                  LocaleKeys.settings_privacy_policy_subtitle.tr(),
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
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ElevatedButton.icon(
                    onPressed: () => _logout(authRepository),
                    icon: const Icon(Feather.log_out),
                    label: Text(LocaleKeys.settings_logout.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[500],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                    icon: const Icon(Feather.trash),
                    label: Text(LocaleKeys.settings_delete_account.tr()),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red[500],
                      side: BorderSide(color: Colors.red[500]!),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ]),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
          ],
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    IconData emoji,
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
        padding: const EdgeInsets.symmetric(vertical: 16),
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
              child: Center(child: Icon(emoji, size: 24)),
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
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
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
                activeThumbColor: Colors.blue[600],
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
  void _showLanguageDialog(LanguageSwitchCubit languageSwitchCubit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.settings_choose_language.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(LocaleKeys.settings_french.tr()),
              onTap: () {
                languageSwitchCubit.switchLanguage(context, 'fr');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(LocaleKeys.settings_english.tr()),
              onTap: () {
                languageSwitchCubit.switchLanguage(context, 'en');
                Navigator.pop(context);
              },
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
        title: Text(LocaleKeys.settings_choose_currency.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(LocaleKeys.settings_euro.tr()),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text(LocaleKeys.settings_dollar.tr()),
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
        title: Text(LocaleKeys.settings_auto_lock.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(LocaleKeys.settings_never.tr()),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text(LocaleKeys.settings_one_minute.tr()),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text(LocaleKeys.settings_five_minutes.tr()),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text(LocaleKeys.settings_fifteen_minutes.tr()),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(LocaleKeys.settings_export_data_subtitle.tr())),
    );
  }

  void _restoreData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(LocaleKeys.settings_restore_data_subtitle.tr())),
    );
  }

  void _openHelpCenter() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(LocaleKeys.settings_help_center_subtitle.tr())),
    );
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LocaleKeys.settings_contact_support_subtitle.tr()),
      ),
    );
  }

  void _reportBug() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(LocaleKeys.settings_report_bug_subtitle.tr())),
    );
  }

  void _openTermsOfService() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LocaleKeys.settings_terms_of_service_subtitle.tr()),
      ),
    );
  }

  void _openPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(LocaleKeys.settings_privacy_policy_subtitle.tr())),
    );
  }

  void _logout(AuthRepository authRepository) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.settings_logout_title.tr()),
        content: Text(LocaleKeys.settings_logout_message.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.settings_cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              authRepository.logout().then((value) {
                if (value is Success && context.mounted) {
                  Navigator.pop(context);
                  context.router.replaceAll([
                    const HomeRoute(),
                    const LoginRoute(),
                  ]);
                }
              });
            },
            child: Text(LocaleKeys.settings_logout.tr()),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.settings_delete_account_title.tr()),
        content: Text(LocaleKeys.settings_delete_account_message.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.settings_cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Logique de suppression
            },
            child: Text(
              LocaleKeys.settings_delete_account.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
