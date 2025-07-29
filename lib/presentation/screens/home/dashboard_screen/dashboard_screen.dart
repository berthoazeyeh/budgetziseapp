import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/core/exceptions/network_exception.dart';
import 'package:budget_zise/domain/models/category_budget.dart';
import 'package:budget_zise/domain/models/transaction.dart';
import 'package:budget_zise/domain/repositories/budget_repository.dart';
import 'package:budget_zise/domain/repositories/dashboard_repository.dart';
import 'package:budget_zise/presentation/cubits/user_cubit.dart';
import 'package:budget_zise/presentation/helpers/ui_alert_helper.dart';
import 'package:budget_zise/presentation/utils/icon_mapper.dart';
import 'package:budget_zise/providers/language_switch_cubit.dart';
import 'package:budget_zise/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:budget_zise/constants/my_colors.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
part 'dashboard_screen_controller.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().getSignedInUser;
    final languageSwitchCubit = context.read<LanguageSwitchCubit>();
    return ScreenControllerBuilder<DashboardScreenController>(
      create: (state) => DashboardScreenController(state),
      builder: (context, ctrl) => Scaffold(
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bonjour, ${user.firstName}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Voici votre situation financière',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                                context.router.push(const ProfilRoute());
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(user.imageUrl),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Solde Principal
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Skeletonizer(
                        enabled: ctrl.isLoadingBudget,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Solde disponible',
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '2,485.50 ${user.country.currency}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Ce mois',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '+650 ${user.country.currency}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: const [
                                        Text(
                                          'Économies',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '12.3%',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: ctrl.refreshTransactions,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: '📈',
                                label: 'Revenus',
                                amount: '+3,200 ${user.country.currency}',
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _StatCard(
                                icon: '📉',
                                label: 'Dépenses',
                                amount: '-2,550 ${user.country.currency}',
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 10),
                          ],
                        ),
                        child: Column(
                          spacing: 5,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Budgets Actifs",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    context.router.push(const BudgetRoute());
                                  },
                                  child: Text(
                                    "Voir tous",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ...ctrl.budget.map((category) {
                              final icon = IconMapper.getIcon(
                                category.category.name,
                              );
                              return BudgetCard(
                                title: category.category.name,
                                icon: icon.icon,
                                spent: category.totalExpenses,
                                limit: category.allocatedAmount,
                                color: icon.color,
                              );
                            }),
                            const SizedBox(height: 10),
                            Visibility(
                              visible:
                                  ctrl.budget.isEmpty && ctrl.isLoadingBudget,
                              child: Skeletonizer(
                                enabled: ctrl.isLoadingBudget,
                                child: Column(
                                  children: List.generate(
                                    4,
                                    (index) => BudgetCard(
                                      title: "Alimentation",
                                      icon: Icons.restaurant,
                                      spent: 880,
                                      limit: 700,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.all(20),

                        margin: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 10),
                          ],
                        ),
                        child: Column(
                          spacing: 5,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Transactions Récentes",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    context.router.push(
                                      const TransactionRoute(),
                                    );
                                  },
                                  child: Text(
                                    "Voir toutes",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            ...ctrl.transactions.map((e) {
                              final icon = IconMapper.getIcon(e.categoryName);
                              final isExpense = e.transactionType == "Expense";
                              final amount = isExpense ? -e.amount : e.amount;
                              String category = e.categoryName;
                              if (category.split("/").length > 1) {
                                if (languageSwitchCubit.isFrench) {
                                  category = category.split("/").first.trim();
                                } else {
                                  category = category.split("/").last;
                                }
                              }
                              return TransactionItem(
                                icon: icon.icon,
                                iconColor: icon.iconColor,
                                isIncome: !isExpense,
                                iconBg: icon.color,
                                title: category,
                                subtitle:
                                    e.description ??
                                    e.transactionReference ??
                                    "",
                                time: Moment(e.date).format('HH:mm'),
                                amount: amount,
                                amountColor: isExpense
                                    ? Color(0xFFEF4444)
                                    : Color(0xFF10B981),
                                category: e.paymentMethod,
                                fileUrl: e.receiptUrl,
                                currency: user.country.currency,
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String label;
  final String amount;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(icon, style: TextStyle(fontSize: 22, color: color)),
            ),
          ),

          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final double spent;
  final double limit;
  final Color color;

  const BudgetCard({
    super.key,
    required this.title,
    required this.icon,
    required this.spent,
    required this.limit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (spent / limit).clamp(0.0, 1.0);
    final overLimit = spent > limit;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 20, color: color),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                "${spent.toInt()}€ / ${limit.toInt()}€",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: overLimit ? Colors.red : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage > 1 ? 1 : percentage,
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                overLimit ? Colors.red : MyColors.primary,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            overLimit
                ? "Dépassement de ${(spent - limit).toInt()}€"
                : "Reste ${(limit - spent).toInt()}€ pour ce mois",
            style: TextStyle(
              fontSize: 12,
              color: overLimit ? Colors.red : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final double amount;
  final bool isIncome;
  final Color iconColor;
  final Color iconBg;
  final Color amountColor;
  final String category;
  final String? fileUrl;
  final String currency;
  const TransactionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.amount,
    this.isIncome = false,
    required this.iconColor,
    required this.iconBg,
    required this.amountColor,
    required this.category,
    this.fileUrl,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Icon(icon, size: 20, color: iconColor)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "$subtitle • $time",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            "${amount.toStringAsFixed(2)} $currency",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
