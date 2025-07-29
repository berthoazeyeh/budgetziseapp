import 'package:budget_zise/domain/models/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:moment_dart/moment_dart.dart';

class IconList {
  final List<IconData> icons;
  final Color color;
  final Color iconColor;

  IconList({required this.icons, required this.color, required this.iconColor});
}

class MyIcon {
  final IconData icon;
  final Color color;
  final Color iconColor;

  MyIcon({required this.icon, required this.color, required this.iconColor});
}

final Map<String, IconList> iconMapper = {
  "Alimentation/Food": IconList(
    icons: [
      MaterialIcons.restaurant,
      MaterialIcons.fastfood,
      Ionicons.restaurant,
      FontAwesome.cutlery,
    ],
    color: Colors.red,
    iconColor: Colors.white,
  ),
  "Transport/Transport": IconList(
    icons: [
      MaterialIcons.directions_car,
      MaterialIcons.directions_bus,
      Ionicons.car,
      FontAwesome.car,
    ],
    color: Colors.blue,
    iconColor: Colors.white,
  ),
  "Loyer/Rent": IconList(
    icons: [
      MaterialIcons.home,
      MaterialIcons.house,
      Ionicons.home,
      FontAwesome.home,
    ],
    color: Colors.green,
    iconColor: Colors.white,
  ),
  "Santé/Health": IconList(
    icons: [
      MaterialIcons.local_hospital,
      MaterialIcons.healing,
      Ionicons.medical,
      FontAwesome.heartbeat,
    ],
    color: Colors.purple,
    iconColor: Colors.white,
  ),
  "Éducation/Education": IconList(
    icons: [
      MaterialIcons.school,
      MaterialIcons.book,
      Ionicons.school,
      FontAwesome.graduation_cap,
    ],
    color: Colors.orange,
    iconColor: Colors.white,
  ),
  "Divertissement/Entertainment": IconList(
    icons: [
      MaterialIcons.movie,
      MaterialIcons.videogame_asset,
      Ionicons.game_controller,
      FontAwesome.film,
    ],
    color: Colors.yellow,
    iconColor: Colors.white,
  ),
  "Épargne/Savings": IconList(
    icons: [MaterialIcons.account_balance, Ionicons.wallet],
    color: Colors.green,
    iconColor: Colors.white,
  ),
  "Assurance/Insurance": IconList(
    icons: [
      MaterialIcons.security,
      MaterialIcons.verified_user,
      Ionicons.shield_checkmark,
      FontAwesome.shield,
    ],
    color: Colors.red,
    iconColor: Colors.white,
  ),
  "Voyage/Travel": IconList(
    icons: [
      MaterialIcons.luggage,
      MaterialIcons.flight,
      Ionicons.airplane,
      FontAwesome.plane,
    ],
    color: Colors.blue,
    iconColor: Colors.white,
  ),
  "Autres/Others": IconList(
    icons: [
      MaterialIcons.category,
      MaterialIcons.more_horiz,
      Ionicons.ellipsis_horizontal,
      FontAwesome.ellipsis_h,
    ],
    color: Colors.grey,
    iconColor: Colors.white,
  ),
  "Salaire/Salary": IconList(
    icons: [
      MaterialIcons.attach_money,
      MaterialIcons.payments,
      Ionicons.card,
      FontAwesome.money,
    ],
    color: Colors.green,
    iconColor: Colors.white,
  ),
  "Bonus/Prime": IconList(
    icons: [MaterialIcons.star, Ionicons.trophy, FontAwesome.trophy],
    color: Colors.yellow,
    iconColor: Colors.white,
  ),
  "Cadeau/Gift": IconList(
    icons: [
      MaterialIcons.card_giftcard,
      MaterialIcons.redeem,
      Ionicons.gift,
      FontAwesome.gift,
    ],
    color: Colors.pink,
    iconColor: Colors.white,
  ),
};

