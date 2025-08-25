// Notification Model with comprehensive null safety
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
  final Map<String, dynamic>? data;

  // Display getters with fallbacks
  String get displayTitle => title.isEmpty ? 'Notification' : title;
  String get displayBody => body.isEmpty ? 'No content available' : body;
  String get displayType => type.value.isEmpty ? 'General' : type.value;
  String get displaySentAt => sentAt.isEmpty ? 'Date not available' : sentAt;
  String get displayReadAt => readAt?.isEmpty == false ? readAt! : 'Not read yet';
  String get readStatus => isRead ? 'Read' : 'Unread';
  bool get hasBeenRead => isRead && readAt != null && readAt!.isNotEmpty;
  
  // Time-based getters
  DateTime? get sentDateTime {
    if (sentAt.isEmpty) return null;
    try {
      return DateTime.parse(sentAt);
    } catch (e) {
      return null;
    }
  }
  
  DateTime? get readDateTime {
    if (readAt == null || readAt!.isEmpty) return null;
    try {
      return DateTime.parse(readAt!);
    } catch (e) {
      return null;
    }
  }
  
  String get timeAgo {
    final sent = sentDateTime;
    if (sent == null) return 'Unknown time';
    
    final now = DateTime.now();
    final difference = now.difference(sent);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  Notification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.sentAt,
    this.readAt,
    required this.isRead,
    required this.createdAt,
    this.data,
  });

  // Default constructor for fallback scenarios
  factory Notification.empty() {
    final now = DateTime.now().toIso8601String();
    return Notification(
      id: 0,
      type: TypeValue(id: 0, value: 'General'),
      title: 'Notification',
      body: 'No content available',
      sentAt: now,
      readAt: null,
      isRead: false,
      createdAt: now,
      data: null,
    );
  }

  factory Notification.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Notification.empty();
    
    return Notification(
      id: json['id'] as int? ?? 0,
      type: json['type'] != null 
          ? TypeValue.fromJson(json['type'] as Map<String, dynamic>) 
          : TypeValue(id: 0, value: 'General'),
      title: json['title'] as String? ?? 'Notification',
      body: json['body'] as String? ?? 'No content available',
      sentAt: json['sent_at'] as String? ?? DateTime.now().toIso8601String(),
      readAt: json['read_at'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toJson(),
      'title': title,
      'body': body,
      'sent_at': sentAt,
      'read_at': readAt,
      'is_read': isRead,
      'created_at': createdAt,
      'data': data,
    };
  }

  Notification copyWith({
    int? id,
    TypeValue? type,
    String? title,
    String? body,
    String? sentAt,
    String? readAt,
    bool? isRead,
    String? createdAt,
    Map<String, dynamic>? data,
  }) {
    return Notification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      sentAt: sentAt ?? this.sentAt,
      readAt: readAt ?? this.readAt,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
    );
  }

  // Mark as read
  Notification markAsRead() {
    return copyWith(
      isRead: true,
      readAt: DateTime.now().toIso8601String(),
    );
  }
}
