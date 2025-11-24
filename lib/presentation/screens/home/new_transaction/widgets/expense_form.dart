// Composant pour les dépenses
import 'dart:io';

import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/presentation/cubits/user_cubit.dart';
import 'package:budget_zise/presentation/helpers/image_picker_helper.dart';
import 'package:budget_zise/presentation/screens/home/new_transaction/new_transaction_screen.dart';
import 'package:budget_zise/presentation/utils/icon_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_laravel_form_validation/flutter_laravel_form_validation.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExpenseForm extends StatelessWidget {
  const ExpenseForm({super.key, required this.ctrl});
  final NewTransactionScreenController ctrl;

  @override
  Widget build(BuildContext context) {
    final List<String> paymentMethods = [
      'Carte bancaire',
      'Cash',
      'Virement',
      'Chèque',
      'Paiement mobile',
    ];
    final user = BlocProvider.of<AuthCubit>(context).getSignedInUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: ctrl.formKeyExpense,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carte Montant
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Montant',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: ctrl.amountExpenseController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textAlign: TextAlign.center,
                          validator: ['required', 'numeric', 'min:1'].v,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEF4444),
                          ),
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle: TextStyle(
                              color: const Color(
                                0xFFEF4444,
                              ).withValues(alpha: 0.5),
                            ),
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
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        user.country.currency,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Carte Catégorie
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Catégorie',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Skeletonizer(
                    enabled: ctrl.isLoadingExpensesTypes,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: ctrl.expencesTypes.isNotEmpty
                          ? ctrl.expencesTypes.length
                          : 6,
                      itemBuilder: (context, index) {
                        final isNotEmpty = ctrl.expencesTypes.isNotEmpty;
                        final category = isNotEmpty
                            ? ctrl.expencesTypes[index]
                            : IconMapper.defaultTransactionType;
                        final isSelected =
                            ctrl.selectedCategoryExpense == category.id;
                        var label = category.name;
                        if (category.name.split('/').length > 1) {
                          label = ctrl.languageSwitchCubit.isFrench
                              ? category.name.split('/')[0]
                              : category.name.split('/')[1];
                        }
                        return GestureDetector(
                          onTap: isNotEmpty
                              ? () =>
                                    ctrl.onCategorySelectedExpense(category.id)
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF667eea)
                                  : const Color(0xFFF8FAFC),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF667eea)
                                    : const Color(0xFFE2E8F0),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  IconMapper.getIcon(category.name).icon,
                                  size: 24,
                                  color: isSelected
                                      ? Colors.white
                                      : IconMapper.getIcon(category.name).color,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  label,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF374151),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Carte Détails
            _buildCard(
              child: Column(
                children: [
                  _buildFloatingInput(
                    label: 'Description',
                    controller: ctrl.descriptionController,
                    hint: 'Saisissez une description...',
                    prefixIcon: Icons.description,
                  ),
                  const SizedBox(height: 20),
                  _buildFloatingInput(
                    label: 'Lieu',
                    controller: ctrl.locationController,
                    hint: 'Où avez-vous fait cet achat ?',
                    prefixIcon: Icons.location_on,
                  ),
                  const SizedBox(height: 20),

                  // Mode de paiement
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mode de paiement',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: ctrl.selectedPaymentMethod,
                        decoration: InputDecoration(
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
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                        ),
                        items: paymentMethods.map((method) {
                          return DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          );
                        }).toList(),
                        onChanged: (value) {
                          ctrl.onPaymentMethodSelected(value!);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: ctrl.selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            ctrl.onDateSelected(date);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat(
                                  'dd/MM/yyyy',
                                ).format(ctrl.selectedDate),
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Icon(
                                Icons.calendar_today,
                                color: Color(0xFF64748B),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Carte Photo
            _buildCard(
              child: InkWell(
                onTap: () {
                  ImagePickerHelper.showPickImage(
                    context,
                    onImagePicked: (image) {
                      if (image != null) {
                        ctrl.onReceiptImageSelected(image);
                      }
                    },
                  );
                },
                child: Visibility(
                  visible: ctrl.receiptImage == null,
                  replacement: Image.file(
                    File(ctrl.receiptImage?.path ?? ''),
                    width: double.infinity,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 32,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Ajouter une photo du reçu',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '(Optionnel)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Boutons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF8FAFC),
                      foregroundColor: const Color(0xFF64748B),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Annuler',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: ctrl.saveExpense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF667eea),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: ctrl.isMutating
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Enregistrer',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: child,
    );
  }

  Widget _buildFloatingInput({
    required String label,
    required TextEditingController controller,
    required String hint,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          validator: ['required'].v,
          controller: controller,
          enableSuggestions: true,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(prefixIcon, color: const Color(0xFF64748B)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }
}
