// Donation Model with comprehensive null safety
import 'models.dart';

class Donation {
  final String id;
  final String amount;
  final TypeValue method;
  final String purpose;
  final TypeValue status;
  final String paymentRef;
  final bool isCompleted;
  final bool isPending;
  final bool isFailed;
  final String createdAt;
  final String updatedAt;

  // Display getters with fallbacks
  String get displayId => id.isEmpty ? '0' : id;
  String get displayAmount => amount.isEmpty ? '0' : amount;
  String get displayMethod => method.value.isEmpty ? 'Unknown' : method.value;
  String get displayPurpose => purpose.isEmpty ? 'General Donation' : purpose;
  String get displayStatus => status.value.isEmpty ? 'Unknown' : status.value;
  String get displayPaymentRef => paymentRef.isEmpty ? 'N/A' : paymentRef;
  double get amountValue {
    try {
      return double.parse(amount.replaceAll(RegExp(r'[^0-9.]'), ''));
    } catch (e) {
      return 0.0;
    }
  }
  String get formattedAmount {
    final value = amountValue;
    if (value == 0) return 'KSh 0';
    return 'KSh ${value.toStringAsFixed(2)}';
  }
  String get statusColor {
    if (isCompleted) return 'green';
    if (isPending) return 'orange';
    if (isFailed) return 'red';
    return 'gray';
  }

  Donation({
    required this.id,
    required this.amount,
    required this.method,
    required this.purpose,
    required this.status,
    required this.paymentRef,
    required this.isCompleted,
    required this.isPending,
    required this.isFailed,
    required this.createdAt,
    required this.updatedAt,
  });

  // Default constructor for fallback scenarios
  factory Donation.empty() {
    final now = DateTime.now().toIso8601String();
    return Donation(
      id: '0',
      amount: '0',
      method: TypeValue(id: 0, value: 'Unknown'),
      purpose: 'General Donation',
      status: TypeValue(id: 0, value: 'Pending'),
      paymentRef: 'N/A',
      isCompleted: false,
      isPending: true,
      isFailed: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory Donation.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Donation.empty();
    
    return Donation(
      id: json['id']?.toString() ?? '0',
      amount: json['amount']?.toString() ?? '0',
      method: json['method'] != null 
          ? TypeValue.fromJson(json['method'] as Map<String, dynamic>) 
          : TypeValue(id: 0, value: 'Unknown'),
      purpose: json['purpose'] as String? ?? 'General Donation',
      status: json['status'] != null 
          ? TypeValue.fromJson(json['status'] as Map<String, dynamic>) 
          : TypeValue(id: 0, value: 'Pending'),
      paymentRef: json['payment_ref'] as String? ?? 'N/A',
      isCompleted: json['is_completed'] as bool? ?? false,
      isPending: json['is_pending'] as bool? ?? true,
      isFailed: json['is_failed'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'method': method.toJson(),
      'purpose': purpose,
      'status': status.toJson(),
      'payment_ref': paymentRef,
      'is_completed': isCompleted,
      'is_pending': isPending,
      'is_failed': isFailed,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Donation copyWith({
    String? id,
    String? amount,
    TypeValue? method,
    String? purpose,
    TypeValue? status,
    String? paymentRef,
    bool? isCompleted,
    bool? isPending,
    bool? isFailed,
    String? createdAt,
    String? updatedAt,
  }) {
    return Donation(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      purpose: purpose ?? this.purpose,
      status: status ?? this.status,
      paymentRef: paymentRef ?? this.paymentRef,
      isCompleted: isCompleted ?? this.isCompleted,
      isPending: isPending ?? this.isPending,
      isFailed: isFailed ?? this.isFailed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
