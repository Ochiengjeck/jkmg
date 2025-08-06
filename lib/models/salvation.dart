// Salvation Model
import 'models.dart';

class SalvationDecision {
  final int id;
  final TypeValue type;
  final String submittedAt;
  final bool audioSent;

  SalvationDecision({
    required this.id,
    required this.type,
    required this.submittedAt,
    required this.audioSent,
  });

  factory SalvationDecision.fromJson(Map<String, dynamic> json) {
    return SalvationDecision(
      id: json['id'] as int,
      type: TypeValue.fromJson(json['type'] as Map<String, dynamic>),
      submittedAt: json['submitted_at'] as String,
      audioSent: json['audio_sent'] as bool,
    );
  }
}
