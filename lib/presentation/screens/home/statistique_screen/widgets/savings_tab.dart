import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Composant pour l'onglet Épargne
class SavingsTab extends StatelessWidget {
  const SavingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Résumé de l'épargne
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Épargne totale',
                  value: '4,750 €',
                  change: '+8% ce mois',
                  isPositive: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: 'Épargne mensuelle',
                  value: '350 €',
                  change: '+12% vs mois dernier',
                  isPositive: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Graphique d'évolution de l'épargne
          _buildChartCard(
            title: 'Évolution de l\'épargne',
            child: SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 4200),
                        const FlSpot(1, 4350),
                        const FlSpot(2, 4500),
                        const FlSpot(3, 4600),
                        const FlSpot(4, 4750),
                      ],
                      isCurved: true,
                      color: const Color(0xFF0EA5E9),
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF0EA5E9).withValues(alpha: 0.1),
                      ),
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Objectifs d'épargne
          _buildSavingsGoalsCard(),
          const SizedBox(height: 20),

          // Comptes d'épargne
          _buildSavingsAccountsCard(),
          const SizedBox(height: 20),

          // Conseils d'épargne
          _buildSavingsTipsCard(),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String change,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0EA5E9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            change,
            style: TextStyle(
              fontSize: 12,
              color: isPositive
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF667EEA),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildSavingsGoalsCard() {
    final goals = [
      {
        'title': 'Fonds d\'urgence',
        'target': '6,000 €',
        'current': '4,750 €',
        'progress': 0.79,
        'color': const Color(0xFF10B981),
        'icon': '🛡️',
      },
      {
        'title': 'Vacances été',
        'target': '3,000 €',
        'current': '1,200 €',
        'progress': 0.4,
        'color': const Color(0xFF0EA5E9),
        'icon': '🏖️',
      },
      {
        'title': 'Nouvelle voiture',
        'target': '15,000 €',
        'current': '2,800 €',
        'progress': 0.19,
        'color': const Color(0xFFF59E0B),
        'icon': '🚗',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Objectifs d\'épargne',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ...goals.map((goal) => _buildGoalItem(goal)),
        ],
      ),
    );
  }

  Widget _buildGoalItem(Map<String, dynamic> goal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(goal['icon'], style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  goal['title'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '${goal['current']} / ${goal['target']}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: goal['progress'],
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(goal['color']),
          ),
          const SizedBox(height: 8),
          Text(
            '${(goal['progress'] * 100).toInt()}% atteint',
            style: TextStyle(
              fontSize: 12,
              color: goal['color'],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsAccountsCard() {
    final accounts = [
      {
        'name': 'Livret A',
        'balance': '2,500 €',
        'rate': '3.0%',
        'icon': '🏦',
        'color': const Color(0xFFECFDF5),
      },
      {
        'name': 'Compte épargne',
        'balance': '1,750 €',
        'rate': '2.5%',
        'icon': '💳',
        'color': const Color(0xFFF0F9FF),
      },
      {
        'name': 'PEL',
        'balance': '500 €',
        'rate': '2.2%',
        'icon': '📊',
        'color': const Color(0xFFFEF3C7),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comptes d\'épargne',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ...accounts.map((account) => _buildAccountItem(account)),
        ],
      ),
    );
  }

  Widget _buildAccountItem(Map<String, dynamic> account) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: account['color'],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                account['icon'],
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Taux: ${account['rate']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            account['balance'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0EA5E9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsTipsCard() {
    final tips = [
      {
        'title': 'Automatisez vos virements',
        'description': 'Programmez un virement automatique chaque mois',
        'icon': '🤖',
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Règle des 50/30/20',
        'description': '50% besoins, 30% envies, 20% épargne',
        'icon': '📈',
        'color': const Color(0xFF0EA5E9),
      },
      {
        'title': 'Diversifiez vos placements',
        'description': 'Ne mettez pas tous vos œufs dans le même panier',
        'icon': '🎯',
        'color': const Color(0xFFF59E0B),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Conseils d\'épargne',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ...tips.map((tip) => _buildTipItem(tip)),
        ],
      ),
    );
  }

  Widget _buildTipItem(Map<String, dynamic> tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tip['color'].withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tip['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(tip['icon'], style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip['title'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip['description'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
