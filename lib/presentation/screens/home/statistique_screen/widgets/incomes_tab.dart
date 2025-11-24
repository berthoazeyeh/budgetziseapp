import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Composant pour l'onglet Revenus
class IncomesTab extends StatelessWidget {
  const IncomesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Résumé des revenus
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Total revenus',
                  value: '2,800 €',
                  change: '+3% vs mois dernier',
                  isPositive: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: 'Revenus nets',
                  value: '2,350 €',
                  change: '+2% vs mois dernier',
                  isPositive: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Graphique d'évolution des revenus
          _buildChartCard(
            title: 'Évolution des revenus',
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
                        const FlSpot(0, 2600),
                        const FlSpot(1, 2700),
                        const FlSpot(2, 2750),
                        const FlSpot(3, 2720),
                        const FlSpot(4, 2800),
                      ],
                      isCurved: true,
                      color: const Color(0xFF10B981),
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      ),
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Sources de revenus
          _buildRevenueSourcesCard(),
          const SizedBox(height: 20),

          // Historique des revenus
          _buildRevenueHistoryCard(),
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
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF10B981),
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

  Widget _buildRevenueSourcesCard() {
    final sources = [
      {
        'title': 'Salaire principal',
        'amount': '2,500 €',
        'icon': '💼',
        'color': const Color(0xFFECFDF5),
      },
      {
        'title': 'Freelance',
        'amount': '200 €',
        'icon': '💻',
        'color': const Color(0xFFF0F9FF),
      },
      {
        'title': 'Investissements',
        'amount': '100 €',
        'icon': '📈',
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
            'Sources de revenus',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ...sources.map((source) => _buildRevenueSourceItem(source)),
        ],
      ),
    );
  }

  Widget _buildRevenueSourceItem(Map<String, dynamic> source) {
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
              color: source['color'],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(source['icon'], style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              source['title'],
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            source['amount'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueHistoryCard() {
    final history = [
      {'title': 'Salaire Janvier', 'date': '01/01/2025', 'amount': '+2,500 €'},
      {'title': 'Freelance Projet A', 'date': '15/01/2025', 'amount': '+150 €'},
      {'title': 'Dividendes', 'date': '20/01/2025', 'amount': '+50 €'},
      {'title': 'Freelance Projet B', 'date': '25/01/2025', 'amount': '+100 €'},
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
            'Historique des revenus',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ...history.map((item) => _buildHistoryItem(item)),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  item['date'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            item['amount'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }
}
