// Generic Type class for value/label pairs
class TypeValue {
  final int id;
  final String value;
  final String label;
  final String description;

  TypeValue({
    this.id = 0,
    required this.value,
    this.label = '',
    this.description = '',
  });

  // Empty constructor for fallback scenarios
  factory TypeValue.empty() {
    return TypeValue(
      id: 0,
      value: '',
      label: '',
      description: '',
    );
  }

  // Default constructors for common types
  factory TypeValue.defaultChurchRole() {
    return TypeValue(
      id: 1,
      value: 'member',
      label: 'Member',
      description: 'Church member',
    );
  }

  factory TypeValue.defaultEventType() {
    return TypeValue(
      id: 1,
      value: 'general',
      label: 'General Event',
      description: 'General ministry event',
    );
  }

  factory TypeValue.defaultPrayerCategory() {
    return TypeValue(
      id: 1,
      value: 'general',
      label: 'General Prayer',
      description: 'General prayer request',
    );
  }

  // Display getters with fallbacks
  String get displayValue => value.isEmpty ? 'unknown' : value;
  String get displayLabel => label.isEmpty ? 'Unknown' : label;
  String get displayDescription =>
      description.isEmpty ? 'No description available' : description;

  factory TypeValue.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TypeValue.empty();
    
    return TypeValue(
      id: json['id'] as int? ?? 0,
      value: json['value'] as String? ?? '',
      label: json['label'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value, 
      'label': label, 
      'description': description
    };
  }

  TypeValue copyWith({
    int? id,
    String? value, 
    String? label, 
    String? description
  }) {
    return TypeValue(
      id: id ?? this.id,
      value: value ?? this.value,
      label: label ?? this.label,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeValue &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          value == other.value &&
          label == other.label;

  @override
  int get hashCode => id.hashCode ^ value.hashCode ^ label.hashCode;

  @override
  String toString() =>
      'TypeValue(id: $id, value: $value, label: $label, description: $description)';
}

// Common app constants and placeholders
class AppConstants {
  static const String defaultCountry = 'Kenya';
  static const String defaultTimezone = 'Africa/Nairobi';
  static const String defaultLanguage = 'English';
  static const String defaultCurrency = 'USD';
  static const String defaultPhonePrefix = '+254';

  static const List<String> supportedLanguages = [
    'English',
    'Swahili',
    'French',
    'Spanish',
  ];

  static const List<String> supportedCountries = [
    'Kenya',
    'United States',
    'United Kingdom',
    'France',
    'Spain',
    'Other',
  ];

  static const List<String> defaultPrayerTimes = ['06:00', '12:00', '18:00'];

  static const String placeholderImageUrl =
      'https://via.placeholder.com/300x200?text=JKMG';
  static const String noDataMessage = 'No data available';
  static const String loadingMessage = 'Loading...';
  static const String errorMessage = 'Something went wrong';

  // Theme constants
  static const String lightThemeKey = 'light';
  static const String darkThemeKey = 'dark';
  static const String systemThemeKey = 'system';
}
