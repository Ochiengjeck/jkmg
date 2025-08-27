// Pastor Model for Daily Prayer
class Pastor {
  final int id;
  final String name;

  Pastor({
    required this.id,
    required this.name,
  });

  factory Pastor.empty() {
    return Pastor(
      id: 0,
      name: '',
    );
  }

  factory Pastor.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Pastor.empty();

    return Pastor(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// Daily Prayer Model for daily prayer request response
class DailyPrayer {
  final int id;
  final String title;
  final String message;
  final String? audioUrl;
  final String status;
  final Pastor pastor;
  final String prayedAt;
  final String createdAt;

  // Display getters
  String get displayTitle => title.isEmpty ? 'Daily Prayer' : title;
  String get displayMessage => message.isEmpty ? 'No prayer message available' : message;
  String get displayPastorName => pastor.name.isEmpty ? 'Pastor' : pastor.name;
  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;
  String get displayStatus => status.isEmpty ? 'general_prayer' : status;

  DailyPrayer({
    required this.id,
    required this.title,
    required this.message,
    this.audioUrl,
    required this.status,
    required this.pastor,
    required this.prayedAt,
    required this.createdAt,
  });

  // Default constructor for fallback scenarios
  factory DailyPrayer.empty() {
    final now = DateTime.now();
    return DailyPrayer(
      id: 0,
      title: '',
      message: '',
      audioUrl: null,
      status: 'general_prayer',
      pastor: Pastor.empty(),
      prayedAt: now.toIso8601String(),
      createdAt: now.toIso8601String(),
    );
  }

  factory DailyPrayer.fromJson(Map<String, dynamic>? json) {
    if (json == null) return DailyPrayer.empty();

    return DailyPrayer(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      audioUrl: json['audio_url'] as String?,
      status: json['status'] as String? ?? 'general_prayer',
      pastor: json['pastor'] != null
          ? Pastor.fromJson(json['pastor'] as Map<String, dynamic>)
          : Pastor.empty(),
      prayedAt: json['prayed_at'] as String? ?? DateTime.now().toIso8601String(),
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'audio_url': audioUrl,
      'status': status,
      'pastor': pastor.toJson(),
      'prayed_at': prayedAt,
      'created_at': createdAt,
    };
  }

  DailyPrayer copyWith({
    int? id,
    String? title,
    String? message,
    String? audioUrl,
    String? status,
    Pastor? pastor,
    String? prayedAt,
    String? createdAt,
  }) {
    return DailyPrayer(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      audioUrl: audioUrl ?? this.audioUrl,
      status: status ?? this.status,
      pastor: pastor ?? this.pastor,
      prayedAt: prayedAt ?? this.prayedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}