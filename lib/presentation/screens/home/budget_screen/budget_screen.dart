import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:flutter/material.dart';
part 'budget_screen_controller.dart';

@RoutePage()
class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Mes Budgets',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: () {},
              child: Text('+ Créer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF667EEA),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Résumé mensuel
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Budget Janvier 2025',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '📊 Bien géré',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBudgetSummaryItem('Dépensé', '2,680 €', Colors.red),
                      _buildBudgetSummaryItem(
                        'Budget Total',
                        '3,200 €',
                        Colors.black,
                      ),
                      _buildBudgetSummaryItem('Reste', '520 €', Colors.green),
                    ],
                  ),
                  SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: 0.84,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF667EEA),
                    ),
                    minHeight: 12,
                  ),
                ],
              ),
            ),

            // Catégories de Budget
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildBudgetItem(
                    icon: '🍕',
                    color: Colors.red[50]!,
                    iconColor: Colors.red,
                    title: 'Alimentation',
                    current: 580,
                    total: 700,
                    progress: 0.83,
                    remaining: 'Reste 120€',
                    status: '17 jours restants',
                    progressColor: Color(0xFF667EEA),
                  ),
                  _buildBudgetItem(
                    icon: '🚗',
                    color: Colors.amber[50]!,
                    iconColor: Colors.amber,
                    title: 'Transport',
                    current: 180,
                    total: 250,
                    progress: 0.72,
                    remaining: 'Reste 70€',
                    status: 'Dans les temps',
                    progressColor: Colors.amber,
                  ),
                  _buildBudgetItem(
                    icon: '🎯',
                    color: Colors.red[50]!,
                    iconColor: Colors.red,
                    title: 'Loisirs',
                    current: 320,
                    total: 300,
                    progress: 1.07,
                    remaining: 'Dépassement de 20€',
                    status: '⚠️ Attention',
                    progressColor: Colors.red,
                    isOverBudget: true,
                  ),
                  _buildBudgetItem(
                    icon: '🏠',
                    color: Colors.green[50]!,
                    iconColor: Colors.green,
                    title: 'Logement',
                    current: 950,
                    total: 1000,
                    progress: 0.95,
                    remaining: 'Reste 50€',
                    status: 'Stable',
                    progressColor: Colors.green,
                  ),
                  _buildBudgetItem(
                    icon: '💊',
                    color: Colors.blue[50]!,
                    iconColor: Colors.blue,
                    title: 'Santé',
                    current: 45,
                    total: 150,
                    progress: 0.30,
                    remaining: 'Reste 105€',
                    status: 'Très bon',
                    progressColor: Colors.blue,
                  ),
                ],
              ),
            ),

            // Conseil du mois
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber[100]!, Colors.orange[100]!],
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
                      Text('💡', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 12),
                      Text(
                        'Conseil du mois',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Vous avez dépassé votre budget loisirs de 20€. Essayez de réduire vos sorties cette semaine pour rattraper !',
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 100), // Espace pour la bottom navigation
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetSummaryItem(String label, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetItem({
    required String icon,
    required Color color,
    required Color? iconColor,
    required String title,
    required int current,
    required int total,
    required double progress,
    required String remaining,
    required String status,
    required Color progressColor,
    bool isOverBudget = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: Text(icon, style: TextStyle(fontSize: 24))),
          ),
          SizedBox(width: 16),

          // Contenu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${current}€ / ${total}€',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isOverBudget ? Colors.red : Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // Barre de progression
                LinearProgressIndicator(
                  value: progress > 1.0 ? 1.0 : progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  minHeight: 8,
                ),
                SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      remaining,
                      style: TextStyle(
                        fontSize: 12,
                        color: isOverBudget ? Colors.red : Colors.grey[600],
                      ),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        color: isOverBudget ? Colors.red : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Classe de modèle pour les données de budget (optionnel)
class BudgetCategory {
  final String name;
  final String icon;
  final int currentAmount;
  final int totalAmount;
  final Color color;
  final Color iconColor;

  BudgetCategory({
    required this.name,
    required this.icon,
    required this.currentAmount,
    required this.totalAmount,
    required this.color,
    required this.iconColor,
  });

  double get progress => currentAmount / totalAmount;
  bool get isOverBudget => currentAmount > totalAmount;
  int get remaining => totalAmount - currentAmount;
}
