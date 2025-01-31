import 'package:solitaire_picker/model/journey_model.dart';
import 'package:solitaire_picker/services/http_service.dart';
import 'package:solitaire_picker/utils/app_preferences.dart';

class JourneyController {
  final HttpService _httpService = HttpService();

  Future<JourneyModel> createJourney(String customerId) async {
    final url = "/api/v1/customer-journey/start";
    final token = await AppPreferences.getToken();

    final response = await _httpService.request(
      url,
      method: HttpMethod.post,
      additionalHeaders: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      data: {'customerId': customerId},
    );

    final data = response['data'];

    return JourneyModel.fromJson(data);
  }

  Future<JourneyModel> endJourney(String journeyId) async {
    final url = "/api/v1/customer-journey/end/$journeyId";
    final token = await AppPreferences.getToken();

    final response = await _httpService.request(
      url,
      method: HttpMethod.put,
      additionalHeaders: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = response['data']['journey'];

    return JourneyModel.fromJson(data);
  }

  Future<StoreVisits> storeEntry(
    String journeyId,
    String storeId,
    String scanType,
  ) async {
    final url = "/api/v1/customer-journey/store-entry";
    final token = await AppPreferences.getToken();

    final response = await _httpService.request(
      url,
      method: HttpMethod.post,
      additionalHeaders: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      data: {'journeyId': journeyId, 'storeId': storeId, 'scanType': scanType},
    );

    final data = response['data'];

    return StoreVisits.fromJson(data);
  }

  Future<StoreVisits> storeExit(String journeyId, String storeId) async {
    final url = "/api/v1/customer-journey/store-exit";
    final token = await AppPreferences.getToken();

    final response = await _httpService.request(
      url,
      method: HttpMethod.post,
      additionalHeaders: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      data: {'journeyId': journeyId, 'storeId': storeId},
    );

    final data = response['data'];

    return StoreVisits.fromJson(data);
  }
}
