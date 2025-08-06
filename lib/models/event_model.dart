class EventType {
  final String value;
  final String label;

  EventType({required this.value, required this.label});

  factory EventType.fromJson(Map<String, dynamic>? json) => EventType(
    value: json?['value'] ?? '',
    label: json?['label'] ?? '',
  );
}

class Event {
  final String id;
  final String title;
  final String slug;
  final DateTime startDate;
  final DateTime endDate;
  final EventType type;
  final String location;
  final String? bannerUrl;
  final String? livestreamUrl;
  final String description;
  final int registrationCount;
  final bool isUpcoming;
  final bool isActive;
  final bool isPast;
  final bool hasLivestream;
  final bool isGoing;

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
    required this.isUpcoming,
    required this.isActive,
    required this.isPast,
    required this.hasLivestream,
    required this.isGoing,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json['id']?.toString() ?? '',
    title: json['title'] ?? '',
    slug: json['slug'] ?? '',
    startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : DateTime.now(),
    endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : DateTime.now(),
    type: EventType.fromJson(json['type']),
    location: json['location'] ?? '',
    bannerUrl: json['banner_url'],
    livestreamUrl: json['livestream_url'],
    description: json['description'] ?? '',
    registrationCount: json['registration_count'] ?? 0,
    isUpcoming: json['is_upcoming'] ?? false,
    isActive: json['is_active'] ?? false,
    isPast: json['is_past'] ?? false,
    hasLivestream: json['has_livestream'] ?? false,
    isGoing: json['is_going'] ?? false,
  );
}