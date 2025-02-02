import 'package:solitaire_picker/model/history_model.dart';
import 'package:solitaire_picker/model/store_visit_model.dart';
import 'package:solitaire_picker/services/http_service.dart';

class HistoryController {
  final HttpService _httpService = HttpService();

  Future<List<HistoryModel>> getHistory(
    String pickerId,
    String search,
    String page,
    String limit,
    String status,
  ) async {
    final url =
        "/api/v1/customer-journey/picker/$pickerId?page=$page&limit=$limit&search=$search&status=$status";

    final response = await _httpService.request(
      url,
      method: HttpMethod.get,
    );

    final data = response['data']['journeys'] as List;

    return data.map((e) => HistoryModel.fromJson(e)).toList();
  }

  // get storesByJourneyId
  Future<List<StoreVisitModel>> getStoresByJourneyId(
    String journeyId,
    String search,
    String page,
    String limit,
    String status,
  ) async {
    final url =
        "/api/v1/customer-journey/$journeyId/store-visits?page=$page&limit=$limit&search=$search&status=$status";

    final response = await _httpService.request(
      url,
      method: HttpMethod.get,
    );

    final data = response['data']['storeVisits'] as List;

    return data.map((e) => StoreVisitModel.fromJson(e)).toList();
  }
}
