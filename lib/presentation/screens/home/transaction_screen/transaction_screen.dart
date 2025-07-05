import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:flutter/material.dart';
part 'transaction_screen_controller.dart';

@RoutePage()
class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int _selectedPeriod = 0;
  final List<String> _periods = ['Aujourd\'hui', 'Cette semaine', 'Ce mois'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Transactions',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF667EEA),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('+ Ajouter', style: TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header avec recherche et filtres
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Barre de recherche et filtre
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFE5E7EB),
                            width: 2,
                          ),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Rechercher...',
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFF64748B),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFFE2E8F0)),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.bar_chart, color: Color(0xFF64748B)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Onglets de période
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(4),
                  child: Row(
                    children: _periods.asMap().entries.map((entry) {
                      int index = entry.key;
                      String period = entry.value;
                      bool isSelected = _selectedPeriod == index;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPeriod = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Text(
                              period,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Color(0xFF667EEA)
                                    : Color(0xFF64748B),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Contenu principal
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                // Résumé du jour
                Container(
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
                    border: Border.all(color: Color(0xFFF1F5F9)),
                  ),
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(bottom: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Dépenses',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '-156.30 €',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 40, color: Color(0xFFE2E8F0)),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Revenus',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '+0.00 €',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Transactions d'aujourd'hui
                _buildTransactionSection('Aujourd\'hui', [
                  TransactionItem(
                    icon: '🛒',
                    iconColor: Color(0xFFEF4444),
                    iconBg: Color(0xFFFEF2F2),
                    title: 'Carrefour Market',
                    subtitle: 'Alimentation • Carte bancaire',
                    time: '14:30',
                    amount: '-45.80 €',
                    amountColor: Color(0xFFEF4444),
                    category: 'Alimentaire',
                  ),
                  TransactionItem(
                    icon: '☕',
                    iconColor: Color(0xFFEF4444),
                    iconBg: Color(0xFFFEF2F2),
                    title: 'Starbucks',
                    subtitle: 'Loisirs • Carte bancaire',
                    time: '11:15',
                    amount: '-4.50 €',
                    amountColor: Color(0xFFEF4444),
                    category: 'Café',
                  ),
                  TransactionItem(
                    icon: '🚇',
                    iconColor: Color(0xFFEF4444),
                    iconBg: Color(0xFFFEF2F2),
                    title: 'Métro RATP',
                    subtitle: 'Transport • Paiement mobile',
                    time: '09:30',
                    amount: '-2.15 €',
                    amountColor: Color(0xFFEF4444),
                    category: 'Transport',
                  ),
                ]),
                SizedBox(height: 24),
                // Transactions d'hier
                _buildTransactionSection('Hier', [
                  TransactionItem(
                    icon: '💰',
                    iconColor: Color(0xFF10B981),
                    iconBg: Color(0xFFECFDF5),
                    title: 'Salaire Janvier',
                    subtitle: 'Revenus • Virement',
                    time: '09:00',
                    amount: '+2,800 €',
                    amountColor: Color(0xFF10B981),
                    category: 'Salaire',
                  ),
                  TransactionItem(
                    icon: '🏠',
                    iconColor: Color(0xFFEF4444),
                    iconBg: Color(0xFFFEF2F2),
                    title: 'Loyer Janvier',
                    subtitle: 'Logement • Prélèvement',
                    time: '06:00',
                    amount: '-950 €',
                    amountColor: Color(0xFFEF4444),
                    category: 'Logement',
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionSection(
    String title,
    List<TransactionItem> transactions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        SizedBox(height: 16),
        Container(
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
            border: Border.all(color: Color(0xFFF1F5F9)),
          ),
          child: Column(
            children: transactions.asMap().entries.map((entry) {
              int index = entry.key;
              TransactionItem transaction = entry.value;
              bool isLast = index == transactions.length - 1;

              return Container(
                decoration: BoxDecoration(
                  border: !isLast
                      ? Border(bottom: BorderSide(color: Color(0xFFF1F5F9)))
                      : null,
                ),
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: transaction.iconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          transaction.icon,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            transaction.subtitle,
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            transaction.time,
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          transaction.amount,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: transaction.amountColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          transaction.category,
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class TransactionItem {
  final String icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String time;
  final String amount;
  final Color amountColor;
  final String category;

  TransactionItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.amount,
    required this.amountColor,
    required this.category,
  });
}
