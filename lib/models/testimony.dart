// Testimony Model with comprehensive null safety
import 'models.dart';
import 'user.dart';

class Testimony {
  final int id;
  final String title;
  final String body;
  final String excerpt;
  final String? mediaPath;
  final bool hasMedia;
  final TypeValue status;
  final User user;
  final String createdAt;
  final String updatedAt;

  // Display getters with fallbacks
  String get displayTitle => title.isEmpty ? 'Testimony' : title;
  String get displayBody => body.isEmpty ? 'Testimony content coming soon...' : body;
  String get displayExcerpt => excerpt.isEmpty ? 'No excerpt available' : excerpt;
  String get displayMediaPath => mediaPath ?? '';
  String get displayUserName => user.displayName;
  String get displayStatus => status.value.isEmpty ? 'Pending' : status.value;
  bool get hasValidMedia => mediaPath != null && mediaPath!.isNotEmpty;
  bool get isApproved => status.value.toLowerCase() == 'approved';
  bool get isPending => status.value.toLowerCase() == 'pending';
  bool get isRejected => status.value.toLowerCase() == 'rejected';
  
  Testimony({
    required this.id,
    required this.title,
    required this.body,
    required this.excerpt,
    this.mediaPath,
    required this.hasMedia,
    required this.status,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  // Default constructor for fallback scenarios
  factory Testimony.empty() {
    final now = DateTime.now().toIso8601String();
    return Testimony(
      id: 0,
      title: 'Testimony',
      body: 'Testimony content coming soon...',
      excerpt: 'No excerpt available',
      mediaPath: null,
      hasMedia: false,
      status: TypeValue(id: 0, value: 'Pending'),
      user: User.empty(),
      createdAt: now,
      updatedAt: now,
    );
  }

  factory Testimony.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Testimony.empty();
    
    return Testimony(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Testimony',
      body: json['body'] as String? ?? 'Testimony content coming soon...',
      excerpt: json['excerpt'] as String? ?? 'No excerpt available',
      mediaPath: json['media_path'] as String?,
      hasMedia: json['has_media'] as bool? ?? false,
      status: json['status'] != null 
          ? TypeValue.fromJson(json['status'] as Map<String, dynamic>) 
          : TypeValue(id: 0, value: 'Pending'),
      user: json['user'] != null 
          ? User.fromJson(json['user'] as Map<String, dynamic>) 
          : User.empty(),
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'excerpt': excerpt,
      'media_path': mediaPath,
      'has_media': hasMedia,
      'status': status.toJson(),
      'user': user.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Testimony copyWith({
    int? id,
    String? title,
    String? body,
    String? excerpt,
    String? mediaPath,
    bool? hasMedia,
    TypeValue? status,
    User? user,
    String? createdAt,
    String? updatedAt,
  }) {
    return Testimony(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      excerpt: excerpt ?? this.excerpt,
      mediaPath: mediaPath ?? this.mediaPath,
      hasMedia: hasMedia ?? this.hasMedia,
      status: status ?? this.status,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
