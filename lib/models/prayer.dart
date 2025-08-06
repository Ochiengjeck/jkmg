// TODO Implement this library.
// Prayer System Models
import 'models.dart';

class PrayerRequest {
  final int id;
  final TypeValue category;
  final String startDate;
  final String endDate;
  final bool completed;
  final int daysRemaining;
  final bool isActive;
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
      daysRemaining: json['days_remaining'] as int,
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

class PrayerSchedule {
  final List<PrayerRequest> activePrayers;
  final List<PrayerRequest> completedPrayers;
  final List<String> prayerTimes;
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
      prayerTimes: (json['prayer_times'] as List).cast<String>(),
      userTimezone: json['user_timezone'] as String,
    );
  }
}

class DeeperPrayerParticipation {
  final int id;
  final String date;
  final int duration;
  final bool completed;
  final String? completedAt;

  DeeperPrayerParticipation({
    required this.id,
    required this.date,
    required this.duration,
    required this.completed,
    this.completedAt,
  });

  factory DeeperPrayerParticipation.fromJson(Map<String, dynamic> json) {
    return DeeperPrayerParticipation(
      id: json['id'] as int,
      date: json['date'] as String,
      duration: json['duration'] as int,
      completed: json['completed'] as bool,
      completedAt: json['completed_at'] as String?,
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
}
