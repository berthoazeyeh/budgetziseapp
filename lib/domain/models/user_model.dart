import 'package:budget_zise/presentation/helpers/ui_alert_helper.dart';

class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String token;
  final String phoneNumber;
  final DateTime dateOfBirth;
  final bool isActive;
  final bool isBlocked;
  final String? fcmToken;
  final String imageUrl;
  final String role;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.token,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.isActive,
    required this.isBlocked,
    this.fcmToken,
    required this.imageUrl,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      token: json['token'],
      phoneNumber: json['phoneNumber'],
      dateOfBirth: safeDateParsing(json['dateOfBirth'].toString()),
      isActive: json['isActive'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
      fcmToken: json['fcmToken'],
      imageUrl: json['imageUrl'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'token': token,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'isActive': isActive,
      'isBlocked': isBlocked,
      'fcmToken': fcmToken,
      'imageUrl': imageUrl,
      'role': role,
    };
  }
}
