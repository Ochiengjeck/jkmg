// Notification Model
import 'models.dart';

class Notification {
  final int id;
  final TypeValue type;
  final String title;
  final String body;
  final String sentAt;
  final String? readAt;
  final bool isRead;
  final String createdAt;

  Notification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.sentAt,
    this.readAt,
    required this.isRead,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as int,
      type: TypeValue.fromJson(json['type'] as Map<String, dynamic>),
      title: json['title'] as String,
      body: json['body'] as String,
      sentAt: json['sent_at'] as String,
      readAt: json['read_at'] as String?,
      isRead: json['is_read'] as bool,
      createdAt: json['created_at'] as String,
    );
  }
}
