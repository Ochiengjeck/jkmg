class EventType {
  final String value;
  final String label;

  EventType({required this.value, required this.label});

  // Empty constructor for fallback scenarios
  factory EventType.empty() {
    return EventType(
      value: '',
      label: '',
    );
  }

  factory EventType.fromJson(Map<String, dynamic>? json) => EventType(
    value: json?['value'] ?? '',
    label: json?['label'] ?? '',
  );

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
    };
  }

  EventType copyWith({String? value, String? label}) {
    return EventType(
      value: value ?? this.value,
      label: label ?? this.label,
    );
  }
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

  // Empty constructor for fallback scenarios
  factory Event.empty() {
    return Event(
      id: '',
      title: 'Event',
      slug: 'event',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(hours: 2)),
      type: EventType.empty(),
      location: 'Location TBD',
      bannerUrl: null,
      livestreamUrl: null,
      description: 'Event details coming soon...',
      registrationCount: 0,
      isUpcoming: true,
      isActive: false,
      isPast: false,
      hasLivestream: false,
      isGoing: false,
    );
  }

  factory Event.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Event.empty();
    
    return Event(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : DateTime.now(),
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : DateTime.now(),
      type: json['type'] != null ? EventType.fromJson(json['type']) : EventType.empty(),
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'type': type.toJson(),
      'location': location,
      'banner_url': bannerUrl,
      'livestream_url': livestreamUrl,
      'description': description,
      'registration_count': registrationCount,
      'is_upcoming': isUpcoming,
      'is_active': isActive,
      'is_past': isPast,
      'has_livestream': hasLivestream,
      'is_going': isGoing,
    };
  }

  Event copyWith({
    String? id,
    String? title,
    String? slug,
    DateTime? startDate,
    DateTime? endDate,
    EventType? type,
    String? location,
    String? bannerUrl,
    String? livestreamUrl,
    String? description,
    int? registrationCount,
    bool? isUpcoming,
    bool? isActive,
    bool? isPast,
    bool? hasLivestream,
    bool? isGoing,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      type: type ?? this.type,
      location: location ?? this.location,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      livestreamUrl: livestreamUrl ?? this.livestreamUrl,
      description: description ?? this.description,
      registrationCount: registrationCount ?? this.registrationCount,
      isUpcoming: isUpcoming ?? this.isUpcoming,
      isActive: isActive ?? this.isActive,
      isPast: isPast ?? this.isPast,
      hasLivestream: hasLivestream ?? this.hasLivestream,
      isGoing: isGoing ?? this.isGoing,
    );
  }
}