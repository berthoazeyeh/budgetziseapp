import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Composant pour l'onglet Dépenses
class ExpensesTab extends StatelessWidget {
  const ExpensesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Résumé des dépenses
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Total dépensé',
                  value: '2,680 €',
                  change: '+15% vs mois dernier',
                  isPositive: false,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: 'Moyenne/jour',
                  value: '89 €',
                  change: '-5% vs mois dernier',
                  isPositive: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Graphique d'évolution
          _buildChartCard(
            title: 'Évolution des dépenses',
            child: SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 2200),
                        FlSpot(1, 2400),
                        FlSpot(2, 2100),
                        FlSpot(3, 2800),
                        FlSpot(4, 2680),
                      ],
                      isCurved: true,
                      color: Color(0xFF667EEA),
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Color(0xFF667EEA).withValues(alpha: 0.1),
                      ),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),

          // Répartition par catégorie
          _buildChartCard(
            title: 'Répartition par catégorie',
            subtitle: 'Janvier 2025',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 120,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 30,
                            sections: _buildPieChartSections(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegendItem(
                            'Logement',
                            '35%',
                            Color(0xFF10B981),
                          ),
                          _buildLegendItem(
                            'Alimentation',
                            '22%',
                            Color(0xFF667EEA),
                          ),
                          _buildLegendItem('Loisirs', '12%', Color(0xFFEF4444)),
                          _buildLegendItem(
                            'Transport',
                            '7%',
                            Color(0xFFF59E0B),
                          ),
                          _buildLegendItem('Autres', '24%', Color(0xFF0EA5E9)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Top 5 des dépenses
          _buildTopExpensesCard(),
          SizedBox(height: 20),

          // Analyse intelligente
          _buildAnalysisCard(),
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
      padding: EdgeInsets.all(16),
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: title.contains('Total') ? Color(0xFFEF4444) : Colors.black,
            ),
          ),
          SizedBox(height: 4),
          Text(
            change,
            style: TextStyle(
              fontSize: 12,
              color: isPositive ? Color(0xFF10B981) : Color(0xFFEF4444),
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
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Color(0xFF667EEA)),
                ),
            ],
          ),
          SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return [
      PieChartSectionData(
        color: Color(0xFF10B981),
        value: 35,
        title: '',
        radius: 30,
      ),
      PieChartSectionData(
        color: Color(0xFF667EEA),
        value: 22,
        title: '',
        radius: 30,
      ),
      PieChartSectionData(
        color: Color(0xFFEF4444),
        value: 12,
        title: '',
        radius: 30,
      ),
      PieChartSectionData(
        color: Color(0xFFF59E0B),
        value: 7,
        title: '',
        radius: 30,
      ),
      PieChartSectionData(
        color: Color(0xFF0EA5E9),
        value: 24,
        title: '',
        radius: 30,
      ),
    ];
  }

  Widget _buildLegendItem(String label, String percentage, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Text(
            percentage,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildTopExpensesCard() {
    final expenses = [
      {
        'title': 'Loyer',
        'date': '01/01/2025',
        'amount': '-950 €',
        'icon': '🏠',
        'color': Color(0xFFFEF2F2),
      },
      {
        'title': 'Courses Carrefour',
        'date': '02/01/2025',
        'amount': '-156 €',
        'icon': '🍕',
        'color': Color(0xFFFEF3C7),
      },
      {
        'title': 'Cinéma + Restaurant',
        'date': '02/01/2025',
        'amount': '-89 €',
        'icon': '🎯',
        'color': Color(0xFFF0F9FF),
      },
      {
        'title': 'Essence Total',
        'date': '03/01/2025',
        'amount': '-75 €',
        'icon': '⛽',
        'color': Color(0xFFECFDF5),
      },
      {
        'title': 'Vêtements H&M',
        'date': '03/01/2025',
        'amount': '-68 €',
        'icon': '👕',
        'color': Color(0xFFFEF2F2),
      },
    ];

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top 5 des dépenses',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          ...expenses.map((expense) => _buildExpenseItem(expense)),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(Map<String, dynamic> expense) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: expense['color'],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(expense['icon'], style: TextStyle(fontSize: 18)),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense['title'],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  expense['date'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            expense['amount'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFECFDF5), Color(0xFFD1FAE5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('🤖', style: TextStyle(fontSize: 24)),
              SizedBox(width: 12),
              Text(
                'Analyse intelligente',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF065F46),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Vos dépenses alimentaires ont augmenté de 23% ce mois-ci. Essayez de planifier vos repas à l\'avance pour économiser.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF065F46),
              height: 1.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '💡 Astuce : Préparez une liste de courses et respectez-la pour éviter les achats impulsifs.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF065F46),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