final Map<String, IconList> notificationIconMapper = {
  "BUDGET_EXCEEDED": IconList(
    icons: [
      MaterialIcons.warning,
      MaterialIcons.report_problem,
      Ionicons.alert_circle,
      FontAwesome.exclamation_triangle,
    ],
    color: const Color(0xFFFEF2F2),
    iconColor: const Color(0xFFEF4444),
  ),
  "GOAL_ACHIEVED": IconList(
    icons: [
      MaterialIcons.emoji_events,
      Ionicons.trophy,
      FontAwesome.trophy,
      MaterialCommunityIcons.trophy,
    ],
    color: const Color(0xFFECFDF5),
    iconColor: const Color(0xFF10B981),
  ),
  "SAVINGS_TIP": IconList(
    icons: [
      MaterialIcons.lightbulb,
      Ionicons.bulb,
      FontAwesome.lightbulb_o,
      MaterialCommunityIcons.lightbulb,
    ],
    color: const Color(0xFFFEF3C7),
    iconColor: const Color(0xFFF59E0B),
  ),
  "MONTHLY_REPORT": IconList(
    icons: [
      MaterialIcons.bar_chart,
      Ionicons.stats_chart,
      FontAwesome.line_chart,
      MaterialCommunityIcons.chart_line,
    ],
    color: const Color(0xFFF0F9FF),
    iconColor: const Color(0xFF0EA5E9),
  ),
  "SAVINGS_REMINDER": IconList(
    icons: [
      MaterialIcons.notifications_active,
      Ionicons.notifications,
      FontAwesome.bell,
      MaterialCommunityIcons.bell,
    ],
    color: const Color(0xFFFDF4FF),
    iconColor: const Color(0xFFC084FC),
  ),
  "INCOME_RECEIVED": IconList(
    icons: [
      MaterialIcons.attach_money,
      Ionicons.cash,
      FontAwesome.money,
      MaterialCommunityIcons.cash_multiple,
    ],
    color: const Color(0xFFECFDF5),
    iconColor: const Color(0xFF10B981),
  ),
  "BUDGET_DEADLINE": IconList(
    icons: [
      MaterialIcons.calendar_today,
      Ionicons.calendar,
      FontAwesome.calendar,
      MaterialCommunityIcons.calendar_outline,
    ],
    color: const Color(0xFFFEF2F2),
    iconColor: const Color(0xFFEF4444),
  ),
  "EXPENSE_ALERT": IconList(
    icons: [
      MaterialIcons.warning,
      MaterialIcons.report_problem,
      Ionicons.alert_circle,
      FontAwesome.exclamation_triangle,
    ],
    color: const Color(0xFFFEF2F2),
    iconColor: const Color(0xFFEF4444),
  ),
  "GOAL_PROGRESS": IconList(
    icons: [
      MaterialIcons.show_chart,
      MaterialIcons.trending_up,
      FontAwesome.line_chart,
      MaterialCommunityIcons.chart_line,
    ],
    color: const Color(0xFFE0F2FE),
    iconColor: const Color(0xFF3B82F6),
  ),
};

class IconMapper {
  static MyIcon getIcon(String category) {
    final iconList = iconMapper[category];
    if (iconList == null) {
      return MyIcon(
        icon: Ionicons.ellipsis_horizontal,
        color: Colors.grey,
        iconColor: Colors.white,
      );
    }
    return MyIcon(
      icon: iconList.icons.first,
      color: iconList.color,
      iconColor: iconList.iconColor,
    );
  }

  static MyIcon getNotificationIcon(String typeName) {
    final iconList = notificationIconMapper[typeName];
    if (iconList == null) {
      return MyIcon(
        icon: Ionicons.ellipsis_horizontal,
        color: Colors.grey,
        iconColor: Colors.white,
      );
    }
    return MyIcon(
      icon: iconList.icons.first,
      color: iconList.color,
      iconColor: iconList.iconColor,
    );
  }

  static TransactionType defaultTransactionType = TransactionType(
    id: 0,
    name: "Autres/Others",
    description: "Autres/Others",
    expenses: [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

MomentLocalization getMomentLocalization({Locale? locale}) {
  MomentLocalization localization;

  // Déterminer la localisation basée sur la locale
  if (locale != null) {
    switch (locale.languageCode) {
      case 'fr':
        localization = MomentLocalizations.fr();
        break;
      case 'es':
        localization = MomentLocalizations.es();
        break;
      default:
        localization = MomentLocalizations.enUS();
        break;
    }
  } else {
    // Utiliser la locale du système
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    switch (systemLocale.languageCode) {
      case 'fr':
        localization = MomentLocalizations.fr();
        break;
      case 'es':
        localization = MomentLocalizations.es();
        break;
      default:
        localization = MomentLocalizations.enUS();
        break;
    }
  }
  return localization;
}
