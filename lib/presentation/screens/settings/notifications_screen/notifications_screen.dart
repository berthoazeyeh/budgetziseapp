import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/core/exceptions/network_exception.dart';
import 'package:budget_zise/core/network/api_response.dart';
import 'package:budget_zise/domain/models/notification_model.dart';
import 'package:budget_zise/domain/repositories/dashboard_repository.dart';
import 'package:budget_zise/presentation/cubits/notification_count_cubit.dart';
import 'package:budget_zise/presentation/helpers/ui_alert_helper.dart';
import 'package:budget_zise/presentation/utils/icon_mapper.dart';
import 'package:budget_zise/providers/language_switch_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:provider/provider.dart';
part 'notifications_screen_controller.dart';

@RoutePage()
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final languageSwitchCubit = BlocProvider.of<LanguageSwitchCubit>(context);

    return ScreenControllerBuilder<NotificationsScreenController>(
      create: (state) =>
          NotificationsScreenController(state, languageSwitchCubit),
      builder: (context, ctrl) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            LocaleKeys.notifications_title.tr(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.notifications_today.tr(),
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: ctrl.markAllAsRead,
                    child: Visibility(
                      visible: !ctrl.isMutating,
                      replacement: const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator.adaptive(),
                      ),
                      child: Text(
                        LocaleKeys.notifications_mark_all_as_read.tr(),
                        style: const TextStyle(
                          color: Color(0xFF667EEA),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: ctrl.refreshNotifications,
          child: ListView(
            controller: ctrl.scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              ...ctrl.groupByDay().entries.map(
                (entry) => Builder(
                  builder: (context) {
                    final date = DateTime.parse(entry.key);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ctrl.formatRelativeDate(date),
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...entry.value.map((notification) {
                          final icon = IconMapper.getNotificationIcon(
                            notification.typeName,
                          );
                          return _buildNotificationItem(
                            NotificationItem(
                              title: notification.title,
                              description: notification.message,
                              icon: icon.icon,
                              iconColor: icon.iconColor,
                              backgroundColor: icon.color,
                              time: ctrl.formatRelativeDate(
                                notification.createdAt,
                              ),
                              isRead: notification.isRead,
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
              if (ctrl.isLoading)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: const Center(child: CircularProgressIndicator()),
                ),

              if (ctrl.notifications.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      const Text('🔔', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 16),
                      Text(
                        LocaleKeys.notifications_empty_title.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        LocaleKeys.notifications_empty_subtitle.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Opacity(
        opacity: notification.isRead ? 0.6 : 1.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: notification.backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Icon(
                  notification.icon,
                  size: 18,
                  color: notification.iconColor,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          if (notification.isRead)
                            const Icon(
                              MaterialCommunityIcons.check_all,
                              size: 12,
                              color: Colors.green,
                            ),

                          Text(
                            notification.time,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Description
                  Text(
                    notification.description,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String time;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.time,
    this.isRead = false,
  });
}
