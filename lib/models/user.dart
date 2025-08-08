// User Model

import 'models.dart';

class User {
  final int id;
  final String name;
  final String? email;
  final String phone;
  final String country;
  final String timezone;
  final List<String> prayerTimes;
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
    required this.timezone,
    required this.prayerTimes,
    required this.churchRole,
    required this.initials,
    required this.createdAt,
    required this.updatedAt,
  });

  // Default placeholders
  static const String defaultTimezone = 'UTC';
  static const List<String> defaultPrayerTimes = ['06:00', '12:00', '18:00'];
  static const String defaultCountry = 'Kenya';
  
  // Display getters with fallbacks
  String get displayEmail => email ?? 'No email provided';
  String get displayTimezone => timezone.isEmpty ? defaultTimezone : timezone;
  List<String> get displayPrayerTimes => prayerTimes.isEmpty ? defaultPrayerTimes : prayerTimes;
  String get displayName => name.isEmpty ? 'User' : name;
  String get displayPhone => phone.isEmpty ? 'No phone number' : phone;
  String get displayCountry => country.isEmpty ? defaultCountry : country;
  String get displayInitials => initials.isEmpty ? displayName.substring(0, 1).toUpperCase() : initials;

  // Empty constructor for fallback scenarios
  factory User.empty() {
    final now = DateTime.now().toIso8601String();
    return User(
      id: 0,
      name: 'User',
      email: null,
      phone: 'No phone number',
      country: defaultCountry,
      timezone: defaultTimezone,
      prayerTimes: defaultPrayerTimes.toList(),
      churchRole: TypeValue.defaultChurchRole(),
      initials: 'U',
      createdAt: now,
      updatedAt: now,
    );
  }

  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) return User.empty();
    
    return User(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String? ?? '',
      country: json['country'] as String? ?? defaultCountry,
      timezone: json['timezone'] as String? ?? defaultTimezone,
      prayerTimes: (json['prayer_times'] as List<dynamic>?)
          ?.cast<String>() ?? defaultPrayerTimes,
      churchRole: json['church_role'] != null 
          ? TypeValue.fromJson(json['church_role'] as Map<String, dynamic>)
          : TypeValue.defaultChurchRole(),
      initials: json['initials'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'country': country,
      'timezone': timezone,
      'prayer_times': prayerTimes,
      'church_role': churchRole.toJson(),
      'initials': initials,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? country,
    String? timezone,
    List<String>? prayerTimes,
    TypeValue? churchRole,
    String? initials,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      timezone: timezone ?? this.timezone,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      churchRole: churchRole ?? this.churchRole,
      initials: initials ?? this.initials,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
