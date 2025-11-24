import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class NewSavingsGoalScreen extends StatefulWidget {
  const NewSavingsGoalScreen({super.key});

  @override
  State<NewSavingsGoalScreen> createState() => _NewSavingsGoalScreenState();
}

class _NewSavingsGoalScreenState extends State<NewSavingsGoalScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _currentAmountController =
      TextEditingController();
  final TextEditingController _monthlyAmountController =
      TextEditingController();
  final TextEditingController _dayOfMonthController = TextEditingController();

  String selectedIcon = '🏖️';
  Priority selectedPriority = Priority.medium;
  DateTime? selectedDate;
  bool isAutoSaveEnabled = false;

  final List<String> availableIcons = [
    '🏖️',
    '🚗',
    '🏠',
    '💻',
    '📱',
    '👕',
    '🎓',
    '💍',
    '🎸',
    '📷',
    '⚽',
    '🎯',
  ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
    _targetAmountController.addListener(() => setState(() {}));
    _currentAmountController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
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
              CustomAppBar(onBackPressed: () => Navigator.pop(context)),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              NameInputCard(controller: _nameController),
                              const SizedBox(height: 16),
                              IconSelectorCard(
                                icons: availableIcons,
                                selectedIcon: selectedIcon,
                                onIconSelected: (icon) {
                                  setState(() => selectedIcon = icon);
                                },
                              ),
                              const SizedBox(height: 16),
                              AmountInputCard(
                                title: 'Montant objectif',
                                controller: _targetAmountController,
                                isTarget: true,
                              ),
                              const SizedBox(height: 16),
                              AmountInputCard(
                                title: 'Montant déjà épargné (optionnel)',
                                controller: _currentAmountController,
                                isTarget: false,
                              ),
                              const SizedBox(height: 16),
                              DatePickerCard(
                                selectedDate: selectedDate,
                                onDateSelected: (date) {
                                  setState(() => selectedDate = date);
                                },
                              ),
                              const SizedBox(height: 16),
                              PriorityCard(
                                selectedPriority: selectedPriority,
                                onPriorityChanged: (priority) {
                                  setState(() => selectedPriority = priority);
                                },
                              ),
                              const SizedBox(height: 16),
                              AutoSaveCard(
                                isEnabled: isAutoSaveEnabled,
                                monthlyController: _monthlyAmountController,
                                dayController: _dayOfMonthController,
                                onToggle: (enabled) {
                                  setState(() => isAutoSaveEnabled = enabled);
                                },
                              ),
                              const SizedBox(height: 16),
                              PreviewCard(
                                name: _nameController.text.isEmpty
                                    ? 'Nom de l\'objectif'
                                    : _nameController.text,
                                icon: selectedIcon,
                                targetAmount:
                                    double.tryParse(
                                      _targetAmountController.text,
                                    ) ??
                                    0,
                                currentAmount:
                                    double.tryParse(
                                      _currentAmountController.text,
                                    ) ??
                                    0,
                                deadline: selectedDate,
                              ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                      BottomActionButtons(
                        onCancel: () => Navigator.pop(context),
                        onSave: _saveGoal,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveGoal() {
    if (_nameController.text.trim().isEmpty) {
      _showError('Veuillez saisir un nom pour votre objectif');
      return;
    }

    final targetAmount = double.tryParse(_targetAmountController.text);
    if (targetAmount == null || targetAmount <= 0) {
      _showError('Veuillez saisir un montant objectif valide');
      return;
    }

    _showSuccess('Objectif créé avec succès !');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }
}

// Composant AppBar personnalisé
class CustomAppBar extends StatelessWidget {
  final VoidCallback onBackPressed;

  const CustomAppBar({super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onBackPressed,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Nouvel Objectif',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Définissez votre prochain objectif d\'épargne',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

// Composant carte de base
class BaseCard extends StatelessWidget {
  final Widget child;

  const BaseCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }
}

// Composant saisie du nom
class NameInputCard extends StatelessWidget {
  final TextEditingController controller;

  const NameInputCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nom de l\'objectif',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Ex: Vacances d\'été, Nouvelle voiture...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E7EB),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF667eea),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }
}

// Composant sélecteur d'icônes
class IconSelectorCard extends StatelessWidget {
  final List<String> icons;
  final String selectedIcon;
  final Function(String) onIconSelected;

  const IconSelectorCard({
    super.key,
    required this.icons,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choisissez une icône',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: icons.length,
            itemBuilder: (context, index) {
              final icon = icons[index];
              final isSelected = icon == selectedIcon;

              return GestureDetector(
                onTap: () => onIconSelected(icon),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF667eea)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF667eea)
                          : const Color(0xFFE2E8F0),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 24)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Composant saisie de montant
class AmountInputCard extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool isTarget;

  const AmountInputCard({
    super.key,
    required this.title,
    required this.controller,
    required this.isTarget,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isTarget ? 24 : 20,
                    fontWeight: FontWeight.bold,
                    color: isTarget
                        ? const Color(0xFF667eea)
                        : const Color(0xFF10b981),
                  ),
                  decoration: InputDecoration(
                    hintText: isTarget ? '2500' : '0',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE5E7EB),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF667eea),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '€',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748b),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Composant sélecteur de date
class DatePickerCard extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;

  const DatePickerCard({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Date limite (optionnel)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate:
                    selectedDate ??
                    DateTime.now().add(const Duration(days: 365)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 3650)),
              );
              onDateSelected(date);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                selectedDate != null
                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                    : 'Sélectionner une date',
                style: TextStyle(
                  fontSize: 16,
                  color: selectedDate != null ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Énumération pour les priorités
enum Priority { low, medium, high }

// Composant sélecteur de priorité
class PriorityCard extends StatelessWidget {
  final Priority selectedPriority;
  final Function(Priority) onPriorityChanged;

  const PriorityCard({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Priorité',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                _buildPriorityOption('🟢 Faible', Priority.low),
                _buildPriorityOption('🟡 Moyenne', Priority.medium),
                _buildPriorityOption('🔴 Élevée', Priority.high),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityOption(String label, Priority priority) {
    final isSelected = selectedPriority == priority;

    return Expanded(
      child: GestureDetector(
        onTap: () => onPriorityChanged(priority),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF667eea)
                  : const Color(0xFF64748b),
            ),
          ),
        ),
      ),
    );
  }
}

// Composant épargne automatique
class AutoSaveCard extends StatelessWidget {
  final bool isEnabled;
  final TextEditingController monthlyController;
  final TextEditingController dayController;
  final Function(bool) onToggle;

  const AutoSaveCard({
    super.key,
    required this.isEnabled,
    required this.monthlyController,
    required this.dayController,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Épargne automatique',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Programmer des virements automatiques',
                        style: TextStyle(
                          color: Color(0xFF64748b),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => onToggle(!isEnabled),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 50,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isEnabled
                          ? const Color(0xFF667eea)
                          : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      alignment: isEnabled
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isEnabled) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Montant mensuel',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: monthlyController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: '100',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE5E7EB),
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF667eea),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '€',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jour du mois',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: dayController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '1',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E7EB),
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF667eea),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// Composant aperçu
class PreviewCard extends StatelessWidget {
  final String name;
  final String icon;
  final double targetAmount;
  final double currentAmount;
  final DateTime? deadline;

  const PreviewCard({
    super.key,
    required this.name,
    required this.icon,
    required this.targetAmount,
    required this.currentAmount,
    this.deadline,
  });

  @override
  Widget build(BuildContext context) {
    final progress = targetAmount > 0
        ? (currentAmount / targetAmount).clamp(0.0, 1.0)
        : 0.0;
    final remaining = targetAmount - currentAmount;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aperçu de l\'objectif',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0c4a6e),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF667eea),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0c4a6e),
                          ),
                        ),
                        Text(
                          '${currentAmount.toInt()}€ / ${targetAmount.toInt()}€',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0c4a6e),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF667eea),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reste ${remaining.toInt()}€',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF0c4a6e),
                          ),
                        ),
                        Text(
                          deadline != null
                              ? '${_getMonthName(deadline!.month)} ${deadline!.year}'
                              : 'Pas de limite',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF0c4a6e),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre',
    ];
    return months[month - 1];
  }
}

// Composant boutons d'action
class BottomActionButtons extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const BottomActionButtons({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF8FAFC),
                foregroundColor: const Color(0xFF64748b),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: const Text(
                'Annuler',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667eea),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Créer l\'objectif',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
