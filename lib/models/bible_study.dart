// Bible Study Models
class BibleStudy {
  final int id;
  final String date;
  final String topic;
  final String scripture;
  final String devotional;
  final String excerpt;
  final Map<String, dynamic> discussionJson;
  final bool isToday;
  final String createdAt;
  final String updatedAt;

  BibleStudy({
    required this.id,
    required this.date,
    required this.topic,
    required this.scripture,
    required this.devotional,
    required this.excerpt,
    required this.discussionJson,
    required this.isToday,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BibleStudy.fromJson(Map<String, dynamic> json) {
    return BibleStudy(
      id: json['id'] as int,
      date: json['date'] as String,
      topic: json['topic'] as String,
      scripture: json['scripture'] as String,
      devotional: json['devotional'] as String,
      excerpt: json['excerpt'] as String,
      discussionJson: json['discussion_json'] as Map<String, dynamic>,
      isToday: json['is_today'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
