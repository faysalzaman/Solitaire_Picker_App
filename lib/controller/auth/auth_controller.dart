import 'package:solitaire_picker/services/http_service.dart';
import 'package:solitaire_picker/utils/app_preferences.dart';

class AuthController {
  final HttpService _httpService = HttpService();

  Future<void> loginUser(String email, String password) async {
    const url = "/api/v1/pickers/login";

    final response = await _httpService.request(
      url,
      method: HttpMethod.post,
      data: {
        'email': email,
        'password': password,
      },
      additionalHeaders: {
        'Content-Type': 'application/json',
      },
    );

    AppPreferences.setHasFingerprint(
        response['data']['hasFingerprint'] ?? false);
    AppPreferences.setHasNfc(response['data']['hasNfcCard'] ?? false);
    AppPreferences.setToken(response['data']['token']);
    AppPreferences.setUserId(response['data']['id']);
    AppPreferences.setName(response['data']['name']);
    AppPreferences.setEmail(response['data']['email']);
    AppPreferences.setPhone(response['data']['phone']);
    AppPreferences.setStatus(response['data']['status']);
    AppPreferences.setAvgRating(response['data']['avgRating']);
  }

  Future<void> loginWithFingerprint(String email) async {
    const url = "/api/v1/pickers/login-fingerprint";

    final response = await _httpService.request(
      url,
      method: HttpMethod.post,
      data: {'email': email},
      additionalHeaders: {
        'Content-Type': 'application/json',
      },
    );

    AppPreferences.setHasFingerprint(
        response['data']['hasFingerprint'] ?? false);
    AppPreferences.setHasNfc(response['data']['hasNfcCard'] ?? false);
    AppPreferences.setToken(response['data']['token']);
    AppPreferences.setUserId(response['data']['id']);
    AppPreferences.setName(response['data']['name']);
    AppPreferences.setEmail(response['data']['email']);
    AppPreferences.setPhone(response['data']['phone']);
    AppPreferences.setStatus(response['data']['status']);
    AppPreferences.setAvgRating(response['data']['avgRating']);
  }

  Future<void> loginWithNfc(String nfcCardId) async {
    const url = "/api/v1/pickers/login-nfc";

    final response = await _httpService.request(
      url,
      method: HttpMethod.post,
      data: {'nfcCardId': nfcCardId},
    );

    AppPreferences.setHasFingerprint(
        response['data']['hasFingerprint'] ?? false);
    AppPreferences.setHasNfc(response['data']['hasNfcCard'] ?? false);
    AppPreferences.setToken(response['data']['token']);
    AppPreferences.setUserId(response['data']['id']);
    AppPreferences.setName(response['data']['name']);
    AppPreferences.setEmail(response['data']['email']);
    AppPreferences.setPhone(response['data']['phone']);
    AppPreferences.setStatus(response['data']['status']);
    AppPreferences.setAvgRating(response['data']['avgRating']);
  }
}
