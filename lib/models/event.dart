// Event Models
import 'models.dart';

class Event {
  final String id;
  final String title;
  final String slug;
  final String startDate;
  final String endDate;
  final TypeValue type;
  final String location;
  final String? bannerUrl;
  final String? livestreamUrl;
  final String description;
  final int registrationCount;
  final int volunteerCount;
  final bool isUpcoming;
  final bool isActive;
  final bool isPast;
  final bool hasLivestream;
  final String createdAt;
  final String updatedAt;

  Event({
    required this.id,
    required this.title,
    required this.slug,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.location,
    this.bannerUrl,
    this.livestreamUrl,
    required this.description,
    required this.registrationCount,
    required this.volunteerCount,
    required this.isUpcoming,
    required this.isActive,
    required this.isPast,
    required this.hasLivestream,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      type: TypeValue.fromJson(json['type'] as Map<String, dynamic>),
      location: json['location'] as String,
      bannerUrl: json['banner_url'] as String?,
      livestreamUrl: json['livestream_url'] as String?,
      description: json['description'] as String,
      registrationCount: json['registration_count'] as int,
      volunteerCount: json['volunteer_count'] as int,
      isUpcoming: json['is_upcoming'] as bool,
      isActive: json['is_active'] as bool,
      isPast: json['is_past'] as bool,
      hasLivestream: json['has_livestream'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

class EventRegistration {
  final int id;
  final Event event;
  final TypeValue attendance;
  final bool volunteer;
  final String registeredAt;

  EventRegistration({
    required this.id,
    required this.event,
    required this.attendance,
    required this.volunteer,
    required this.registeredAt,
  });

  factory EventRegistration.fromJson(Map<String, dynamic> json) {
    return EventRegistration(
      id: json['id'] as int,
      event: Event.fromJson(json['event'] as Map<String, dynamic>),
      attendance: TypeValue.fromJson(
        json['attendance'] as Map<String, dynamic>,
      ),
      volunteer: json['volunteer'] as bool,
      registeredAt: json['registered_at'] as String,
    );
  }
}
