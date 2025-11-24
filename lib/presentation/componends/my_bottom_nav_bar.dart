import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/constants/my_colors.dart';
import 'package:budget_zise/presentation/componends/my_drawer.dart';
import 'package:budget_zise/presentation/cubits/notification_count_cubit.dart';
import 'package:budget_zise/presentation/cubits/user_cubit.dart';
import 'package:budget_zise/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@RoutePage()
class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key});

  final tabs = const [
    DashboardRoute(),
    TransactionRoute(),
    BudgetRoute(),
    ProfilRoute(),
  ];

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final authUser = BlocProvider.of<AuthCubit>(context).getSignedInUser;
    final notificationCount = BlocProvider.of<NotificationCountCubit>(
      context,
    ).getCount.count;
    return AutoTabsRouter(
      routes: tabs,
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          key: scaffoldKey,
          drawer: BudgetDrawer(user: authUser),
          body: child,
          bottomNavigationBar: FloatingBottomNavBar(
            key: ValueKey(context.locale.languageCode),
            currentIndex: tabsRouter.activeIndex,
            onTap: (index) {
              // Haptic feedback pour une meilleure UX
              HapticFeedback.lightImpact();

              if (index == 4) {
                scaffoldKey.currentState?.openDrawer();
              } else {
                tabsRouter.setActiveIndex(index);
              }
            },
            notificationCount: notificationCount,
          ),
        );
      },
    );
  }
}

// Alternative avec un design encore plus moderne (Floating Action Button style)
class FloatingBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int notificationCount;

  const FloatingBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFloatingNavItem(
            icon: Icons.home_rounded,
            label: LocaleKeys.bottom_nav_dashboard.tr(),
            index: 0,
          ),
          _buildFloatingNavItem(
            icon: Icons.receipt_long_rounded,
            label: LocaleKeys.bottom_nav_transactions.tr(),
            index: 1,
          ),
          _buildFloatingNavItem(
            icon: Icons.account_balance_wallet_rounded,
            label: LocaleKeys.bottom_nav_budgets.tr(),
            index: 2,
          ),
          _buildFloatingNavItem(
            icon: Icons.person_rounded,
            label: LocaleKeys.bottom_nav_profile.tr(),
            index: 3,
          ),
          BlocBuilder<NotificationCountCubit, NotificationState>(
            bloc: BlocProvider.of<NotificationCountCubit>(context),
            builder: (context, state) {
              return _buildFloatingNavItem(
                icon: Icons.menu_rounded,
                label: LocaleKeys.bottom_nav_menu.tr(),
                index: 4,
                hasBadge: state.count > 0 ? true : false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavItem({
    required IconData icon,
    required String label,
    required int index,
    bool hasBadge = false,
  }) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? MyColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isActive ? Colors.white : Colors.grey[600],
                ),
                if (hasBadge)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),

            // Label apparaît seulement pour l'item actif
            if (isActive) ...[
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 600),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 80),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
