import 'package:budget_zise/domain/models/enums/contribution_type.dart';

class AddContributionRequest {
  final double amount;
  final ContributionType contributionType;
  final String sourceAccount;
  final int? transactionId;
  final String? description;

  AddContributionRequest({
    required this.amount,
    this.contributionType = ContributionType.manual,
    required this.sourceAccount,
    this.transactionId,
    this.description,
  });

  factory AddContributionRequest.fromJson(Map<String, dynamic> json) {
    return AddContributionRequest(
      amount: (json['amount'] as num).toDouble(),
      contributionType: ContributionType.fromString(
        (json['contributionType'] ?? 'manual').toLowerCase(),
      ),
      sourceAccount: json['sourceAccount'] ?? '',
      transactionId: json['transactionId'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'contributionType': contributionType.toJson(),
      'sourceAccount': sourceAccount,
      'transactionId': transactionId,
      'description': description,
    };
  }
}
