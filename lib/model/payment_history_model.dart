// class PaymentHistory {
//   final String id;
//   final double amount;
//   final double transactionFee;
//   final double totalAmount;
//   final String status;
//   final String paymentMethod;
//   final DateTime createdAt;

//   PaymentHistory({
//     required this.id,
//     required this.amount,
//     required this.transactionFee,
//     required this.totalAmount,
//     required this.status,
//     required this.paymentMethod,
//     required this.createdAt,
//   });

//   // Convert from JSON
//   factory PaymentHistory.fromJson(Map<String, dynamic> json) {
//     return PaymentHistory(
//       id: json['id'] as String,
//       amount: (json['amount'] as num).toDouble(),
//       transactionFee: (json['transactionFee'] as num).toDouble(),
//       totalAmount: (json['totalAmount'] as num).toDouble(),
//       status: json['status'] as String,
//       paymentMethod: json['paymentMethod'] as String,
//       createdAt: DateTime.parse(json['createdAt'] as String),
//     );
//   }

//   // Convert to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'amount': amount,
//       'transactionFee': transactionFee,
//       'totalAmount': totalAmount,
//       'status': status,
//       'paymentMethod': paymentMethod,
//       'createdAt': createdAt.toIso8601String(),
//     };
//   }

//   // Copy with method for immutability
//   PaymentHistory copyWith({
//     String? id,
//     double? amount,
//     double? transactionFee,
//     double? totalAmount,
//     String? status,
//     String? paymentMethod,
//     DateTime? createdAt,
//   }) {
//     return PaymentHistory(
//       id: id ?? this.id,
//       amount: amount ?? this.amount,
//       transactionFee: transactionFee ?? this.transactionFee,
//       totalAmount: totalAmount ?? this.totalAmount,
//       status: status ?? this.status,
//       paymentMethod: paymentMethod ?? this.paymentMethod,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }
// }
