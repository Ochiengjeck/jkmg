// Counseling Models with comprehensive null safety
import 'models.dart';
import 'user.dart';

class Counselor {
  final int id;
  final String name;
  final String initials;
  final String? email;
  final String phone;
  final String country;
  final String timezone;
  final List<String>? prayerTimes;
  final TypeValue churchRole;
  final String createdAt;
  final String updatedAt;

  // Display getters with fallbacks
  String get displayName => name.isEmpty ? 'Counselor' : name;
  String get displayInitials => initials.isEmpty ? 'N/A' : initials;
  String get displayEmail => email?.isEmpty == false ? email! : 'No email provided';
  String get displayPhone => phone.isEmpty ? 'No phone provided' : phone;
  String get displayCountry => country.isEmpty ? 'Unknown' : country;
  String get displayTimezone => timezone.isEmpty ? 'UTC' : timezone;
  String get displayChurchRole => churchRole.value.isEmpty ? 'Counselor' : churchRole.value;
  List<String> get displayPrayerTimes => prayerTimes ?? ['06:00', '12:00', '18:00'];
  bool get hasEmail => email != null && email!.isNotEmpty && email!.contains('@');
  bool get hasPrayerTimes => prayerTimes != null && prayerTimes!.isNotEmpty;
  String get contactInfo => hasEmail ? displayEmail : displayPhone;

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

  // Default constructor for fallback scenarios
  factory Counselor.empty() {
    final now = DateTime.now().toIso8601String();
    return Counselor(
      id: 0,
      name: 'Counselor',
      initials: 'N/A',
      email: null,
      phone: 'No phone provided',
      country: 'Unknown',
      timezone: 'UTC',
      prayerTimes: null,
      churchRole: TypeValue(id: 0, value: 'Counselor'),
      createdAt: now,
      updatedAt: now,
    );
  }

  factory Counselor.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Counselor.empty();
    
