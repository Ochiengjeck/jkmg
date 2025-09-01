class Slider {
  final int id;
  final String title;
  final String? caption;
  final String image;
  final int sortOrder;
  final String imageUrl;

  Slider({
    required this.id,
    required this.title,
    this.caption,
    required this.image,
    required this.sortOrder,
    required this.imageUrl,
  });

  factory Slider.fromJson(Map<String, dynamic> json) {
    return Slider(
      id: json['id'],
      title: json['title'] ?? '',
      caption: json['caption'],
      image: json['image'] ?? '',
      sortOrder: json['sort_order'] ?? 0,
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'caption': caption,
      'image': image,
      'sort_order': sortOrder,
      'image_url': imageUrl,
    };
  }
}

class SliderResponse {
  final bool success;
  final List<Slider> data;
  final String message;

  SliderResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory SliderResponse.fromJson(Map<String, dynamic> json) {
    return SliderResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => Slider.fromJson(item))
          .toList(),
      message: json['message'] ?? '',
    );
  }
}