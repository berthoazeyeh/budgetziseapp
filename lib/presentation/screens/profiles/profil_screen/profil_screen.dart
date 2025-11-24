import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/presentation/cubits/user_cubit.dart';
import 'package:budget_zise/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';
part 'profil_screen_controller.dart';

@RoutePage()
class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().getSignedInUser;
    return Scaffold(
      backgroundColor: Colors.grey[50],

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.profile_screen_title.tr(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          context.router.push(const PrincipalSettingsRoute());
                        },
                        icon: const Icon(
                          Feather.settings,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.router.push(const EditProfilRoute());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF667EEA),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(LocaleKeys.profile_screen_edit.tr()),
                      ),
                    ],
                  ),

                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFF667EEA),
                      shape: BoxShape.circle,
                      border: Border(),
                    ),
                    child: Center(
                      child: Text(
                        user.firstName.substring(0, 1).toUpperCase() +
                            user.lastName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Nom et email
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Skeletonizer(
                    enabled: false,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
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
                          Text(
                            LocaleKeys.profile_screen_stats_title.tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  '📊',
                                  LocaleKeys.profile_screen_stat_transactions
                                      .tr(),
                                  '247',
                                  Colors.green[50]!,
                                  Colors.green[500]!,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _buildStatCard(
                                  '🎯',
                                  LocaleKeys.profile_screen_stat_budgets.tr(),
                                  '8',
                                  Colors.red[50]!,
                                  Colors.red[500]!,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  '📈',
                                  LocaleKeys.profile_screen_stat_savings.tr(),
                                  '12.3%',
                                  Colors.blue[50]!,
                                  Colors.blue[600]!,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _buildStatCard(
                                  '⏰',
                                  LocaleKeys.profile_screen_stat_since.tr(),
                                  LocaleKeys.profile_screen_stat_months.tr(
                                    namedArgs: {'months': "8"},
                                  ),
                                  Colors.purple[50]!,
                                  Colors.purple[600]!,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Informations Personnelles
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
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
                        Text(
                          LocaleKeys.profile_screen_personal_info.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildInfoItem(
                          Feather.user,
                          LocaleKeys.profile_screen_full_name.tr(),
                          '${user.firstName} ${user.lastName}',
                          Colors.blue[50]!,
                          Colors.blue[600]!,
                        ),
                        _buildInfoItem(
                          Feather.mail,
                          LocaleKeys.profile_screen_email.tr(),
                          user.email,
                          Colors.green[50]!,
                          Colors.green[500]!,
                        ),
                        _buildInfoItem(
                          Feather.smartphone,
                          LocaleKeys.profile_screen_phone.tr(),
                          user.phoneNumber,
                          Colors.red[50]!,
                          Colors.red[500]!,
                        ),
                        _buildInfoItem(
                          Feather.home,
                          LocaleKeys.profile_screen_address.tr(),
                          '123 Rue de la Paix, 75001 Paris',
                          Colors.purple[50]!,
                          Colors.purple[600]!,
                        ),
                      ],
                    ),
                  ),

                  // Actions Rapides
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
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
                        Text(
                          LocaleKeys.profile_screen_quick_actions.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.router.push(const EditProfilRoute());
                            },
                            icon: const Icon(Feather.user, color: Colors.amber),
                            label: Text(
                              LocaleKeys.profile_screen_edit_profile.tr(),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.router.push(const ChangePasswordRoute());
                            },
                            icon: const Icon(Feather.lock, color: Colors.amber),
                            label: Text(
                              LocaleKeys.profile_screen_change_password.tr(),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.router.push(
                                const PrincipalSettingsRoute(),
                              );
                            },
                            icon: const Icon(
                              Feather.settings,
                              color: Colors.blue,
                            ),
                            label: Text(
                              LocaleKeys.profile_screen_app_settings.tr(),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          // Statistiques Personnelles

          // Espace pour la navigation
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String emoji,
    String label,
    String value,
    Color bgColor,
    Color iconColor,
  ) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    IconData emoji,
    String label,
    String value,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Icon(emoji, size: 24)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
