// Bible Study Models with comprehensive null safety
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

  // Display getters with fallbacks
  String get displayTopic => topic.isEmpty ? 'Bible Study' : topic;
  String get displayScripture => scripture.isEmpty ? 'Scripture TBD' : scripture;
  String get displayExcerpt => excerpt.isEmpty ? 'No excerpt available' : excerpt;
  String get displayDate => date.isEmpty ? 'Date TBD' : date;

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

  // Default constructor for fallback scenarios
  factory BibleStudy.empty() {
    return BibleStudy(
      id: 0,
      date: '',
      topic: 'Bible Study',
      scripture: 'Scripture TBD',
      devotional: 'Study content coming soon...',
      excerpt: 'No excerpt available',
      discussionJson: {'questions': [], 'reflection': ''},
      isToday: false,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
  }

  factory BibleStudy.fromJson(Map<String, dynamic>? json) {
    if (json == null) return BibleStudy.empty();
    
    return BibleStudy(
      id: json['id'] as int? ?? 0,
      date: json['date'] as String? ?? '',
      topic: json['topic'] as String? ?? 'Bible Study',
      scripture: json['scripture'] as String? ?? 'Scripture TBD',
      devotional: json['devotional'] as String? ?? 'Study content coming soon...',
      excerpt: json['excerpt'] as String? ?? 'No excerpt available',
      discussionJson: _safeParseDiscussion(json['discussion_json']),
      isToday: json['is_today'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  static Map<String, dynamic> _safeParseDiscussion(dynamic discussionData) {
    if (discussionData is Map<String, dynamic>) {
      return discussionData;
    }
    return {'questions': [], 'reflection': 'Discussion questions coming soon...'};
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'topic': topic,
      'scripture': scripture,
      'devotional': devotional,
      'excerpt': excerpt,
      'discussion_json': discussionJson,
      'is_today': isToday,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  BibleStudy copyWith({
    int? id,
    String? date,
    String? topic,
    String? scripture,
    String? devotional,
    String? excerpt,
    Map<String, dynamic>? discussionJson,
    bool? isToday,
    String? createdAt,
    String? updatedAt,
  }) {
    return BibleStudy(
      id: id ?? this.id,
      date: date ?? this.date,
      topic: topic ?? this.topic,
      scripture: scripture ?? this.scripture,
      devotional: devotional ?? this.devotional,
      excerpt: excerpt ?? this.excerpt,
      discussionJson: discussionJson ?? this.discussionJson,
      isToday: isToday ?? this.isToday,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
