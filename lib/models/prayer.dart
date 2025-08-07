import 'models.dart';
import 'user.dart';

class PrayerRequest {
  final int id;
  final TypeValue category;
  final String startDate;
  final String endDate;
  final bool completed;
  final double daysRemaining; // Changed to double to match the API response
  final bool isActive;
  final User user;
  final String createdAt;
  final String updatedAt;

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

  factory PrayerRequest.fromJson(Map<String, dynamic> json) {
    return PrayerRequest(
      id: json['id'] as int,
      category: TypeValue.fromJson(json['category'] as Map<String, dynamic>),
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      completed: json['completed'] as bool,
      daysRemaining: json['days_remaining'] as double,
      isActive: json['is_active'] as bool,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

class PrayerSchedule {
  final List<PrayerRequest> activePrayers;
  final List<PrayerRequest> completedPrayers;
  final List<dynamic> prayerTimes;
  final String userTimezone;

  PrayerSchedule({
    required this.activePrayers,
    required this.completedPrayers,
    required this.prayerTimes,
    required this.userTimezone,
  });

  factory PrayerSchedule.fromJson(Map<String, dynamic> json) {
    return PrayerSchedule(
      activePrayers: (json['active_prayers'] as List)
          .map((item) => PrayerRequest.fromJson(item))
          .toList(),
      completedPrayers: (json['completed_prayers'] as List)
          .map((item) => PrayerRequest.fromJson(item))
          .toList(),
      prayerTimes: (json['prayer_times'] as List),
      userTimezone: json['user_timezone'] as String,
    );
  }
}

class DeeperPrayerParticipation {
  final int id;
  final String date;
  final int duration;
  final bool completed;
  final String completedAt;
  final String? notes; // Add notes field

  DeeperPrayerParticipation({
    required this.id,
    required this.date,
    required this.duration,
    required this.completed,
    required this.completedAt,
    this.notes,
  });

  factory DeeperPrayerParticipation.fromJson(Map<String, dynamic> json) {
    return DeeperPrayerParticipation(
      id: json['id'],
      date: json['date'],
      duration: json['duration'],
      completed: json['completed'],
      completedAt: json['completed_at'],
      notes: json['notes'],
    );
  }
}

class DeeperPrayerInfo {
  final DeeperPrayerParticipation? todayParticipation;
  final List<DeeperPrayerParticipation> recentParticipations;
  final int totalCompleted;
  final List<int> availableDurations;

  DeeperPrayerInfo({
    this.todayParticipation,
    required this.recentParticipations,
    required this.totalCompleted,
    required this.availableDurations,
  });

  factory DeeperPrayerInfo.fromJson(Map<String, dynamic> json) {
    return DeeperPrayerInfo(
      todayParticipation: json['today_participation'] != null
          ? DeeperPrayerParticipation.fromJson(
              json['today_participation'] as Map<String, dynamic>,
            )
          : null,
      recentParticipations: (json['recent_participations'] as List)
          .map((item) => DeeperPrayerParticipation.fromJson(item))
          .toList(),
      totalCompleted: json['total_completed'] as int,
      availableDurations: (json['available_durations'] as List).cast<int>(),
    );
  }

  get length => null;
}
