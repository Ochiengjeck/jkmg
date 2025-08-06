// User Model

import 'models.dart';

class User {
  final int id;
  final String name;
  final String? email;
  final String phone;
  final String country;
  final String? timezone;
  final List<String>? prayerTimes;
  final TypeValue churchRole;
  final String initials;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    required this.country,
    this.timezone,
    this.prayerTimes,
    required this.churchRole,
    required this.initials,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String,
      country: json['country'] as String,
      timezone: json['timezone'] as String?,
      prayerTimes: (json['prayer_times'] as List<dynamic>?)?.cast<String>(),
      churchRole: TypeValue.fromJson(
        json['church_role'] as Map<String, dynamic>,
      ),
      initials: json['initials'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
