import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/core/exceptions/network_exception.dart';
import 'package:budget_zise/data/ui_model/add_expense_request.dart';
import 'package:budget_zise/data/ui_model/recharge_request.dart';
import 'package:budget_zise/domain/models/transaction_type.dart';
import 'package:budget_zise/domain/repositories/dashboard_repository.dart';
import 'package:budget_zise/domain/repositories/public_repository.dart';
import 'package:budget_zise/presentation/cubits/user_cubit.dart';
import 'package:budget_zise/presentation/helpers/ui_alert_helper.dart';
import 'package:budget_zise/presentation/screens/home/new_transaction/widgets/expense_form.dart';
import 'package:budget_zise/presentation/screens/home/new_transaction/widgets/income_form.dart';
import 'package:budget_zise/providers/language_switch_cubit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
part 'new_transaction_screen_controller.dart';

@RoutePage()
class NewTransactionScreen extends StatefulWidget {
  const NewTransactionScreen({super.key});

  @override
  State<NewTransactionScreen> createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final languageSwitchCubit = BlocProvider.of<LanguageSwitchCubit>(context);
    final userCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: ScreenControllerBuilder<NewTransactionScreenController>(
        create: (state) => NewTransactionScreenController(
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
                // Header avec tabs
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Titre et bouton retour
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
                            'Nouvelle Transaction',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Tabs Dépense/Revenu
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
                            fontSize: 16,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          tabs: const [
                            Tab(text: '    Dépense    '),
                            Tab(text: '    Revenu    '),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Contenu des tabs
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: TabBarView(
                      controller: ctrl._tabController,
                      children: [
                        ExpenseForm(ctrl: ctrl),
                        IncomeForm(ctrl: ctrl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
