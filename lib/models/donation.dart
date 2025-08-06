// Donation Model
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

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'] as String,
      amount: json['amount'] as String,
      method: TypeValue.fromJson(json['method'] as Map<String, dynamic>),
      purpose: json['purpose'] as String,
      status: TypeValue.fromJson(json['status'] as Map<String, dynamic>),
      paymentRef: json['payment_ref'] as String,
      isCompleted: json['is_completed'] as bool,
      isPending: json['is_pending'] as bool,
      isFailed: json['is_failed'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
