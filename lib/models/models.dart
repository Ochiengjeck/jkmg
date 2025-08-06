import 'dart:convert';

// Generic Type class for value/label pairs
class TypeValue {
  final String value;
  final String label;
  final String? description;

  TypeValue({required this.value, required this.label, this.description});

  factory TypeValue.fromJson(Map<String, dynamic> json) {
    return TypeValue(
      value: json['value'] as String,
      label: json['label'] as String,
      description: json['description'] as String?,
    );
  }
}
