import 'package:budget_zise/domain/models/country.dart';
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
  final String? city;
  final String? address;
  final String? pinCode;
  final Country country;

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
    required this.imageUrl,
    required this.role,
    required this.country,
    this.city,
    this.address,
    this.fcmToken,
    this.pinCode,
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
      country: Country.fromJson(json['country']),
      city: json['city'],
      address: json['address'],
      pinCode: json['pinCode'],
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
      'dateOfBirth': dateOfBirth.toUtc().toIso8601String(),
      'isActive': isActive,
      'isBlocked': isBlocked,
      'fcmToken': fcmToken,
      'imageUrl': imageUrl,
      'role': role,
      'country': country.toJson(),
      'city': city,
      'address': address,
      'pinCode': pinCode,
    };
  }

  UserModel copyWith({
    String? fcmToken,
    String? city,
    String? address,
    String? imageUrl,
    String? role,
    Country? country,
    String? phoneNumber,
    String? token,
    DateTime? dateOfBirth,
    bool? isActive,
    bool? isBlocked,
    String? firstName,
    String? lastName,
    String? email,
    String? pinCode,
  }) {
    return UserModel(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      token: token ?? this.token,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isActive: isActive ?? this.isActive,
      isBlocked: isBlocked ?? this.isBlocked,
      fcmToken: fcmToken ?? this.fcmToken,
      imageUrl: imageUrl ?? this.imageUrl,
      role: role ?? this.role,
      country: country ?? this.country,
      city: city ?? this.city,
      address: address ?? this.address,
      pinCode: pinCode ?? this.pinCode,
    );
  }
}
