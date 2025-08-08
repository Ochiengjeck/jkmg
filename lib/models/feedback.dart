// Feedback Models with comprehensive null safety
import 'models.dart';

class FeedbackType {
  final String value;
  final String label;
  final String description;

  // Display getters with fallbacks
  String get displayValue => value.isEmpty ? 'general' : value;
  String get displayLabel => label.isEmpty ? 'General Feedback' : label;
  String get displayDescription => description.isEmpty ? 'General feedback type' : description;

  FeedbackType({
    required this.value,
    required this.label,
    required this.description,
  });

  // Default constructor for fallback scenarios
  factory FeedbackType.empty() {
    return FeedbackType(
      value: 'general',
      label: 'General Feedback',
      description: 'General feedback type',
    );
  }

  factory FeedbackType.fromJson(Map<String, dynamic>? json) {
    if (json == null) return FeedbackType.empty();
    
    return FeedbackType(
      value: json['value'] as String? ?? 'general',
      label: json['label'] as String? ?? 'General Feedback',
      description: json['description'] as String? ?? 'General feedback type',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
      'description': description,
    };
  }

  FeedbackType copyWith({
    String? value,
    String? label,
    String? description,
  }) {
    return FeedbackType(
      value: value ?? this.value,
      label: label ?? this.label,
      description: description ?? this.description,
    );
  }
}

class Feedback {
  final int id;
  final TypeValue type;
  final String subject;
  final String message;
  final int? rating;
  final String? contactEmail;
  final TypeValue status;
  final String? adminResponse;
  final String? respondedAt;
  final bool hasResponse;
  final bool isHighPriority;
  final Map<String, dynamic>? metadata;
  final String createdAt;
  final String updatedAt;

  // Display getters with fallbacks
  String get displaySubject => subject.isEmpty ? 'Feedback' : subject;
  String get displayMessage => message.isEmpty ? 'No message provided' : message;
  String get displayType => type.value.isEmpty ? 'General' : type.value;
  String get displayStatus => status.value.isEmpty ? 'Pending' : status.value;
  String get displayContactEmail => contactEmail?.isEmpty == false ? contactEmail! : 'No email provided';
  String get displayAdminResponse => adminResponse?.isEmpty == false ? adminResponse! : 'No response yet';
  String get displayRespondedAt => respondedAt?.isEmpty == false ? respondedAt! : 'Not responded';
  int get displayRating => rating ?? 0;
  String get ratingText => rating != null ? '$rating/5 stars' : 'No rating';
  String get priorityText => isHighPriority ? 'High Priority' : 'Normal Priority';
  bool get hasValidRating => rating != null && rating! >= 1 && rating! <= 5;
  bool get hasValidEmail => contactEmail != null && contactEmail!.contains('@');
  bool get isPending => status.value.toLowerCase() == 'pending';
  bool get isResolved => status.value.toLowerCase() == 'resolved';
  bool get isInProgress => status.value.toLowerCase() == 'in_progress';

  // Time-based getters
  DateTime? get createdDateTime {
    if (createdAt.isEmpty) return null;
    try {
      return DateTime.parse(createdAt);
    } catch (e) {
      return null;
    }
  }

  DateTime? get respondedDateTime {
    if (respondedAt == null || respondedAt!.isEmpty) return null;
    try {
      return DateTime.parse(respondedAt!);
    } catch (e) {
      return null;
    }
  }

