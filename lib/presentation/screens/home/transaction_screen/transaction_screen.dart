import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/core/exceptions/network_exception.dart';
import 'package:budget_zise/core/network/api_response.dart';
import 'package:budget_zise/data/services/dashboard_sevices.dart';
import 'package:budget_zise/domain/models/transaction.dart';
import 'package:budget_zise/domain/models/transaction_type.dart';
import 'package:budget_zise/domain/repositories/dashboard_repository.dart';
import 'package:budget_zise/domain/repositories/public_repository.dart';
import 'package:budget_zise/presentation/cubits/user_cubit.dart';
import 'package:budget_zise/presentation/helpers/ui_alert_helper.dart';
import 'package:budget_zise/presentation/screens/home/transaction_screen/widgets/categories_picker.dart';
import 'package:budget_zise/presentation/utils/icon_mapper.dart';
import 'package:budget_zise/providers/language_switch_cubit.dart';
import 'package:budget_zise/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
part 'transaction_screen_controller.dart';

@RoutePage()
class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint(context.router.currentPath);
    final languageSwitchCubit = BlocProvider.of<LanguageSwitchCubit>(context);
    final userCubit = BlocProvider.of<AuthCubit>(context);
    final currency = userCubit.getSignedInUser.country.currency;
    return ScreenControllerBuilder<TransactionScreenController>(
      create: (state) =>
          TransactionScreenController(state, languageSwitchCubit, userCubit),
      builder: (context, ctrl) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Transactions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton(
                onPressed: () {
                  context.router.push(const NewTransactionRoute()).then((
                    value,
                  ) {
                    ctrl.refreshTransactions();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('+ Ajouter', style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => ctrl.refreshTransactions(),
          child: Column(
            children: [
              // Header avec recherche et filtres
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
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
                                color: const Color(0xFFE5E7EB),
                                width: 2,
                              ),
                            ),
                            child: const TextField(
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
                        const SizedBox(width: 12),
                        PopupMenuButton<String>(
                          position: PopupMenuPosition.under,
                          onSelected: (String value) {
                            if (ctrl.isLoadingCategories) {
                              return;
                            }
                            ctrl.getCategories();
                            CategoriesPicker.show(
                              context,
                              (categoryId) => ctrl.changeCategory(categoryId),
                              ctrl.selectedCategoryId,
                              ctrl.categories,
                              ctrl.isLoadingCategories,
                            );
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: '1',
                                  child: Row(
                                    children: [
                                      Icon(Icons.arrow_drop_down),
                                      Text('Trier par depence'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: '2',
                                  child: Row(
                                    children: [
                                      Icon(Icons.arrow_drop_down),
                                      Text('Trier par Revenu'),
                                    ],
                                  ),
                                ),
                              ],
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: const Icon(
                              Icons.bar_chart,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Onglets de période
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: ctrl.periods.asMap().entries.map((entry) {
                          final int index = entry.key;
                          final String period = entry.value;
                          final bool isSelected = ctrl.selectedPeriod == index;

                          return Expanded(
                            child: GestureDetector(
                              onTap: () => ctrl.changePeriod(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.05,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : [],
                                ),
                                padding: const EdgeInsets.symmetric(
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
                                        ? const Color(0xFF667EEA)
                                        : const Color(0xFF64748B),
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
                  controller: ctrl.scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Résumé du jour
                    Skeletonizer(
                      enabled: ctrl.isLoadingTransactionsStats,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 15,
                        ),
                        margin: const EdgeInsets.only(bottom: 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Dépenses',
                                    style: TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '-${ctrl.transactionsStats?.totalExpenses.toStringAsFixed(1)} ',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFEF4444),
                                        ),
                                      ),
                                      Text(
                                        ' $currency',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFEF4444),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: const Color(0xFFE2E8F0),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Revenus',
                                    style: TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '+${ctrl.transactionsStats?.totalRecharges.toStringAsFixed(1)} ',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF10B981),
                                        ),
                                      ),
                                      Text(
                                        ' $currency',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF10B981),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible:
                          ctrl.groupByDate().isEmpty &&
                          !ctrl.isLoadingTransactions,
                      child: const Center(
                        child: Text(
                          'Aucune transaction trouvée pour cette période',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                    Skeletonizer(
                      enabled: ctrl.isLoadingTransactions && ctrl.nextPage == 1,
                      child: Visibility(
                        visible: ctrl.groupByDate().isNotEmpty,
                        child: Builder(
                          builder: (BuildContext context) {
                            return Column(
                              children: ctrl.groupByDate().entries.toList().map(
                                (e) {
                                  final String date = e.key;
                                  final List<Transaction> transactions =
                                      e.value;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _buildTransactionSection(
                                      ctrl.formatRelativeDate(
                                        Moment.parse(date),
                                      ),
                                      transactions.map((e) {
                                        final icon = IconMapper.getIcon(
                                          e.categoryName,
                                        );
                                        final isExpense =
                                            e.transactionType == "Expense";
                                        final amount = isExpense
                                            ? -e.amount
                                            : e.amount;
                                        String category = e.categoryName;
                                        if (category.split("/").length > 1) {
                                          if (languageSwitchCubit.isFrench) {
                                            category = category
                                                .split("/")
                                                .first
                                                .trim();
                                          } else {
                                            category = category.split("/").last;
                                          }
                                        }
                                        return TransactionItem(
                                          icon: icon.icon,
                                          iconColor: icon.iconColor,
                                          iconBg: icon.color,
                                          title: category,
                                          subtitle:
                                              e.description ??
                                              e.transactionReference ??
                                              "",
                                          time: Moment(e.date).format('HH:mm'),
                                          amount:
                                              "${amount.toStringAsFixed(2)} €",
                                          amountColor: isExpense
                                              ? const Color(0xFFEF4444)
                                              : const Color(0xFF10B981),
                                          category: e.paymentMethod,
                                          fileUrl: e.receiptUrl,
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              ).toList(),
                            );
                          },
                        ),
                      ),
                    ),
                    Skeletonizer(
                      enabled: ctrl.isLoadingTransactions,
                      child: Visibility(
                        visible: ctrl.isLoadingTransactions,
                        child:
                            // Transactions d'aujourd'hui
                            _buildTransactionSection('Aujourd\'hui', [
                              TransactionItem(
                                icon: Icons.shopping_cart,
                                iconColor: const Color(0xFFEF4444),
                                iconBg: const Color(0xFFFEF2F2),
                                title: 'Carrefour Market',
                                subtitle: 'Alimentation • Carte bancaire',
                                time: '14:30',
                                amount: '-45.80 €',
                                amountColor: const Color(0xFFEF4444),
                                category: 'Alimentaire',
                              ),
                              TransactionItem(
                                icon: Icons.coffee,
                                iconColor: const Color(0xFFEF4444),
                                iconBg: const Color(0xFFFEF2F2),
                                title: 'Starbucks',
                                subtitle: 'Loisirs • Carte bancaire',
                                time: '11:15',
                                amount: '-4.50 €',
                                amountColor: const Color(0xFFEF4444),
                                category: 'Café',
                              ),
                              TransactionItem(
                                icon: Icons.train,
                                iconColor: const Color(0xFFEF4444),
                                iconBg: const Color(0xFFFEF2F2),
                                title: 'Métro RATP',
                                subtitle: 'Transport • Paiement mobile',
                                time: '09:30',
                                amount: '-2.15 €',
                                amountColor: const Color(0xFFEF4444),
                                category: 'Transport',
                              ),
                            ]),
                      ),
                    ),
                    Visibility(
                      visible:
                          ctrl.isLoadingTransactions &&
                          ctrl.groupByDate().isNotEmpty,
                      child: const Center(child: CircularProgressIndicator()),
                    ),

                    const SizedBox(height: 200),
                  ],
                ),
              ),
            ],
          ),
        ),
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Column(
            children: transactions.asMap().entries.map((entry) {
              final int index = entry.key;
              final TransactionItem transaction = entry.value;
              final bool isLast = index == transactions.length - 1;

              return Container(
                decoration: BoxDecoration(
                  border: !isLast
                      ? const Border(
                          bottom: BorderSide(color: Color(0xFFF1F5F9)),
                        )
                      : null,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: transaction.iconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          transaction.icon,
                          size: 20,
                          color: transaction.iconColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            transaction.subtitle,
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            transaction.time,
                            style: const TextStyle(
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
                        const SizedBox(height: 4),
                        Text(
                          transaction.category,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (transaction.fileUrl != null)
                          const Icon(
                            Icons.file_present,
                            color: Color.fromARGB(255, 73, 128, 206),
                            size: 16,
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
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String time;
  final String amount;
  final Color amountColor;
  final String category;
  final String? fileUrl;
  final String? place;
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
    this.fileUrl,
    this.place,
  });
}
