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

  // Display getters with fallbacks
  String get displayTitle => title.isEmpty ? 'Event' : title;
  String get displayLocation => location.isEmpty ? 'Location TBD' : location;
  String get displayDescription => description.isEmpty ? 'No description available' : description;
  String get displayBannerUrl => bannerUrl ?? '';
  String get displayLivestreamUrl => livestreamUrl ?? '';
  bool get hasValidBanner => bannerUrl != null && bannerUrl!.isNotEmpty;
  bool get hasValidLivestream => livestreamUrl != null && livestreamUrl!.isNotEmpty;

  // Default constructor for fallback scenarios
  factory Event.empty() {
    return Event(
      id: '0',
      title: 'Event',
      slug: 'event',
      startDate: DateTime.now().toIso8601String(),
      endDate: DateTime.now().add(Duration(hours: 2)).toIso8601String(),
      type: TypeValue.empty(),
      location: 'Location TBD',
      bannerUrl: null,
      livestreamUrl: null,
      description: 'Event details coming soon...',
      registrationCount: 0,
      volunteerCount: 0,
      isUpcoming: true,
      isActive: false,
      isPast: false,
      hasLivestream: false,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
  }

  factory Event.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Event.empty();
    
    return Event(
      id: json['id']?.toString() ?? '0',
      title: json['title'] as String? ?? 'Event',
      slug: json['slug'] as String? ?? 'event',
      startDate: _safeParseDateString(json['start_date']) ?? DateTime.now().toIso8601String(),
      endDate: _safeParseDateString(json['end_date']) ?? DateTime.now().add(Duration(hours: 2)).toIso8601String(),
      type: json['type'] != null ? TypeValue.fromJson(json['type'] as Map<String, dynamic>) : TypeValue.empty(),
      location: json['location'] as String? ?? 'Location TBD',
      bannerUrl: json['banner_url'] as String?,
      livestreamUrl: json['livestream_url'] as String?,
      description: json['description'] as String? ?? 'Event details coming soon...',
      registrationCount: json['registration_count'] as int? ?? 0,
      volunteerCount: json['volunteer_count'] as int? ?? 0,
      isUpcoming: json['is_upcoming'] as bool? ?? true,
      isActive: json['is_active'] as bool? ?? false,
      isPast: json['is_past'] as bool? ?? false,
      hasLivestream: json['has_livestream'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  static String? _safeParseDateString(dynamic dateValue) {
    if (dateValue == null) return null;
    try {
      if (dateValue is String) {
        DateTime.parse(dateValue); // Validate format
        return dateValue;
      }
      return dateValue.toString();
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'start_date': startDate,
      'end_date': endDate,
      'type': type.toJson(),
      'location': location,
      'banner_url': bannerUrl,
      'livestream_url': livestreamUrl,
      'description': description,
      'registration_count': registrationCount,
      'volunteer_count': volunteerCount,
      'is_upcoming': isUpcoming,
      'is_active': isActive,
      'is_past': isPast,
      'has_livestream': hasLivestream,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

