// Testimony Model
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

  factory Testimony.fromJson(Map<String, dynamic> json) {
    return Testimony(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      excerpt: json['excerpt'] as String,
      mediaPath: json['media_path'] as String?,
      hasMedia: json['has_media'] as bool,
      status: TypeValue.fromJson(json['status'] as Map<String, dynamic>),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
