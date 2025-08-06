// Feedback Models
import 'models.dart';

class FeedbackType {
  final String value;
  final String label;
  final String description;

  FeedbackType({
    required this.value,
    required this.label,
    required this.description,
  });

  factory FeedbackType.fromJson(Map<String, dynamic> json) {
    return FeedbackType(
      value: json['value'] as String,
      label: json['label'] as String,
      description: json['description'] as String,
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

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['id'] as int,
      type: TypeValue.fromJson(json['type'] as Map<String, dynamic>),
      subject: json['subject'] as String,
      message: json['message'] as String,
      rating: json['rating'] as int?,
      contactEmail: json['contact_email'] as String?,
      status: TypeValue.fromJson(json['status'] as Map<String, dynamic>),
      adminResponse: json['admin_response'] as String?,
      respondedAt: json['responded_at'] as String?,
      hasResponse: json['has_response'] as bool,
      isHighPriority: json['is_high_priority'] as bool,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

class FeedbackStats {
  final int totalFeedback;
  final int openFeedback;
  final int resolvedFeedback;
  final double? averageRatingGiven;
  final List<Feedback> recentFeedback;

  FeedbackStats({
    required this.totalFeedback,
    required this.openFeedback,
    required this.resolvedFeedback,
    this.averageRatingGiven,
    required this.recentFeedback,
  });

  factory FeedbackStats.fromJson(Map<String, dynamic> json) {
    return FeedbackStats(
      totalFeedback: json['total_feedback'] as int,
      openFeedback: json['open_feedback'] as int,
      resolvedFeedback: json['resolved_feedback'] as int,
      averageRatingGiven: (json['average_rating_given'] as num?)?.toDouble(),
      recentFeedback: (json['recent_feedback'] as List)
          .map((item) => Feedback.fromJson(item))
          .toList(),
    );
  }
}
