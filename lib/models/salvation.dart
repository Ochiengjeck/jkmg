// Salvation Model with comprehensive null safety
import 'models.dart';

// Salvation Prayer Model for the new API response
class SalvationPrayer {
  final int id;
  final String title;
  final String message;
  final String audioPath;

  SalvationPrayer({
    required this.id,
    required this.title,
    required this.message,
    required this.audioPath,
  });

  factory SalvationPrayer.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SalvationPrayer.empty();
    
    return SalvationPrayer(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Prayer',
      message: json['message'] as String? ?? '',
      audioPath: json['audio_path'] as String? ?? '',
    );
  }

  factory SalvationPrayer.empty() {
    return SalvationPrayer(
      id: 0,
      title: 'Prayer',
      message: '',
      audioPath: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'audio_path': audioPath,
    };
  }
}

// Updated Salvation Decision Response Model
class SalvationDecisionResponse {
  final int id;
  final TypeValue type;
  final int age;
  final String gender;
  final String submittedAt;
  final SalvationPrayer? prayer;

  SalvationDecisionResponse({
    required this.id,
    required this.type,
    required this.age,
    required this.gender,
    required this.submittedAt,
    this.prayer,
  });

  factory SalvationDecisionResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SalvationDecisionResponse.empty();
    
    return SalvationDecisionResponse(
      id: json['id'] as int? ?? 0,
      type: json['type'] != null 
          ? TypeValue.fromJson(json['type'] as Map<String, dynamic>) 
          : TypeValue(id: 0, value: 'salvation'),
      age: json['age'] as int? ?? 0,
      gender: json['gender'] as String? ?? 'male',
      submittedAt: json['submitted_at'] as String? ?? DateTime.now().toIso8601String(),
      prayer: json['prayer'] != null 
          ? SalvationPrayer.fromJson(json['prayer'] as Map<String, dynamic>)
          : null,
    );
  }

  factory SalvationDecisionResponse.empty() {
    return SalvationDecisionResponse(
      id: 0,
      type: TypeValue(id: 0, value: 'salvation'),
      age: 0,
      gender: 'male',
      submittedAt: DateTime.now().toIso8601String(),
      prayer: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toJson(),
      'age': age,
      'gender': gender,
      'submitted_at': submittedAt,
      'prayer': prayer?.toJson(),
    };
  }
}

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
