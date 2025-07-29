import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/constants/my_colors.dart';
import 'package:budget_zise/core/exceptions/network_exception.dart';
import 'package:budget_zise/domain/models/category_budget.dart';
import 'package:budget_zise/domain/repositories/budget_repository.dart';
import 'package:budget_zise/presentation/cubits/user_cubit.dart';
import 'package:budget_zise/presentation/helpers/ui_alert_helper.dart';
import 'package:budget_zise/presentation/utils/icon_mapper.dart';
import 'package:budget_zise/providers/language_switch_cubit.dart';
import 'package:flutter/material.dart';
import 'package:budget_zise/router/app_router.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
part 'budget_screen_controller.dart';

@RoutePage()
class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageSwitchCubit = BlocProvider.of<LanguageSwitchCubit>(context);
    final userCubit = BlocProvider.of<AuthCubit>(context);
    return ScreenControllerBuilder<BudgetScreenController>(
      create: (state) =>
          BudgetScreenController(state, languageSwitchCubit, userCubit),
      builder: (context, ctrl) => Scaffold(
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
                onPressed: () {
                  context.router.push(CreateBudgetRoute());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF667EEA),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('+ Créer'),
              ),
            ),
          ],
        ),
        body: RefreshIndicator.adaptive(
          onRefresh: () => ctrl.getBudget(),
          color: MyColors.primary,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Résumé mensuel
                Skeletonizer(
                  enabled: ctrl.isLoading,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                              'Budget ${DateFormat('MMMM yyyy', languageSwitchCubit.currentLocale.languageCode).format(DateTime.now())}',
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
                            _buildBudgetSummaryItem(
                              'Dépensé',
                              '${ctrl.getExpencesTotal()} ${ctrl.userCubit.getSignedInUser.country.currency}',
                              Colors.red,
                            ),
                            _buildBudgetSummaryItem(
                              'Budget Total',
                              '${ctrl.getBudgetTotal()} ${ctrl.userCubit.getSignedInUser.country.currency}',
                              Colors.black,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildBudgetSummaryItem(
                              '% d\'utilisation',
                              '${ctrl.getExpencePercentage().toStringAsFixed(2)}%',
                              Colors.green,
                            ),
                            _buildBudgetSummaryItem(
                              'Reste',
                              '${ctrl.getBudgetTotal() - ctrl.getExpencesTotal()} ${ctrl.userCubit.getSignedInUser.country.currency}',
                              Colors.green,
                            ),
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
                ),

                // Catégories de Budget
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Skeletonizer(
                    enabled: ctrl.isLoading,
                    child: Column(
                      children: [
                        if (ctrl.budget.isNotEmpty)
                          ...List.generate(ctrl.budget.length, (index) {
                            final category = ctrl.budget[index].category;
                            String label = category.name;
                            if (label.split("/").length > 1) {
                              label = languageSwitchCubit.isFrench
                                  ? label.split("/").first
                                  : label.split("/").last;
                            }
                            final iconData = IconMapper.getIcon(category.name);
                            final percentage =
                                (ctrl.budget[index].totalExpenses /
                                ctrl.budget[index].allocatedAmount);
                            String status = "";
                            if (percentage >= 1) {
                              status =
                                  "budget dépassé ${((1 - percentage) * 100).toStringAsFixed(2)}%";
                            } else {
                              final days = (ctrl.budget[index].endDate
                                  .difference(DateTime.now())
                                  .inDays);
                              status = "$days jour(s) restants";
                            }
                            return _buildBudgetItem(
                              icon: iconData.icon,
                              color: iconData.color,
                              iconColor: iconData.iconColor,
                              isOverBudget: percentage >= 1,
                              currency: ctrl
                                  .userCubit
                                  .getSignedInUser
                                  .country
                                  .currency,
                              title: label,
                              current: ctrl.budget[index].totalExpenses.toInt(),
                              total: ctrl.budget[index].allocatedAmount.toInt(),
                              progress: percentage,
                              remaining:
                                  '${ctrl.budget[index].allocatedAmount - ctrl.budget[index].totalExpenses} ${ctrl.userCubit.getSignedInUser.country.currency}',
                              status: status,
                              progressColor: iconData.color,
                            );
                          }),
                        if (ctrl.budget.isEmpty)
                          ...List.generate(
                            5,
                            (index) => _buildBudgetItem(
                              icon: Icons.restaurant,
                              currency: ctrl
                                  .userCubit
                                  .getSignedInUser
                                  .country
                                  .currency,
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
                          ),
                      ],
                    ),
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetItem({
    required IconData icon,
    required Color color,
    required Color? iconColor,
    required String title,
    required int current,
    required int total,
    required double progress,
    required String remaining,
    required String status,
    required String currency,
    required Color progressColor,
    bool isOverBudget = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: Icon(icon, size: 24, color: iconColor)),
          ),
          SizedBox(width: 10),

          // Contenu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 5,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    Text(
                      '${current.toStringAsFixed(0)}$currency / ${total.toStringAsFixed(0)}$currency',
                      style: TextStyle(
                        fontSize: 13,
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
