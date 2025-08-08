import 'models.dart';
import 'user.dart';

// Prayer Request Model with comprehensive null safety
class PrayerRequest {
  final int id;
  final TypeValue category;
  final String startDate;
  final String endDate;
  final bool completed;
  final double daysRemaining;
  final bool isActive;
  final User user;
  final String createdAt;
  final String updatedAt;

  // Display getters with fallbacks
  String get displayCategory => category.value.isEmpty ? 'General Prayer' : category.value;
  String get displayStartDate => startDate.isEmpty ? 'Date not set' : startDate;
  String get displayEndDate => endDate.isEmpty ? 'Date not set' : endDate;
  String get displayUserName => user.displayName;
  String get statusText => completed ? 'Completed' : (isActive ? 'Active' : 'Inactive');
  int get remainingDays => daysRemaining.round();
  bool get isOverdue => daysRemaining < 0;
  bool get isAlmostDue => daysRemaining <= 1 && daysRemaining >= 0;

  PrayerRequest({
    required this.id,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.completed,
    required this.daysRemaining,
    required this.isActive,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  // Default constructor for fallback scenarios
  factory PrayerRequest.empty() {
    final now = DateTime.now();
    return PrayerRequest(
      id: 0,
      category: TypeValue.empty(),
      startDate: now.toIso8601String(),
      endDate: now.add(Duration(days: 7)).toIso8601String(),
      completed: false,
      daysRemaining: 7.0,
      isActive: true,
      user: User.empty(),
      createdAt: now.toIso8601String(),
      updatedAt: now.toIso8601String(),
    );
  }

  factory PrayerRequest.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PrayerRequest.empty();

    return PrayerRequest(
      id: json['id'] as int? ?? 0,
      category: json['category'] != null 
          ? TypeValue.fromJson(json['category'] as Map<String, dynamic>) 
          : TypeValue.empty(),
      startDate: _safeParseDateString(json['start_date']) ?? DateTime.now().toIso8601String(),
      endDate: _safeParseDateString(json['end_date']) ?? DateTime.now().add(Duration(days: 7)).toIso8601String(),
      completed: json['completed'] as bool? ?? false,
      daysRemaining: _safeParseDouble(json['days_remaining']) ?? 7.0,
      isActive: json['is_active'] as bool? ?? true,
      user: json['user'] != null 
          ? User.fromJson(json['user'] as Map<String, dynamic>) 
          : User.empty(),
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  static String _safeParseDateString(dynamic dateValue) {
    if (dateValue == null) return DateTime.now().toIso8601String();
    try {
      if (dateValue is String) {
        DateTime.parse(dateValue); // Validate format
        return dateValue;
      }
      return dateValue.toString();
    } catch (e) {
      return DateTime.now().toIso8601String();
    }
  }

  static double _safeParseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.toJson(),
      'start_date': startDate,
      'end_date': endDate,
      'completed': completed,
      'days_remaining': daysRemaining,
      'is_active': isActive,
      'user': user.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  PrayerRequest copyWith({
    int? id,
    TypeValue? category,
    String? startDate,
    String? endDate,
    bool? completed,
    double? daysRemaining,
    bool? isActive,
    User? user,
    String? createdAt,
    String? updatedAt,
  }) {
    return PrayerRequest(
      id: id ?? this.id,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      completed: completed ?? this.completed,
      daysRemaining: daysRemaining ?? this.daysRemaining,
      isActive: isActive ?? this.isActive,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Prayer Schedule Model with comprehensive null safety
class PrayerSchedule {
  final List<PrayerRequest> activePrayers;
  final List<PrayerRequest> completedPrayers;
  final List<String> prayerTimes;
  final String userTimezone;

  // Display getters
  int get totalActivePrayers => activePrayers.length;
  int get totalCompletedPrayers => completedPrayers.length;
  int get totalPrayers => totalActivePrayers + totalCompletedPrayers;
  bool get hasActivePrayers => activePrayers.isNotEmpty;
  bool get hasCompletedPrayers => completedPrayers.isNotEmpty;
  String get displayTimezone => userTimezone.isEmpty ? 'UTC' : userTimezone;
  List<String> get displayPrayerTimes => prayerTimes.isEmpty ? ['06:00', '12:00', '18:00'] : prayerTimes;

  PrayerSchedule({
    required this.activePrayers,
    required this.completedPrayers,
    required this.prayerTimes,
    required this.userTimezone,
  });

  // Default constructor for fallback scenarios
  factory PrayerSchedule.empty() {
    return PrayerSchedule(
      activePrayers: [],
      completedPrayers: [],
      prayerTimes: ['06:00', '12:00', '18:00'],
      userTimezone: 'UTC',
    );
  }

  factory PrayerSchedule.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PrayerSchedule.empty();

    return PrayerSchedule(
      activePrayers: _safeParsePrayerList(json['active_prayers']),
      completedPrayers: _safeParsePrayerList(json['completed_prayers']),
      prayerTimes: _safeParseStringList(json['prayer_times']),
      userTimezone: json['user_timezone'] as String? ?? 'UTC',
    );
  }

  static List<PrayerRequest> _safeParsePrayerList(dynamic listData) {
    if (listData == null || listData is! List) {
      return <PrayerRequest>[];
    }

    return listData
        .where((item) => item != null && item is Map<String, dynamic>)
        .map((item) => PrayerRequest.fromJson(item as Map<String, dynamic>))
        .where((prayer) => prayer.id != 0) // Filter out empty prayers
        .toList();
  }

  static List<String> _safeParseStringList(dynamic listData) {
    if (listData == null || listData is! List) {
      return ['06:00', '12:00', '18:00']; // Default prayer times
    }

    return listData
        .where((item) => item != null)
        .map((item) => item.toString())
        .where((time) => time.isNotEmpty)
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'active_prayers': activePrayers.map((p) => p.toJson()).toList(),
      'completed_prayers': completedPrayers.map((p) => p.toJson()).toList(),
      'prayer_times': prayerTimes,
      'user_timezone': userTimezone,
    };
  }
}

// Deeper Prayer Participation Model with comprehensive null safety
class DeeperPrayerParticipation {
  final int id;
  final String date;
  final int duration;
  final bool completed;
  final String completedAt;
  final String? notes;

  // Display getters
  String get displayDate => date.isEmpty ? 'Date not set' : date;
  String get displayCompletedAt => completedAt.isEmpty ? 'Not completed' : completedAt;
  String get displayNotes => notes?.isEmpty == false ? notes! : 'No notes';
  String get durationText => duration > 0 ? '${duration} minutes' : 'Duration not set';
  String get statusText => completed ? 'Completed' : 'Pending';

  DeeperPrayerParticipation({
    required this.id,
    required this.date,
    required this.duration,
    required this.completed,
    required this.completedAt,
    this.notes,
  });

  // Default constructor for fallback scenarios
  factory DeeperPrayerParticipation.empty() {
    final now = DateTime.now();
    return DeeperPrayerParticipation(
      id: 0,
      date: now.toIso8601String().split('T')[0], // Date only
      duration: 0,
      completed: false,
      completedAt: '',
      notes: null,
    );
  }

  factory DeeperPrayerParticipation.fromJson(Map<String, dynamic>? json) {
    if (json == null) return DeeperPrayerParticipation.empty();

    return DeeperPrayerParticipation(
      id: json['id'] as int? ?? 0,
      date: json['date'] as String? ?? DateTime.now().toIso8601String().split('T')[0],
      duration: json['duration'] as int? ?? 0,
      completed: json['completed'] as bool? ?? false,
      completedAt: json['completed_at'] as String? ?? '',
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'duration': duration,
      'completed': completed,
      'completed_at': completedAt,
      'notes': notes,
    };
  }

  DeeperPrayerParticipation copyWith({
    int? id,
    String? date,
    int? duration,
    bool? completed,
    String? completedAt,
    String? notes,
  }) {
    return DeeperPrayerParticipation(
      id: id ?? this.id,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
    );
  }
}

// Deeper Prayer Info Model with comprehensive null safety
class DeeperPrayerInfo {
  final DeeperPrayerParticipation? todayParticipation;
  final List<DeeperPrayerParticipation> recentParticipations;
  final int totalCompleted;
  final List<int> availableDurations;

  // Display getters
  bool get hasParticipatedToday => todayParticipation != null && todayParticipation!.completed;
  bool get canParticipateToday => todayParticipation == null || !todayParticipation!.completed;
  int get recentParticipationsCount => recentParticipations.length;
  String get todayStatus => hasParticipatedToday ? 'Completed' : 'Not completed';
  List<int> get displayDurations => availableDurations.isEmpty ? [30, 60, 90] : availableDurations;
  String get totalCompletedText => totalCompleted == 1 ? '1 session completed' : '$totalCompleted sessions completed';

  DeeperPrayerInfo({
    this.todayParticipation,
    required this.recentParticipations,
    required this.totalCompleted,
    required this.availableDurations,
  });

  // Default constructor for fallback scenarios
  factory DeeperPrayerInfo.empty() {
    return DeeperPrayerInfo(
      todayParticipation: null,
      recentParticipations: [],
      totalCompleted: 0,
      availableDurations: [30, 60, 90],
    );
  }

  factory DeeperPrayerInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return DeeperPrayerInfo.empty();

    return DeeperPrayerInfo(
      todayParticipation: json['today_participation'] != null
          ? DeeperPrayerParticipation.fromJson(json['today_participation'] as Map<String, dynamic>)
          : null,
      recentParticipations: _safeParseParticipationList(json['recent_participations']),
      totalCompleted: json['total_completed'] as int? ?? 0,
      availableDurations: _safeParseIntList(json['available_durations']),
    );
  }

  static List<DeeperPrayerParticipation> _safeParseParticipationList(dynamic listData) {
    if (listData == null || listData is! List) {
      return <DeeperPrayerParticipation>[];
    }

    return listData
        .where((item) => item != null && item is Map<String, dynamic>)
        .map((item) => DeeperPrayerParticipation.fromJson(item as Map<String, dynamic>))
        .where((participation) => participation.id != 0) // Filter out empty participations
        .toList();
  }

  static List<int> _safeParseIntList(dynamic listData) {
    if (listData == null || listData is! List) {
      return [30, 60, 90]; // Default durations in minutes
    }

    return listData
        .where((item) => item != null)
        .map((item) {
          if (item is int) return item;
          if (item is String) return int.tryParse(item) ?? 30;
          return 30;
        })
        .where((duration) => duration > 0)
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'today_participation': todayParticipation?.toJson(),
      'recent_participations': recentParticipations.map((p) => p.toJson()).toList(),
      'total_completed': totalCompleted,
      'available_durations': availableDurations,
    };
  }

  DeeperPrayerInfo copyWith({
    DeeperPrayerParticipation? todayParticipation,
    List<DeeperPrayerParticipation>? recentParticipations,
    int? totalCompleted,
    List<int>? availableDurations,
  }) {
    return DeeperPrayerInfo(
      todayParticipation: todayParticipation ?? this.todayParticipation,
      recentParticipations: recentParticipations ?? this.recentParticipations,
      totalCompleted: totalCompleted ?? this.totalCompleted,
      availableDurations: availableDurations ?? this.availableDurations,
    );
  }
}