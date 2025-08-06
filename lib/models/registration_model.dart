import 'event_model.dart';

class AttendanceType {
  final String value;
  final String label;

  AttendanceType({required this.value, required this.label});

  factory AttendanceType.fromJson(Map<String, dynamic>? json) => AttendanceType(
    value: json?['value'] ?? '',
    label: json?['label'] ?? '',
  );
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

  factory EventRegistration.fromJson(Map<String, dynamic> json) {
    return EventRegistration(
      id: json['id']??0,
      event: json['event'] != null ? Event.fromJson(json['event']) : null,
      attendance: AttendanceType.fromJson(json['attendance']),
      volunteer: json['volunteer'] ?? false,
      registeredAt: json['registered_at'] != null ? DateTime.parse(json['registered_at']) : DateTime.now(),
    );
  }
}
