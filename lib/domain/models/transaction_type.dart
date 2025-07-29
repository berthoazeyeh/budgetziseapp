class TransactionType {
  final int id;
  final String name;
  final String description;
  final List<dynamic> expenses;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionType({
    required this.id,
    required this.name,
    required this.description,
    required this.expenses,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionType.fromJson(Map<String, dynamic> json) =>
      TransactionType(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        expenses: json['expenses'] ?? [],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt']).toLocal()
            : DateTime.now().toLocal(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt']).toLocal()
            : DateTime.now().toLocal(),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'expenses': expenses,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
  };
}
