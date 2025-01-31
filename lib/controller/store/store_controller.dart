import 'package:solitaire_picker/model/store_model.dart';
import 'package:solitaire_picker/services/http_service.dart';
import 'package:solitaire_picker/utils/app_preferences.dart';

class StoreController {
  final HttpService _httpService = HttpService();

  Future<List<StoreModel>> getStores(String search, int page, int limit) async {
    final url = "/api/v1/stores?page=$page&limit=$limit&search=$search";
    final token = await AppPreferences.getToken();

    final response = await _httpService.request(
      url,
      method: HttpMethod.get,
      additionalHeaders: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = response['data']['stores'] as List;

    return data.map((store) => StoreModel.fromJson(store)).toList();
  }

  Future<StoreModel> getStoreByQRCode(String qrCode) async {
    final url = "/api/v1/stores/qr/$qrCode";
    final token = await AppPreferences.getToken();

    final response = await _httpService.request(
      url,
      method: HttpMethod.get,
      additionalHeaders: {'Authorization': 'Bearer $token'},
    );

    final data = response['data'];

    return StoreModel.fromJson(data);
  }

  Future<StoreModel> getStoreByNFC(String nfc) async {
    final url = "/api/v1/stores/nfc/$nfc";
    final token = await AppPreferences.getToken();

    final response = await _httpService.request(
      url,
      method: HttpMethod.get,
      additionalHeaders: {'Authorization': 'Bearer $token'},
    );

    final data = response['data'];

    return StoreModel.fromJson(data);
  }
}
