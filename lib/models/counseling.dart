import 'models.dart';
import 'user.dart';

class Counselor {
  final int id;
  final String name;
  final String initials;
  final String? email; // Made nullable to handle null in API response
  final String phone;
  final String country;
  final String timezone;
  final List<String>?
  prayerTimes; // Made nullable to handle null in API response
  final TypeValue churchRole;
  final String createdAt;
  final String updatedAt;

  Counselor({
    required this.id,
    required this.name,
    required this.initials,
    this.email,
    required this.phone,
    required this.country,
    required this.timezone,
    this.prayerTimes,
    required this.churchRole,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Counselor.fromJson(Map<String, dynamic> json) {
    return Counselor(
      id: json['id'] as int,
      name: json['name'] as String,
      initials: json['initials'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String,
      country: json['country'] as String,
      timezone: json['timezone'] as String,
      prayerTimes: json['prayer_times'] != null
          ? (json['prayer_times'] as List<dynamic>).cast<String>()
          : null,
      churchRole: TypeValue.fromJson(
        json['church_role'] as Map<String, dynamic>,
      ),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

class CounselingSession {
  final int id;
  final String topic;
  final Map<String, dynamic> intakeForm;
  final String? scheduledAt;
  final TypeValue status;
  final User user;
  final Counselor? counselor;
  final String createdAt;
  final String updatedAt;

  CounselingSession({
    required this.id,
    required this.topic,
    required this.intakeForm,
    this.scheduledAt,
    required this.status,
    required this.user,
    this.counselor,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CounselingSession.fromJson(Map<String, dynamic> json) {
    return CounselingSession(
      id: json['id'] as int,
      topic: json['topic'] as String,
      intakeForm: json['intake_form'] as Map<String, dynamic>,
      scheduledAt: json['scheduled_at'] as String?,
      status: TypeValue.fromJson(json['status'] as Map<String, dynamic>),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      counselor: json['counselor'] != null
          ? Counselor.fromJson(json['counselor'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