  String get timeAgo {
    final created = createdDateTime;
    if (created == null) return 'Unknown time';
    
    final now = DateTime.now();
    final difference = now.difference(created);
    
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

  Feedback({
    required this.id,
    required this.type,
    required this.subject,
    required this.message,
    this.rating,
    this.contactEmail,
    required this.status,
    this.adminResponse,
    this.respondedAt,
    required this.hasResponse,
    required this.isHighPriority,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  // Default constructor for fallback scenarios
  factory Feedback.empty() {
    final now = DateTime.now().toIso8601String();
    return Feedback(
      id: 0,
      type: TypeValue(id: 0, value: 'General'),
      subject: 'Feedback',
      message: 'No message provided',
      rating: null,
      contactEmail: null,
      status: TypeValue(id: 0, value: 'Pending'),
      adminResponse: null,
      respondedAt: null,
      hasResponse: false,
      isHighPriority: false,
      metadata: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory Feedback.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Feedback.empty();
    
    return Feedback(
      id: json['id'] as int? ?? 0,
      type: json['type'] != null 
          ? TypeValue.fromJson(json['type'] as Map<String, dynamic>) 
          : TypeValue(id: 0, value: 'General'),
      subject: json['subject'] as String? ?? 'Feedback',
      message: json['message'] as String? ?? 'No message provided',
      rating: _safeParseRating(json['rating']),
      contactEmail: json['contact_email'] as String?,
      status: json['status'] != null 
          ? TypeValue.fromJson(json['status'] as Map<String, dynamic>) 
          : TypeValue(id: 0, value: 'Pending'),
      adminResponse: json['admin_response'] as String?,
      respondedAt: json['responded_at'] as String?,
      hasResponse: json['has_response'] as bool? ?? false,
      isHighPriority: json['is_high_priority'] as bool? ?? false,
      metadata: _safeParseMetadata(json['metadata']),
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  static int? _safeParseRating(dynamic ratingValue) {
    if (ratingValue == null) return null;
    if (ratingValue is int) {
      return (ratingValue >= 1 && ratingValue <= 5) ? ratingValue : null;
    }
    if (ratingValue is String) {
      final parsed = int.tryParse(ratingValue);
      return (parsed != null && parsed >= 1 && parsed <= 5) ? parsed : null;
    }
    return null;
  }

  static Map<String, dynamic>? _safeParseMetadata(dynamic metadataValue) {
    if (metadataValue == null) return null;
    if (metadataValue is Map<String, dynamic>) return metadataValue;
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toJson(),
      'subject': subject,
      'message': message,
      'rating': rating,
      'contact_email': contactEmail,
      'status': status.toJson(),
      'admin_response': adminResponse,
      'responded_at': respondedAt,
      'has_response': hasResponse,
      'is_high_priority': isHighPriority,
      'metadata': metadata,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Feedback copyWith({
    int? id,
    TypeValue? type,
    String? subject,
    String? message,
    int? rating,
    String? contactEmail,
    TypeValue? status,
    String? adminResponse,
    String? respondedAt,
    bool? hasResponse,
    bool? isHighPriority,
    Map<String, dynamic>? metadata,
    String? createdAt,
    String? updatedAt,
  }) {
    return Feedback(
      id: id ?? this.id,
      type: type ?? this.type,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      rating: rating ?? this.rating,
      contactEmail: contactEmail ?? this.contactEmail,
      status: status ?? this.status,
      adminResponse: adminResponse ?? this.adminResponse,
      respondedAt: respondedAt ?? this.respondedAt,
      hasResponse: hasResponse ?? this.hasResponse,
      isHighPriority: isHighPriority ?? this.isHighPriority,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class FeedbackStats {
  final int totalFeedback;
  final int openFeedback;
  final int resolvedFeedback;
  final double? averageRatingGiven;
  final List<Feedback> recentFeedback;

  // Display getters with fallbacks
  String get totalFeedbackText => totalFeedback == 1 ? '1 feedback' : '$totalFeedback feedbacks';
  String get openFeedbackText => openFeedback == 1 ? '1 open' : '$openFeedback open';
  String get resolvedFeedbackText => resolvedFeedback == 1 ? '1 resolved' : '$resolvedFeedback resolved';
  String get averageRatingText => averageRatingGiven != null 
      ? '${averageRatingGiven!.toStringAsFixed(1)}/5.0 stars' 
      : 'No ratings yet';
  double get resolutionRate => totalFeedback > 0 ? (resolvedFeedback / totalFeedback) * 100 : 0.0;
  String get resolutionRateText => '${resolutionRate.toStringAsFixed(1)}%';
  bool get hasRecentFeedback => recentFeedback.isNotEmpty;
  int get recentFeedbackCount => recentFeedback.length;

  FeedbackStats({
    required this.totalFeedback,
    required this.openFeedback,
    required this.resolvedFeedback,
    this.averageRatingGiven,
    required this.recentFeedback,
  });

  // Default constructor for fallback scenarios
  factory FeedbackStats.empty() {
    return FeedbackStats(
      totalFeedback: 0,
      openFeedback: 0,
      resolvedFeedback: 0,
      averageRatingGiven: null,
      recentFeedback: [],
    );
  }

  factory FeedbackStats.fromJson(Map<String, dynamic>? json) {
    if (json == null) return FeedbackStats.empty();
    
    return FeedbackStats(
      totalFeedback: json['total_feedback'] as int? ?? 0,
      openFeedback: json['open_feedback'] as int? ?? 0,
      resolvedFeedback: json['resolved_feedback'] as int? ?? 0,
      averageRatingGiven: _safeParseDouble(json['average_rating_given']),
      recentFeedback: _safeParseFeedbackList(json['recent_feedback']),
    );
  }

  static double? _safeParseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static List<Feedback> _safeParseFeedbackList(dynamic listData) {
    if (listData == null || listData is! List) {
      return <Feedback>[];
    }

    return listData
        .where((item) => item != null && item is Map<String, dynamic>)
        .map((item) => Feedback.fromJson(item as Map<String, dynamic>))
        .where((feedback) => feedback.id != 0) // Filter out empty feedbacks
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'total_feedback': totalFeedback,
      'open_feedback': openFeedback,
      'resolved_feedback': resolvedFeedback,
      'average_rating_given': averageRatingGiven,
      'recent_feedback': recentFeedback.map((f) => f.toJson()).toList(),
    };
  }

  FeedbackStats copyWith({
    int? totalFeedback,
    int? openFeedback,
    int? resolvedFeedback,
    double? averageRatingGiven,
    List<Feedback>? recentFeedback,
  }) {
    return FeedbackStats(
      totalFeedback: totalFeedback ?? this.totalFeedback,
      openFeedback: openFeedback ?? this.openFeedback,
      resolvedFeedback: resolvedFeedback ?? this.resolvedFeedback,
      averageRatingGiven: averageRatingGiven ?? this.averageRatingGiven,
      recentFeedback: recentFeedback ?? this.recentFeedback,
    );
  }
}