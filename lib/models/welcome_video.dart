class WelcomeVideo {
  final int id;
  final String title;
  final String? description;
  final String videoUrl;
  final bool isActive;

  WelcomeVideo({
    required this.id,
    required this.title,
    this.description,
    required this.videoUrl,
    required this.isActive,
  });

  factory WelcomeVideo.fromJson(Map<String, dynamic> json) {
    return WelcomeVideo(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'],
      videoUrl: json['video_url'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'video_url': videoUrl,
      'is_active': isActive,
    };
  }
}

class WelcomeVideoResponse {
  final bool success;
  final WelcomeVideo data;
  final String message;

  WelcomeVideoResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory WelcomeVideoResponse.fromJson(Map<String, dynamic> json) {
    return WelcomeVideoResponse(
      success: json['success'] ?? false,
      data: WelcomeVideo.fromJson(json['data']),
      message: json['message'] ?? '',
    );
  }
}