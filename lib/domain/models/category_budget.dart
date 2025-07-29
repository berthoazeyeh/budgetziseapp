import 'package:budget_zise/domain/models/transaction_type.dart';
import 'package:budget_zise/domain/models/user_model.dart';

class CategoryBudget {
  final int id;
  final double allocatedAmount;
  final double percentage;
  final UserModel user;
  final TransactionType category;
  final int categoryId;
  final int userId;
  final String currency;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final double totalExpenses;

  CategoryBudget({
    required this.id,
    required this.allocatedAmount,
    required this.percentage,
    required this.user,
    required this.category,
    required this.categoryId,
    required this.userId,
    required this.currency,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.totalExpenses,
  });

  factory CategoryBudget.fromJson(Map<String, dynamic> json) {
    return CategoryBudget(
      id: json['id'],
      allocatedAmount: double.tryParse(json['allocatedAmount'].toString()) ?? 0,
      percentage: double.tryParse(json['percentage'].toString()) ?? 0,
      user: UserModel.fromJson(json['user']),
      category: TransactionType.fromJson(json['category']),
      categoryId: json['categoryId'],
      userId: json['userId'],
      currency: json['currency'],
      startDate: DateTime.parse(json['startDate']).toLocal(),
      endDate: DateTime.parse(json['endDate']).toLocal(),
      isActive: json['isActive'],
      totalExpenses: double.tryParse(json['totalExpenses'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'allocatedAmount': allocatedAmount,
      'percentage': percentage,
      'user': user.toJson(),
      'category': category.toJson(),
      'categoryId': categoryId,
      'userId': userId,
      'currency': currency,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
