import 'event.dart';

class AttendanceType {
  final String value;
  final String label;

  AttendanceType({required this.value, required this.label});

  // Empty constructor for fallback scenarios
  factory AttendanceType.empty() {
    return AttendanceType(
      value: '',
      label: '',
    );
  }

  factory AttendanceType.fromJson(Map<String, dynamic>? json) => AttendanceType(
    value: json?['value'] ?? '',
    label: json?['label'] ?? '',
  );

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
    };
  }

  AttendanceType copyWith({String? value, String? label}) {
    return AttendanceType(
      value: value ?? this.value,
      label: label ?? this.label,
    );
  }
}

class EventRegistration {
  final int id;
  final Event? event;
  final AttendanceType attendance;
  final bool volunteer;
  final DateTime registeredAt;

  EventRegistration({
    required this.id,
    this.event,
    required this.attendance,
    required this.volunteer,
    required this.registeredAt,
  });

  // Empty constructor for fallback scenarios
  factory EventRegistration.empty() {
    return EventRegistration(
      id: 0,
      event: null,
      attendance: AttendanceType.empty(),
      volunteer: false,
      registeredAt: DateTime.now(),
    );
  }

  factory EventRegistration.fromJson(Map<String, dynamic>? json) {
    if (json == null) return EventRegistration.empty();
    
    return EventRegistration(
      id: json['id'] as int? ?? 0,
      event: json['event'] != null ? Event.fromJson(json['event']) : null,
      attendance: json['attendance'] != null ? AttendanceType.fromJson(json['attendance']) : AttendanceType.empty(),
      volunteer: json['volunteer'] as bool? ?? false,
      registeredAt: json['registered_at'] != null ? DateTime.parse(json['registered_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event': event?.toJson(),
      'attendance': attendance.toJson(),
      'volunteer': volunteer,
      'registered_at': registeredAt.toIso8601String(),
    };
  }

  EventRegistration copyWith({
    int? id,
    Event? event,
    AttendanceType? attendance,
    bool? volunteer,
    DateTime? registeredAt,
  }) {
    return EventRegistration(
      id: id ?? this.id,
      event: event ?? this.event,
      attendance: attendance ?? this.attendance,
      volunteer: volunteer ?? this.volunteer,
      registeredAt: registeredAt ?? this.registeredAt,
    );
  }
}