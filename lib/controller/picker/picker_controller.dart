import 'package:solitaire_picker/model/active_picker_model.dart';
import 'package:solitaire_picker/services/http_service.dart';
import 'package:solitaire_picker/utils/app_preferences.dart';

class PickerController {
  final HttpService _httpService = HttpService();

  Future<List<ActivePickerModel>> getPickers(int page, int limit) async {
    final url = "/api/v1/picker-requests/picker?page=$page&limit=$limit";

    final response = await _httpService.request(url, method: HttpMethod.get);

    var pickers = response['data']['requests'] as List;
    return pickers.map((item) => ActivePickerModel.fromJson(item)).toList();
  }

  Future<void> submitReview(
      String pickerId, double rating, String comments) async {
    const url = "/api/v1/customers/review";
    _httpService.request(
      url,
      method: HttpMethod.post,
      data: {
        "pickerId": pickerId,
        "rating": rating,
        "comment": comments,
      },
      additionalHeaders: {
        "Content-Type": "application/json",
      },
    );
  }

  Future<void> acceptDeclinePicker(String requestId, bool accept) async {
    final token = AppPreferences.getToken();
    const url = "/api/v1/picker-requests/respond";
    await _httpService.request(
      url,
      method: HttpMethod.patch,
      data: {"requestId": requestId, "accept": accept},
      additionalHeaders: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
  }
}
