import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/router/app_router.dart';
import 'package:budget_zise/presentation/cubits/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:budget_zise/constants/my_colors.dart';
part 'dashboard_screen_controller.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().getSignedInUser;
    return Scaffold(
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
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.imageUrl),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Solde Principal
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          const Text(
                            '2,485.50 €',
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
                                  children: const [
                                    Text(
                                      'Ce mois',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '+650 €',
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
                                      style: TextStyle(color: Colors.white70),
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
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Expanded(
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
                            amount: '+3,200 €',
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            icon: '📉',
                            label: 'Dépenses',
                            amount: '-2,550 €',
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                              onTap: () {},
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
                        BudgetCard(
                          title: "Alimentation",
                          emoji: "🍕",
                          spent: 580,
                          limit: 700,
                        ),
                        BudgetCard(
                          title: "Alimentation",
                          emoji: "🍕",
                          spent: 580,
                          limit: 700,
                        ),
                        BudgetCard(
                          title: "Alimentation",
                          emoji: "🍕",
                          spent: 580,
                          limit: 700,
                        ),
                        BudgetCard(
                          title: "Alimentation",
                          emoji: "🍕",
                          spent: 580,
                          limit: 700,
                        ),
                        BudgetCard(
                          title: "Alimentation",
                          emoji: "🍕",
                          spent: 580,
                          limit: 700,
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(20),

                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                              onTap: () {},
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
                        TransactionItem(
                          emoji: "🛒",
                          title: "Carrefour Market",
                          subtitle: "Alimentation",
                          time: "Aujourd'hui 14:30",
                          amount: 45.80,
                        ),
                        TransactionItem(
                          emoji: "🛒",
                          title: "Carrefour Market",
                          subtitle: "Alimentation",
                          time: "Aujourd'hui 14:30",
                          amount: 45.80,
                        ),
                        TransactionItem(
                          emoji: "🛒",
                          title: "Carrefour Market",
                          subtitle: "Alimentation",
                          time: "Aujourd'hui 14:30",
                          amount: 45.80,
                        ),
                        TransactionItem(
                          emoji: "🛒",
                          title: "Carrefour Market",
                          subtitle: "Alimentation",
                          time: "Aujourd'hui 14:30",
                          amount: 45.80,
                        ),
                        TransactionItem(
                          emoji: "🛒",
                          title: "Carrefour Market",
                          subtitle: "Alimentation",
                          time: "Aujourd'hui 14:30",
                          amount: 45.80,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.primary,
        onPressed: () {
          context.replaceRoute(const HomeRoute());
        },
        child: const Icon(Icons.add),
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
              fontSize: 20,
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
  final String emoji;
  final double spent;
  final double limit;

  const BudgetCard({
    super.key,
    required this.title,
    required this.emoji,
    required this.spent,
    required this.limit,
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
              Text(
                "$emoji $title",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
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
  final String emoji;
  final String title;
  final String subtitle;
  final String time;
  final double amount;
  final bool isIncome;

  const TransactionItem({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.amount,
    this.isIncome = false,
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
              color: isIncome
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
            "${isIncome ? '+' : '-'}${amount.toStringAsFixed(2)} €",
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
