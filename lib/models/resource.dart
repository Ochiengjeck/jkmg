// Resource Model with comprehensive null safety
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

  // Display getters with fallbacks
  String get displayTitle => title.isEmpty ? 'Resource' : title;
  String get displayDescription => description.isEmpty ? 'No description available' : description;
  String get displayLanguage => language.isEmpty ? 'English' : language;
  String get displayType => type.value.isEmpty ? 'Resource' : type.value;
  bool get hasValidDownloadUrl => downloadUrl.isNotEmpty && Uri.tryParse(downloadUrl) != null;
  String get fileExtension {
    if (downloadUrl.isEmpty) return '';
    try {
      final uri = Uri.parse(downloadUrl);
      final path = uri.path;
      final lastDot = path.lastIndexOf('.');
      return lastDot != -1 ? path.substring(lastDot + 1).toLowerCase() : '';
    } catch (e) {
      return '';
    }
  }

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

  // Default constructor for fallback scenarios
  factory Resource.empty() {
    final now = DateTime.now().toIso8601String();
    return Resource(
      id: 0,
      type: TypeValue.empty(),
      title: 'Resource',
      description: 'No description available',
      downloadUrl: '',
      language: 'English',
      createdAt: now,
      updatedAt: now,
    );
  }

  factory Resource.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Resource.empty();
    
    return Resource(
      id: json['id'] as int? ?? 0,
      type: json['type'] != null 
          ? TypeValue.fromJson(json['type'] as Map<String, dynamic>) 
          : TypeValue.empty(),
      title: json['title'] as String? ?? 'Resource',
      description: json['description'] as String? ?? 'No description available',
      downloadUrl: _safeParseUrl(json['download_url']) ?? '',
      language: json['language'] as String? ?? 'English',
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  static String? _safeParseUrl(dynamic urlValue) {
    if (urlValue == null) return null;
    final urlString = urlValue.toString();
    try {
      Uri.parse(urlString); // Validate URL format
      return urlString;
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toJson(),
      'title': title,
      'description': description,
      'download_url': downloadUrl,
      'language': language,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Resource copyWith({
    int? id,
    TypeValue? type,
    String? title,
    String? description,
    String? downloadUrl,
    String? language,
    String? createdAt,
    String? updatedAt,
  }) {
    return Resource(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
