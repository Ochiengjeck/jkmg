// Resource Model
import 'models.dart';

class Resource {
  final int id;
  final TypeValue type;
  final String title;
  final String description;
  final String downloadUrl;
  final String language;
  final String createdAt;
  final String updatedAt;

  Resource({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.downloadUrl,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'] as int,
      type: TypeValue.fromJson(json['type'] as Map<String, dynamic>),
      title: json['title'] as String,
      description: json['description'] as String,
      downloadUrl: json['download_url'] as String,
      language: json['language'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
