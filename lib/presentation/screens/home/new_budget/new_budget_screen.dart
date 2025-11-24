import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/core/exceptions/network_exception.dart';
import 'package:budget_zise/domain/models/transaction_type.dart';
import 'package:budget_zise/domain/repositories/public_repository.dart';
import 'package:budget_zise/presentation/cubits/user_cubit.dart';
import 'package:budget_zise/presentation/helpers/ui_alert_helper.dart';
import 'package:budget_zise/presentation/screens/home/new_budget/widgets/multiple_categorie.dart';
import 'package:budget_zise/presentation/screens/home/new_budget/widgets/single_categorie.dart';
import 'package:budget_zise/providers/language_switch_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
part 'new_budget_screen_controller.dart';

@RoutePage()
class CreateBudgetScreen extends StatefulWidget {
  const CreateBudgetScreen({super.key});

  @override
  State<CreateBudgetScreen> createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends State<CreateBudgetScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final languageSwitchCubit = BlocProvider.of<LanguageSwitchCubit>(context);
    final userCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: ScreenControllerBuilder<NewBudgetScreenController>(
        create: (state) => NewBudgetScreenController(
          state,
          this,
          languageSwitchCubit,
          userCubit,
        ),
        builder: (context, ctrl) => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Nouveau Budget',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lightbulb_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Créez un budget pour mieux gérer vos finances',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          controller: ctrl._tabController,
                          indicator: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8),
                          ),

                          labelColor: const Color(0xFF667eea),
                          unselectedLabelColor: Colors.white.withValues(
                            alpha: 0.8,
                          ),
                          dividerColor: Colors.transparent,

                          indicatorColor: Colors.transparent,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          tabs: const [
                            Tab(text: '    Catégorie unique    '),
                            Tab(text: '    Toutes catégories    '),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: ctrl._tabController,
                    children: [
                      SingleCategorie(ctrl: ctrl),
                      MultipleCategorie(ctrl: ctrl),
                    ],
                  ),
                ),

                // Contenu principal
              ],
            ),
          ),
        ),
      ),
    );
  }
}
