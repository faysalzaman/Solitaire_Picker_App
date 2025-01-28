// import 'package:solitaire_picker/model/payment_history_model.dart';
// import 'package:solitaire_picker/services/http_service.dart';
// import 'package:solitaire_picker/utils/app_preferences.dart';

// class TopupController {
//   final HttpService _httpService = HttpService();

//   Future<void> topup(
//     double amount,
//     String paymentMethod,
//     // String transactionFee,
//   ) async {
//     final token = AppPreferences.getToken();
//     const url = "/api/v1/wallet-topups";
//     final response = await _httpService.request(
//       url,
//       method: HttpMethod.post,
//       data: {
//         "amount": amount,
//         "paymentMethod": paymentMethod,
//       },
//       additionalHeaders: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );

//     AppPreferences.setCurrentBalance(
//         response['data']['wallet']['currentBalance']);
//   }

//   Future<List<PaymentHistory>> getPaymentHistory(
//     int page,
//     int limit,
//   ) async {
//     final token = AppPreferences.getToken();
//     final url = "/api/v1/wallet-topups/history?page=$page&limit=$limit";
//     final response = await _httpService.request(
//       url,
//       method: HttpMethod.get,
//       additionalHeaders: {
//         "Authorization": "Bearer $token",
//       },
//     );

//     return (response['data']['topups'] as List)
//         .map((item) => PaymentHistory.fromJson(item))
//         .toList();
//   }
// }