    return Counselor(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Counselor',
      initials: json['initials'] as String? ?? 'N/A',
      email: json['email'] as String?,
      phone: json['phone'] as String? ?? 'No phone provided',
      country: json['country'] as String? ?? 'Unknown',
      timezone: json['timezone'] as String? ?? 'UTC',
      prayerTimes: _safeParsePrayerTimes(json['prayer_times']),
      churchRole: json['church_role'] != null
          ? TypeValue.fromJson(json['church_role'] as Map<String, dynamic>)
          : TypeValue(id: 0, value: 'Counselor'),
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  static List<String>? _safeParsePrayerTimes(dynamic prayerTimesData) {
    if (prayerTimesData == null) return null;
    if (prayerTimesData is List) {
      return prayerTimesData
          .where((item) => item != null)
          .map((item) => item.toString())
          .where((time) => time.isNotEmpty)
          .toList();
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'initials': initials,
      'email': email,
      'phone': phone,
      'country': country,
      'timezone': timezone,
      'prayer_times': prayerTimes,
      'church_role': churchRole.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Counselor copyWith({
    int? id,
    String? name,
    String? initials,
    String? email,
    String? phone,
    String? country,
    String? timezone,
    List<String>? prayerTimes,
    TypeValue? churchRole,
    String? createdAt,
    String? updatedAt,
  }) {
    return Counselor(
      id: id ?? this.id,
      name: name ?? this.name,
      initials: initials ?? this.initials,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      timezone: timezone ?? this.timezone,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      churchRole: churchRole ?? this.churchRole,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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

  // Display getters with fallbacks
  String get displayTopic => topic.isEmpty ? 'Counseling Session' : topic;
  String get displayStatus => status.value.isEmpty ? 'Pending' : status.value;
  String get displayScheduledAt => scheduledAt?.isEmpty == false ? scheduledAt! : 'Not scheduled';
  String get displayUserName => user.displayName;
  String get displayCounselorName => counselor?.displayName ?? 'Not assigned';
  bool get hasScheduledTime => scheduledAt != null && scheduledAt!.isNotEmpty;
  bool get hasCounselor => counselor != null;
  bool get hasIntakeForm => intakeForm.isNotEmpty;
  bool get isPending => status.value.toLowerCase() == 'pending';
  bool get isScheduled => status.value.toLowerCase() == 'scheduled';
  bool get isCompleted => status.value.toLowerCase() == 'completed';
  bool get isCancelled => status.value.toLowerCase() == 'cancelled';

  // Time-based getters
  DateTime? get scheduledDateTime {
    if (scheduledAt == null || scheduledAt!.isEmpty) return null;
    try {
      return DateTime.parse(scheduledAt!);
    } catch (e) {
      return null;
    }
  }

  DateTime? get createdDateTime {
    if (createdAt.isEmpty) return null;
    try {
      return DateTime.parse(createdAt);
    } catch (e) {
      return null;
    }
  }

  String get timeUntilSession {
    final scheduled = scheduledDateTime;
    if (scheduled == null) return 'Not scheduled';
    
    final now = DateTime.now();
    if (scheduled.isBefore(now)) return 'Session passed';
    
    final difference = scheduled.difference(now);
    
    if (difference.inDays > 0) {
      return 'In ${difference.inDays} day${difference.inDays == 1 ? '' : 's'}';
    } else if (difference.inHours > 0) {
      return 'In ${difference.inHours} hour${difference.inHours == 1 ? '' : 's'}';
    } else if (difference.inMinutes > 0) {
      return 'In ${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'}';
    } else {
      return 'Starting soon';
    }
  }

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

  // Default constructor for fallback scenarios
  factory CounselingSession.empty() {
    final now = DateTime.now().toIso8601String();
    return CounselingSession(
      id: 0,
      topic: 'Counseling Session',
      intakeForm: {},
      scheduledAt: null,
      status: TypeValue(id: 0, value: 'Pending'),
      user: User.empty(),
      counselor: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory CounselingSession.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CounselingSession.empty();
    
    return CounselingSession(
      id: json['id'] as int? ?? 0,
      topic: json['topic'] as String? ?? 'Counseling Session',
      intakeForm: _safeParseIntakeForm(json['intake_form']),
      scheduledAt: json['scheduled_at'] as String?,
      status: json['status'] != null 
          ? TypeValue.fromJson(json['status'] as Map<String, dynamic>) 
          : TypeValue(id: 0, value: 'Pending'),
      user: json['user'] != null 
          ? User.fromJson(json['user'] as Map<String, dynamic>) 
          : User.empty(),
      counselor: json['counselor'] != null
          ? Counselor.fromJson(json['counselor'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  static Map<String, dynamic> _safeParseIntakeForm(dynamic intakeFormData) {
    if (intakeFormData is Map<String, dynamic>) {
      return intakeFormData;
    }
    return {}; // Return empty map as fallback
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic': topic,
      'intake_form': intakeForm,
      'scheduled_at': scheduledAt,
      'status': status.toJson(),
      'user': user.toJson(),
      'counselor': counselor?.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  CounselingSession copyWith({
    int? id,
    String? topic,
    Map<String, dynamic>? intakeForm,
    String? scheduledAt,
    TypeValue? status,
    User? user,
    Counselor? counselor,
    String? createdAt,
    String? updatedAt,
  }) {
    return CounselingSession(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      intakeForm: intakeForm ?? this.intakeForm,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      user: user ?? this.user,
      counselor: counselor ?? this.counselor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Schedule session
  CounselingSession schedule(String scheduledTime, Counselor assignedCounselor) {
    return copyWith(
      scheduledAt: scheduledTime,
      counselor: assignedCounselor,
      status: TypeValue(id: 1, value: 'Scheduled'),
    );
  }

  // Complete session
  CounselingSession complete() {
    return copyWith(
      status: TypeValue(id: 2, value: 'Completed'),
    );
  }

  // Cancel session
  CounselingSession cancel() {
    return copyWith(
      status: TypeValue(id: 3, value: 'Cancelled'),
    );
  }
}