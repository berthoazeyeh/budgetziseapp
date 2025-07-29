import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:flutter/material.dart';

import 'widgets/expenses_tab.dart';
import 'widgets/incomes_tab.dart';
import 'widgets/savings_tab.dart';
part 'statistique_screen_controller.dart';

@RoutePage()
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ScreenControllerBuilder<StatisticsScreenController>(
      create: (state) => StatisticsScreenController(state, this),
      builder: (context, ctrl) => Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Statistiques',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 16),
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: ctrl.selectedPeriod,
                items: ['Ce mois', '3 derniers mois', 'Cette année'].map((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // setState(() {
                  //   selectedPeriod = newValue!;
                  // });
                },
                underline: Container(),
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Container(
              padding: EdgeInsets.all(4),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: ctrl._tabController,
                tabs: [
                  Tab(text: 'Dépenses'),
                  Tab(text: 'Revenus'),
                  Tab(text: 'Épargne'),
                ],

                labelColor: Color(0xFF667eea),
                unselectedLabelColor: Colors.black.withValues(alpha: 0.8),
                dividerColor: Colors.transparent,

                indicatorColor: Color(0xFF667eea),
                indicatorWeight: 3,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: ctrl._tabController,
          children: [ExpensesTab(), IncomesTab(), SavingsTab()],
        ),
      ),
    );
  }
}
