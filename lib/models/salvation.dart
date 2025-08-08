// Salvation Model with comprehensive null safety
import 'models.dart';

class SalvationDecision {
  final int id;
  final TypeValue type;
  final String submittedAt;
  final bool audioSent;

  // Display getters with fallbacks
  String get displayType => type.value.isEmpty ? 'Salvation Decision' : type.value;
  String get displaySubmittedAt => submittedAt.isEmpty ? 'Date not recorded' : submittedAt;
  String get audioStatus => audioSent ? 'Audio sent' : 'Audio pending';
  bool get isValidDecision => id > 0 && type.value.isNotEmpty;
  String get decisionStatus => audioSent ? 'Completed' : 'Processing';
  
  SalvationDecision({
    required this.id,
    required this.type,
    required this.submittedAt,
    required this.audioSent,
  });

  // Default constructor for fallback scenarios
  factory SalvationDecision.empty() {
    return SalvationDecision(
      id: 0,
      type: TypeValue(id: 0, value: 'Salvation Decision'),
      submittedAt: DateTime.now().toIso8601String(),
      audioSent: false,
    );
  }

  factory SalvationDecision.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SalvationDecision.empty();
    
    return SalvationDecision(
      id: json['id'] as int? ?? 0,
      type: json['type'] != null 
          ? TypeValue.fromJson(json['type'] as Map<String, dynamic>) 
          : TypeValue(id: 0, value: 'Salvation Decision'),
      submittedAt: json['submitted_at'] as String? ?? DateTime.now().toIso8601String(),
      audioSent: json['audio_sent'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toJson(),
      'submitted_at': submittedAt,
      'audio_sent': audioSent,
    };
  }

  SalvationDecision copyWith({
    int? id,
    TypeValue? type,
    String? submittedAt,
    bool? audioSent,
  }) {
    return SalvationDecision(
      id: id ?? this.id,
      type: type ?? this.type,
      submittedAt: submittedAt ?? this.submittedAt,
      audioSent: audioSent ?? this.audioSent,
    );
  }
}
