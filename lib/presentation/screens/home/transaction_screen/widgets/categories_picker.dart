import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/domain/models/transaction_type.dart';
import 'package:budget_zise/presentation/utils/icon_mapper.dart';
import 'package:budget_zise/providers/language_switch_cubit.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoriesPicker extends StatelessWidget {
  const CategoriesPicker({
    super.key,
    required this.onChanged,
    this.selectedCategoryId,
    required this.categories,
    this.isLoading = false,
  });
  final List<TransactionType> categories;
  final Function(int) onChanged;
  final int? selectedCategoryId;
  final bool isLoading;
  static void show(
    BuildContext context,
    Function(int) onChanged,
    int? selectedCategoryId,
    List<TransactionType> categories,
    bool isLoading,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CategoriesPicker(
        onChanged: onChanged,
        selectedCategoryId: selectedCategoryId,
        categories: categories,
        isLoading: isLoading,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final languageSwitchCubit = BlocProvider.of<LanguageSwitchCubit>(context);
    return Container(
      height: screenSize.height * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: screenSize.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 10,
            width: screenSize.width * 0.5,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Catégories de Depense',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 10),
          Expanded(
            child: Skeletonizer(
              enabled: isLoading && categories.isEmpty,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: categories.isNotEmpty ? categories.length : 6,
                itemBuilder: (context, index) {
                  final isNotEmpty = categories.isNotEmpty;
                  final category = isNotEmpty
                      ? categories[index]
                      : IconMapper.defaultTransactionType;
                  final isSelected = selectedCategoryId == category.id;
                  var label = category.name;
                  if (category.name.split('/').length > 1) {
                    label = languageSwitchCubit.isFrench
                        ? category.name.split('/')[0]
                        : category.name.split('/')[1];
                  }
                  return GestureDetector(
                    onTap: isNotEmpty ? () => onChanged(category.id) : null,
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
          ),
        ],
      ),
    );
  }
}
