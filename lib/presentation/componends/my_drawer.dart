import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/core/network/api_result.dart';
import 'package:budget_zise/domain/models/user_model.dart';
import 'package:budget_zise/domain/repositories/auth_repository.dart';
import 'package:budget_zise/router/app_router.dart';
import 'package:budget_zise/presentation/cubits/notification_count_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BudgetDrawer extends StatelessWidget {
  const BudgetDrawer({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          // Header avec fermeture
          Container(
            height: 80,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEFF6FF), Color(0xFFE0E7FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.drawer_app_title.tr(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Section Profile
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEFF6FF), Color(0xFFE0E7FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Column(
              children: [
                // Avatar et infos utilisateur
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF4F46E5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              user.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.person);
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.firstName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          Text(
                            LocaleKeys.drawer_classic_member.tr(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                LocaleKeys.drawer_online.tr(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Balance rapide
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.drawer_total_balance.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        '2,450 ${user.country.currency}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Navigation Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _buildMenuItem(
                  icon: Icons.bar_chart,
                  label: LocaleKeys.drawer_statistics.tr(),
                  onTap: () => _navigateToPage(context, 'statistique'),
                ),

                _buildMenuItem(
                  icon: Icons.account_balance_wallet,
                  label: LocaleKeys.drawer_my_accounts.tr(),
                  onTap: () => _navigateToPage(context, 'accounts'),
                ),

                _buildMenuItem(
                  icon: Icons.track_changes,
                  label: LocaleKeys.drawer_goals.tr(),
                  onTap: () => _navigateToPage(context, 'savings-goals'),
                ),
                BlocBuilder<NotificationCountCubit, NotificationState>(
                  bloc: BlocProvider.of<NotificationCountCubit>(context),
                  builder: (context, state) {
                    return _buildMenuItem(
                      icon: Icons.notifications,
                      label: LocaleKeys.drawer_notifications.tr(),
                      onTap: () => _navigateToPage(context, 'notifications'),
                      badge: state.count > 0 ? state.count : null,
                      isFetching: state.isFechting,
                    );
                  },
                ),

                _buildMenuItem(
                  icon: Icons.settings,
                  label: LocaleKeys.drawer_settings.tr(),
                  onTap: () => _navigateToPage(context, 'settings'),
                  badge: 1,
                ),
                _buildMenuItem(
                  icon: Icons.security,
                  label: "PIN",
                  onTap: () => _navigateToPage(context, 'pin'),
                ),
              ],
            ),
          ),

          // Bottom Section - Logout
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _handleLogout(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFFEF2F2),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Color(0xFFDC2626), size: 20),
                        SizedBox(width: 12),
                        Text(
                          LocaleKeys.drawer_logout.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    int? badge,
    bool isFetching = false,
  }) {
    debugPrint(isFetching.toString());
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: const Color(0xFF6B7280), size: 20),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
                if (badge != null)
                  Skeletonizer(
                    enabled: isFetching,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${badge > 99 ? '99+' : badge}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
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

  void _navigateToPage(BuildContext context, String route) {
    Navigator.of(context).pop(); // Fermer le drawer

    // Exemple de navigation
    switch (route) {
      case 'accounts':
        context.router.push(const ProfilRoute());
        break;
      case 'savings-goals':
        context.router.push(const SavingsGoalsRoute());
        break;

      case 'notifications':
        context.router.push(const NotificationsRoute());
        break;
      case 'statistique':
        context.router.push(const StatisticsRoute());
        break;
      case 'settings':
        context.router.push(const PrincipalSettingsRoute());
        break;
      case 'pin':
        context.router.push(const PinRoute());
        break;
    }
  }

  void _handleLogout(BuildContext context) {
    Navigator.of(context).pop(); // Fermer le drawer

    // Afficher une boîte de dialogue de confirmation
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.drawer_logout_title.tr()),
          content: Text(LocaleKeys.drawer_logout_message.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(LocaleKeys.drawer_cancel.tr()),
            ),
            TextButton(
              onPressed: () {
                final authRepository = Provider.of<AuthRepository>(
                  context,
                  listen: false,
                );
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
              child: Text(
                LocaleKeys.drawer_logout_confirm.tr(),
                style: TextStyle(color: Color(0xFFDC2626)),
              ),
            ),
          ],
        );
      },
    );
  }
}
